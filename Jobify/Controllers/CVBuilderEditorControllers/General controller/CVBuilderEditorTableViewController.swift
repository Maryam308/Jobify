//
//  CVBuilderEditorTableViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 17/12/2024.
//

import UIKit
import Alamofire
import Firebase
import FirebaseFirestore

// MARK: - Cloudinary Response Struct
struct CloudinaryResponse: Decodable {
    let secure_url: String
}

// MARK: - Singleton for CV Data
class CVData {
    static let shared = CVData()
    // Personal Details
    var name: String?
    var email: String?
    var phone: String?
    var country: String?
    var city: String?
    var profileImage: UIImage?
    var profileImageURL: String?
    
    // Education Details
    var education: [Education]=[]

    // Skills Details
    var skill: [cvSkills]=[]

    //Experience Details
    var experience: [WorkExperience]=[]
    
    //Preview Details
    var cvTitle: String?
    var jobTitle: String?
    
    var cvToEdit: CV?
    private init() {}
}


class CVBuilderEditorTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var educationRecords: [(degree: String, institution: String, from: Date, to: Date)] = []
    //personal page outlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var CVImage: UIImageView!
    @IBOutlet weak var nameErr: UILabel!
    @IBOutlet weak var emailErr: UILabel!
    @IBOutlet weak var phoneErr: UILabel!
    @IBOutlet weak var countryErr: UILabel!
    @IBOutlet weak var cityErr: UILabel!
    @IBOutlet weak var btnGoToEducation: UIButton!
    
    
    //Titles page outlets
    @IBOutlet weak var txtCVTitle: UITextField!
    @IBOutlet weak var cvTitleErr: UILabel!
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var jobTitleErr: UILabel!
    @IBOutlet weak var btnPublish: UIButton!
    
    @IBAction func btnAddPhotoTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            CVImage.image = editedImage
            CVData.shared.profileImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            CVImage.image = originalImage
            CVData.shared.profileImage = originalImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    // MARK: - Save Data for the Current Page
    func saveCurrentPageData() {
        guard let cvSection = CVSection(rawValue: tableView.tag) else { return }
        
        switch cvSection {
        case .personalDetails:
            CVData.shared.name = txtName.text
            CVData.shared.email = txtEmail.text
            CVData.shared.phone = txtPhone.text
            CVData.shared.country = txtCountry.text
            CVData.shared.city = txtCity.text
            CVData.shared.profileImage = CVImage.image
        case .titles:
            CVData.shared.cvTitle = txtCVTitle.text
            CVData.shared.jobTitle = txtJobTitle.text
        }
    }
    
    // MARK: - Restore Data for the Current Page
    func restoreCurrentPageData() {
        guard let cvSection = CVSection(rawValue: tableView.tag) else { return }
        
        switch cvSection {
        case .personalDetails:
            txtName.text = CVData.shared.name
            txtEmail.text = CVData.shared.email
            txtPhone.text = CVData.shared.phone
            txtCountry.text = CVData.shared.country
            txtCity.text = CVData.shared.city
            // Fetch the profile image from the URL and set it
            if let profileImageURL = CVData.shared.profileImageURL, let url = URL(string: profileImageURL) {
                loadImage(from: url) // Load and set the image
            } else {
                CVImage.image = UIImage(systemName: "person.crop.circle") // Default image
            }
            
            
        case .titles:
            txtCVTitle.text = CVData.shared.cvTitle
            txtJobTitle.text = CVData.shared.jobTitle
        }
    }
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.CVImage.image = UIImage(systemName: "person.crop.circle") // Fallback image
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.CVImage.image = image // Update the imageView directly
                } else {
                    self.CVImage.image = UIImage(systemName: "person.crop.circle") // Fallback image
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func btnGotToEducationTapped(_ sender: UIButton) {
        saveCurrentPageData()
    }
    
    @IBAction func btnPublishTapped(_ sender: UIButton) {
        // Save current page data first
          saveCurrentPageData()

          // Validate collected data
          guard let fname = CVData.shared.name,
                let email = CVData.shared.email,
                let phone = CVData.shared.phone,
                let country = CVData.shared.country,
                let city = CVData.shared.city,
                let cvTitle = CVData.shared.cvTitle,
                let jobTitle = CVData.shared.jobTitle,
                let cvImage = CVData.shared.profileImage,
                !CVData.shared.education.isEmpty,
                !CVData.shared.skill.isEmpty, !jobTitle.isEmpty, !city.isEmpty,!cvTitle.isEmpty,!fname.isEmpty,!email.isEmpty,!phone.isEmpty,!country.isEmpty else {
              let alert = UIAlertController(title: "Missing Information",
                                            message: "All fields must be filled.",
                                            preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true)
              return
          }

          Task {
              do {
                  var imageUrl: String
                  
                  // Check if we are editing an existing CV
                  if let existingCV = CVData.shared.cvToEdit {
                      // Upload the image only if it has changed
                      if let imageData = cvImage.jpegData(compressionQuality: 0.8) {
                          imageUrl = try await uploadImageToCloudinary(imageData: imageData)
                      } else {
                          imageUrl = existingCV.personalDetails.profilePicture // Use existing image URL
                      }
                      
                      // Create an updated CV object
                      let updatedCV = CV(
                          cvID: existingCV.cvID, // Use existing CV ID
                          personalDetails: PersonalDetails(
                              name: fname,
                              email: email,
                              phoneNumber: phone,
                              country: country,
                              city: city,
                              profilePicture: imageUrl
                          ),
                          skills: CVData.shared.skill.map { cvSkills(title: $0.skillTitle ?? "") },
                          education: CVData.shared.education,
                          workExperience: CVData.shared.experience,
                          cvTitle: cvTitle,
                          creationDate: existingCV.creationDate, // Keep the original creation date
                          preferredTitle: jobTitle,
                          isFavorite: existingCV.isFavorite // Preserve favorite status
                      )
                      
                      // Update the CV in Firestore
                      try await CVManager.updateExistingCV(cvID: existingCV.cvID, cv: updatedCV)
                      print("CV updated successfully.")
                      CVData.shared.cvToEdit = nil // Clear the editing context
                      
                  } else {
                      // Handle the creation of a new CV if no existing CV is being edited
                      guard let imageData = cvImage.jpegData(compressionQuality: 0.8) else {
                          print("Failed to convert image to JPEG data.")
                          return
                      }
                      
                      imageUrl = try await uploadImageToCloudinary(imageData: imageData)
                      
                      let newCV = CV(
                          personalDetails: PersonalDetails(
                              name: fname,
                              email: email,
                              phoneNumber: phone,
                              country: country,
                              city: city,
                              profilePicture: imageUrl
                          ),
                          skills: CVData.shared.skill.map { cvSkills(title: $0.skillTitle ?? "") },
                          education: CVData.shared.education,
                          workExperience: CVData.shared.experience,
                          cvTitle: cvTitle,
                          creationDate: Date(), // Set creation date to now
                          preferredTitle: jobTitle
                      )
                      
                      // Create the new CV in Firestore
                      try await CVManager.createNewCV(cv: newCV)
                      print("CV created successfully.")
                  }
                  
                  // Navigate back to the CVs view controller and refresh data
                  if let viewControllers = navigationController?.viewControllers {
                      for viewController in viewControllers {
                          if let myCVsVC = viewController as? CVBuilderEditorViewController {
                              navigationController?.popToViewController(myCVsVC, animated: true)
                              myCVsVC.fetchCVs() // Ensure the latest CVs are fetched
                              return
                          }
                      }
                  }
              } catch {
                  print("Error saving CV: \(error.localizedDescription)")
              }
          }
    }
    
   
    func uploadImageToCloudinary(imageData: Data) async throws -> String {
        let cloudinaryURL = "https://api.cloudinary.com/v1_1/dvxwcsscw/image/upload"
        let uploadPreset = "JobifyImages"
        
        let parameters: [String: String] = [
            "upload_preset": uploadPreset
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "profile.jpg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: cloudinaryURL)
            .responseDecodable(of: CloudinaryResponse.self) { response in
                switch response.result {
                case .success(let cloudinaryResponse):
                    print("Cloudinary response: \(cloudinaryResponse)") // Log the entire response
                    continuation.resume(returning: cloudinaryResponse.secure_url)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreCurrentPageData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveCurrentPageData() // Save data when navigating away

    }
    
    //will be called when user exits the personal page back to my CVs page
    func resetForm(){
        //hide error fields
        nameErr.isHidden = true
        emailErr.isHidden = true
        phoneErr.isHidden = true
        countryErr.isHidden = true
        cityErr.isHidden = true
        cvTitleErr.isHidden = true
        jobTitleErr.isHidden = true
        
        //clear text fields
        txtName.text = ""
        txtEmail.text = ""
        txtPhone.text = ""
        txtCountry.text = ""
        txtCity.text = ""
        txtCity.text = ""
        txtCVTitle.text = ""
        txtJobTitle.text = ""
    }
    
    //only enable the go to education button when all fields are valid
    func checkForValidPersonalForm(){
        if nameErr.isHidden && emailErr.isHidden && phoneErr.isHidden && countryErr.isHidden && cityErr.isHidden{
            btnGoToEducation.isEnabled = true
        }else{
            btnGoToEducation.isEnabled = false
        }
    }
    
    //functions for personal validation
    func invalidName(_ value: String) -> String? {
        // Split the input into words
        let components = value.split(separator: " ")
        // Check if there are exactly two words
        if components.count != 2 {
            return "Must contain first name and last name)"
        }
        // Check if both words are non-empty
        for component in components {
            if component.isEmpty {
                return "Must not be empty"
            }
        }
        // Check if both words contain only letters
        let nameCharacterSet = CharacterSet.letters
        for component in components {
            let set = CharacterSet(charactersIn: String(component))
            if !nameCharacterSet.isSuperset(of: set) {
                return "Must contain letters only"
            }
        }
        return nil
    }
    
    func invalidEmail(_ value: String) -> String? {
        let regexPattern = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: value.utf16.count)
        
        if regex?.firstMatch(in: value, options: [], range: range) == nil {
            return "Invalid email format"
        }
        return nil
    }
    
    func invalidPhone(_ value: String) -> String? {
        //check if all characters are digits
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set){
            return "Must contain digits only"
        }
        
        if value.count != 8 {
            return "Must be 8 digits"
        }
        return nil
    }
    
    func invalidCountry(_ value: String) -> String? {
        // Check if the country name is empty
        if value.isEmpty {
            return "Country name must not be empty"
        }
        // Check if the country name contains only letters and spaces
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters and spaces only"
        }
        
        // check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }
        return nil
    }
    
    func invalidCity(_ value: String) -> String? {
        // Check if the city name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        // Check if the city name contains only letters and spaces
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters and spaces only"
        }
        //check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    //text fields validation for personal page
    @IBAction func nameChanged(_ sender: UITextField) {
        if let name = txtName.text {
            if let errMsg = invalidName(name){
                nameErr.text = errMsg
                nameErr.isHidden = false
            }else{
                nameErr.isHidden = true
            }
        }
        checkForValidPersonalForm()
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        if let email = txtEmail.text {
            if let errMsg = invalidEmail(email){
                emailErr.text = errMsg
                emailErr.isHidden = false
            }else{
                emailErr.isHidden = true
            }
        }
        checkForValidPersonalForm()
    }

    
    @IBAction func phoneChanged(_ sender: UITextField) {
        if let phoneNumber = txtPhone.text {
            if let errMsg = invalidPhone(phoneNumber){
                phoneErr.text = errMsg
                phoneErr.isHidden = false
            }else{
                phoneErr.isHidden = true
            }
        }
        checkForValidPersonalForm()
    }
    
    @IBAction func countryChanged(_ sender: UITextField) {
        if let country = txtCountry.text {
            if let errMsg = invalidCountry(country){
                countryErr.text = errMsg
                countryErr.isHidden = false
            }else{
                countryErr.isHidden = true
            }
        }
        checkForValidPersonalForm()
    }
    
    
    
    @IBAction func cityChanged(_ sender: UITextField) {
        if let city = txtCity.text {
            if let errMsg = invalidCity(city){
                cityErr.text = errMsg
                cityErr.isHidden = false
            }else{
                cityErr.isHidden = true
            }
        }
        checkForValidPersonalForm()
    }

    
    //function for titles validation
    func checkForValidTitlesForm(){
        if cvTitleErr.isHidden && jobTitleErr.isHidden {
            btnPublish.isEnabled = true
        }else{
            btnPublish.isEnabled = false
        }
    }
    
    
    func invalidTitle(_ value: String) -> String? {
        // Check if the CV title is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the CV/Job title contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)
        
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or permissible punctuation only"
        }
        
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters long"
        }

        return nil
    }
    

    
    //text fields validation for preview page
    @IBAction func cvTitleChanged(_ sender: UITextField) {
        if let title = txtCVTitle.text {
            if let errMsg = invalidTitle(title){
                cvTitleErr.text = errMsg
                cvTitleErr.isHidden = false
            }else{
                cvTitleErr.isHidden = true
            }
        }
        checkForValidTitlesForm()
    }
    
    @IBAction func txtJobTitleChanged(_ sender: UITextField) {
        if let title = txtCVTitle.text {
            if let errMsg = invalidTitle(title){
                jobTitleErr.text = errMsg
                jobTitleErr.isHidden = false
            }else{
                jobTitleErr.isHidden = true
            }
        }
        checkForValidTitlesForm()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //all pages of the cv builder have 1 section
    }

    //enum to store table views tags
    enum CVSection: Int {
        case personalDetails = 101
        case titles = 105
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows will be determined based on the current page using the tag
        guard let cvSection = CVSection(rawValue: tableView.tag) else { return 0 }
        switch cvSection {
        case .personalDetails: return 7
        case .titles: return 3
        }
    }
    

}
