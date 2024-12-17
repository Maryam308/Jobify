//
//  CVBuilderEditorTableViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 17/12/2024.
//

import UIKit

class CVBuilderEditorTableViewController: UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    //Education page outlets
    @IBOutlet weak var txtDegree: UITextField!
    @IBOutlet weak var txtInstitution: UITextField!
    @IBOutlet weak var educationFrom: UIDatePicker!
    @IBOutlet weak var educationTo: UIDatePicker!
    @IBOutlet weak var degreeErr: UILabel!
    @IBOutlet weak var institutionErr: UILabel!
    @IBOutlet weak var btnGoToSkills: UIButton!
    
    
    //skills page outlets
    @IBOutlet weak var txtSkill: UITextField!
    @IBOutlet weak var skillErr: UILabel!
    @IBOutlet weak var btnGoToExperience: UIButton!
    
    //experience page outlets
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    @IBOutlet weak var experienceFrom: UIDatePicker!
    @IBOutlet weak var experienceTo: UIDatePicker!
    @IBOutlet weak var txtResponsibilities: UITextField!
    @IBOutlet weak var companyErr: UILabel!
    @IBOutlet weak var roleErr: UILabel!
    @IBOutlet weak var responsibilityErr: UILabel!
    @IBOutlet weak var btnGoToPreview: UIButton!
    
    //Preview page outlets
    @IBOutlet weak var txtCVTitle: UITextField!
    @IBOutlet weak var cvTitleErr: UILabel!
    
    
    @IBAction func btnAddPhotoTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
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
        
        // Education Details
        var degree: String?
        var institution: String?
        var educationFrom: Date?
        var educationTo: Date?
        
        // Skills Details
        var skill: String?

        //Experience Details
        var company: String?
        var role: String?
        var experienceFrom: Date?
        var experienceTo: Date?
        var responsibilities: String?
        
        //Preview Details
        var cvTitle: String?
        
        private init() {}
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
         case .education:
             CVData.shared.degree = txtDegree.text
             CVData.shared.institution = txtInstitution.text
             CVData.shared.educationFrom = educationFrom.date
             CVData.shared.educationTo = educationTo.date
         case .skills:
             CVData.shared.skill = txtSkill.text
         case .experience:
             CVData.shared.company = txtCompany.text
             CVData.shared.role = txtRole.text
             CVData.shared.experienceFrom = experienceFrom.date
             CVData.shared.educationTo = experienceTo.date
             CVData.shared.responsibilities = txtResponsibilities.text
         case .preview:
             CVData.shared.cvTitle = txtCVTitle.text
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
              CVImage.image = CVData.shared.profileImage
          case .education:
              txtDegree.text = CVData.shared.degree
              txtInstitution.text = CVData.shared.institution
              if let fromDate = CVData.shared.educationFrom {
                  educationFrom.date = fromDate
              }
              if let toDate = CVData.shared.educationTo {
                  educationTo.date = toDate
              }
          case .skills:
              txtSkill.text = CVData.shared.skill
          case .experience:
              txtCompany.text = CVData.shared.company
              txtRole.text = CVData.shared.role
              if let fromDate = CVData.shared.experienceFrom {
                  experienceFrom.date = fromDate
              }
              if let toDate = CVData.shared.experienceTo {
                  experienceTo.date = toDate
              }
          case .preview:
              txtCVTitle.text = CVData.shared.cvTitle
          }
      }
  
    @IBAction func btnGotToEducationTapped(_ sender: UIButton) {
        saveCurrentPageData()
    }
    
    @IBAction func btnGoToSkillsTapped(_ sender: UIButton) {
        saveCurrentPageData()
    }
    
    @IBAction func btnGoToExperienceTapped(_ sender: UIButton) {
        saveCurrentPageData()
    }
    
    @IBAction func btnGoToPreviewTapped(_ sender: UIButton) {
        saveCurrentPageData()
    }
    
    // This function is called when the user finishes choosing image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Safely unwrap the selected image
        if let image = info[.editedImage] as? UIImage {
            CVImage.image = image
        } else if let image = info[.originalImage] as? UIImage {
            CVImage.image = image
        } else {
            print("Failed to load image")
        }
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPublishTapped(_ sender: UIButton) {
        guard let fname = CVData.shared.name, let email = CVData.shared.email, let phone = CVData.shared.phone, let country = CVData.shared.country, let city = CVData.shared.city, let degree = CVData.shared.degree, let institution = CVData.shared.institution, let skill = CVData.shared.skill,let company = CVData.shared.company, let role = CVData.shared.role, let responsibility = CVData.shared.responsibilities, let cvTitle = CVData.shared.cvTitle else {
            return
        }

        
        let personalDetails = PersonalDetails(name: fname, email: email, phoneNumber: phone, country: country, city:city)
        let education = [Education(degree: degree, institution:institution, startDate: Date())]
        let skills = [skill]
        let workExperience = [WorkExperience(company: company, role: role, startDate: Date(), keyResponsibilities: responsibility)]

         // Create the CV object
         let newCV = CV(personalDetails: personalDetails, skills: skills, education: education, workExperience: workExperience, name: personalDetails.name, email: personalDetails.email, phoneNumber: personalDetails.phoneNumber, country: personalDetails.country, city: personalDetails.city)

         // Store the CV in Firestore
         Task {
             do {
                 try await CVManager.createNewCV(cv: newCV)
                 print("CV created successfully")
             } catch {
                 print("Error creating CV: \(error.localizedDescription)")
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
        degreeErr.isHidden = true
        institutionErr.isHidden = true
        skillErr.isHidden = true
        companyErr.isHidden = true
        roleErr.isHidden = true
        responsibilityErr.isHidden = true
        cvTitleErr.isHidden = true
        
        //clear text fields
        txtName.text = ""
        txtEmail.text = ""
        txtPhone.text = ""
        txtCountry.text = ""
        txtCity.text = ""
        txtCity.text = ""
        txtDegree.text = ""
        txtInstitution.text = ""
        txtCompany.text = ""
        txtRole.text = ""
        txtResponsibilities.text = ""
        txtCVTitle.text = ""
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
    
    
    //functions for education validation
    //only enable the go to skills button when all fields are valid
    func checkForValidEducationForm(){
        if degreeErr.isHidden && institutionErr.isHidden{
            btnGoToSkills.isEnabled = true
        }else{
            btnGoToSkills.isEnabled = false
        }
    }
    
    
    func invalidDegree(_ value: String) -> String? {
        // Check if the degree name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the degree name contains only letters and spaces
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters and spaces only"
        }
        
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    func invalidInstitution(_ value: String) -> String? {
        // Check if the institution name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the institution name contains only letters, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces).union(CharacterSet.punctuationCharacters)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, spaces, or permissible punctuation only"
        }
        
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    
    //text fields validation for education page
    @IBAction func degreeChanged(_ sender: UITextField) {
        if let degree = txtDegree.text {
            if let errMsg = invalidDegree(degree){
                degreeErr.text = errMsg
                degreeErr.isHidden = false
            }else{
                degreeErr.isHidden = true
            }
        }
        checkForValidEducationForm()
    }
    
    @IBAction func institutionChanged(_ sender: UITextField) {
        if let institution = txtInstitution.text {
            if let errMsg = invalidInstitution(institution){
                institutionErr.text = errMsg
                institutionErr.isHidden = false
            }else{
                institutionErr.isHidden = true
            }
        }
        checkForValidEducationForm()
    }
    
    
    
    //functions for skills validation
    //only enable the go to experience button when all fields are valid
    func checkForValidSkillsForm(){
        if skillErr.isHidden{
            btnGoToExperience.isEnabled = true
        }else{
            btnGoToExperience.isEnabled = false
        }
    }
    
    
    func invalidSkill(_ value: String) -> String? {
        // Check if the skill name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the skill name contains only letters and spaces
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters and spaces only"
        }
        
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    
    //text fields validation for skills page
    @IBAction func skillChanged(_ sender: UITextField) {
        if let skill = txtSkill.text {
            if let errMsg = invalidSkill(skill){
                skillErr.text = errMsg
                skillErr.isHidden = false
            }else{
                skillErr.isHidden = true
            }
        }
        checkForValidSkillsForm()
    }
    
    //functions for experience validation
    //only enable the go to preview button when all fields are valid
    func checkForValidExperienceForm(){
        if companyErr.isHidden && roleErr.isHidden && responsibilityErr.isHidden{
            btnGoToPreview.isEnabled = true
        }else{
            btnGoToPreview.isEnabled = false
        }
    }
    
    
    
    func invalidCompany(_ value: String) -> String? {
        // Check if the company name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the company name contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)
        
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or permissible punctuation"
        }
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }
        return nil
    }
    
    func invalidRole(_ value: String) -> String? {
        // Check if the role name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        // Check if the role name contains only letters, numbers, spaces, and permissible punctuation
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
            return "Must be at least 2 characters"
        }
        return nil
    }
    
    func invalidResponsibility(_ value: String) -> String? {
        // Check if the responsibility description is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the responsibility description contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)
        
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or permissible punctuation only"
        }
        
        // Check for minimum length
        if value.count < 5 {
            return "Must be at least 5 characters"
        }

        return nil
    }
    
    //text fields validation for experience page
    @IBAction func companyChanged(_ sender: UITextField) {
        if let company = txtCompany.text {
            if let errMsg = invalidCompany(company){
                companyErr.text = errMsg
                companyErr.isHidden = false
            }else{
                companyErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
    @IBAction func roleChanged(_ sender: UITextField) {
        if let role = txtRole.text {
            if let errMsg = invalidRole(role){
                roleErr.text = errMsg
                roleErr.isHidden = false
            }else{
                roleErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
    @IBAction func responsibilityChanged(_ sender: UITextField) {
        if let responsibility = txtResponsibilities.text {
            if let errMsg = invalidResponsibility(responsibility){
                responsibilityErr.text = errMsg
                responsibilityErr.isHidden = false
            }else{
                responsibilityErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
    
    //function for preview validation
    func invalidCVTitle(_ value: String) -> String? {
        // Check if the CV title is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
        // Check if the CV title contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)
        
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or permissible punctuation only"
        }
        
        // Check for minimum length (e.g., at least 2 characters)
        if value.count < 2 {
            return "Must be at least 2 characters long"
        }

        return nil
    }
    
    //text fields validation for preview page
    @IBAction func cvTitleChanged(_ sender: UITextField) {
        if let title = txtCVTitle.text {
            if let errMsg = invalidCVTitle(title){
                cvTitleErr.text = errMsg
                cvTitleErr.isHidden = false
            }else{
                cvTitleErr.isHidden = true
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //all pages of the cv builder have 1 section
    }

    //enum to store table views tags
    enum CVSection: Int {
        case personalDetails = 101
        case education = 102
        case skills = 103
        case experience = 104
        case preview = 105
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows will be determined based on the current page using the tag
        guard let cvSection = CVSection(rawValue: tableView.tag) else { return 0 }
        switch cvSection {
        case .personalDetails: return 7
        case .education: return 6
        case .skills: return 3
        case .experience: return 6
        case .preview: return 3
        }
    }

}
