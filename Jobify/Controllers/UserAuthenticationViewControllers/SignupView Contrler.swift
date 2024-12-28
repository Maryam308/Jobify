//
//  SeekerSignupViewController.swift
//  Jobify
//
//  Created by Zainab Alawi on 23/12/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Alamofire



class signupViewController: UIViewController {
    
    
    @IBOutlet weak var btnSeeker: UIButton!
    
    @IBOutlet weak var btnEmployer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


//MARK: job seeker sign-up view controler
class SeekerSignupViewController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    struct CloudinaryResponse: Decodable {
        let secure_url: String
    }
    
    var userRef: DocumentReference? = nil
    var profileImage: UIImage?
    
    @IBOutlet weak var profileImg: UIImageView!
    
    var profileImageURL: String?
    let db = Firestore.firestore()
    var uploadedImageURL: String? // To store the uploaded image link
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtJobPosition: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var imgSeekerProfilePic: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgSeekerProfilePic.layer.cornerRadius = imgSeekerProfilePic.frame.size.width / 2
        imgSeekerProfilePic.contentMode = .scaleAspectFill
        imgSeekerProfilePic.clipsToBounds = true
        
        
    }
    
    // Function to show alerts in specific shape
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: validateInput() = function for input validation
    private func validateInput() -> Bool {
        // Check if Name is filled
        if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Name field must be filled.")
            return false
        }
        
        // Check if Email is filled
        if txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Email field must be filled.")
            return false
        }
        
        // Check if Password is filled
        if txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Password field must be filled.")
            return false
        }
        
        // Check if Confirm Password is filled
        if txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Confirm Password field must be filled.")
            return false
        }
        
        // Check if Password and Confirm Password match
        if txtPassword.text != txtConfirmPassword.text {
            showAlert(message: "Passwords entered do not match.")
            return false
        }
        
        // Check if Current Job Position is filled
        if txtJobPosition.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Job Category field must be filled.")
            return false
        }
        
        // All fields are filled
        return true
    }
    
    //MARK: saveUserData() used to add the user firestore
    private func saveUserData(user: User, completion: @escaping (DocumentReference?) -> Void) {
        let db = Firestore.firestore()
        let userType: DocumentReference = db.collection("usertype").document("user3")
        
        // Prepare the user data
        let userData: [String: Any] = [
            "name": user.name,
            "userId": user.userID, // Ensure userId is set via fetchAndSetID
            "email": user.email,
            "userType": userType,
            "profileImageURL": user.imageURL ?? NSNull() // Use NSNull for missing image
        ]
        
        // Save user data and return the generated DocumentReference
        db.collection("users").addDocument(data: userData) { error in
            if let error = error {
                print("Failed to save user: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            let userRef = db.collection("users").document() // Use generated DocumentReference
            completion(userRef)
        }
    }

    
    //MARK: fetchUserDocument is used to fetch the user document reference
    private func fetchUserDocument(userId: Int) {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("userId", isEqualTo: userId).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                self?.showAlert(message: "Failed to fetch user document reference: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                self?.showAlert(message: "User document not found.")
                return
            }
            
            // Assign the fetched DocumentReference to the class-level variable
            self?.userRef = document.reference
            print("Fetched user document reference: \(String(describing: self?.userRef?.path))")
        }
    }
    
    @IBAction func btnAddPhotoTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImg.image = editedImage // Preview the selected image
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImg.image = originalImage // Preview the selected image
        }
        dismiss(animated: true)
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
    
    
    
    
    @IBAction func btnNext(_ sender: Any) {
        Task { @MainActor in
            guard validateInput() else { return }
            
            var profileImageUrl: String? = nil
            
            // Check if a profile image exists and upload it
            if let profileImage = profileImg.image,
               let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                do {
                    profileImageUrl = try await uploadImageToCloudinary(imageData: imageData)
                } catch {
                    print("Image upload failed: \(error.localizedDescription)")
                    profileImageUrl = nil // Proceed without image
                }
            }
            
            // Fetch and set the userId, then create the User object
            User.fetchAndSetID { [weak self] in
                guard let self = self else { return }
                
                guard let name = self.txtName.text, !name.isEmpty,
                      let email = self.txtEmail.text, !email.isEmpty,
                      let city = self.txtCity.text, !city.isEmpty else {
                    self.showAlert(message: "All fields must be filled.")
                    return
                }
                
                // Create the User object, which now includes a userId
                let user = User(
                    name: name,
                    email: email,
                    role: UserType.seeker,
                    city: city,
                    profileImageURL: profileImageUrl
                )
                
                // Firebase Authentication
                Auth.auth().createUser(withEmail: email, password: self.txtPassword.text!) { authResult, error in
                    if let error = error {
                        self.showAlert(message: "Failed to create user: \(error.localizedDescription)")
                        return
                    }
                    
                    // Save the user data in Firestore
                    self.saveUserData(user: user) { userRef in
                        guard let userRef = userRef else {
                            self.showAlert(message: "Failed to save user data.")
                            return
                        }
                        
                        print("User created successfully with reference: \(userRef.path)")
                        
                        // Create seeker details document
                        let seekerDetailsData: [String: Any] = [
                            "currentJobPosition": self.txtJobPosition.text ?? "",
                            "userID": userRef, // Firestore DocumentReference
                            "savedLearningResourcesList": [],
                            "seekerCvs": []
                        ]
                        
                        self.db.collection("seekerDetails").addDocument(data: seekerDetailsData) { error in
                            if let error = error {
                                print("Failed to save seeker details: \(error.localizedDescription)")
                            } else {
                                print("Seeker details successfully saved!")
                                
                                // Navigate to the SelectCategory screen
                               
                                if let secondScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "selectCategory") as? SelectCategoryViewConroller {
                                    secondScreenVC.docRef = userRef
                                    print(userRef)
                                    
                                    // Otherwise, push the new instance
                                        self.navigationController?.pushViewController(secondScreenVC, animated: true)
                                    
                                }
                                
                                                            }
                        }
                    }
                }
            }
        }
    }
    

    
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.profileImg.image = UIImage(systemName: "person.crop.circle") // Fallback image
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.profileImg.image = image // Update the imageView directly
                } else {
                    self.profileImg.image = UIImage(systemName: "person.crop.circle") // Fallback image
                }
            }
        }
        task.resume()
    }

    
    
    
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**=====================================================================================================================================**/
    
    
    //MARK: company/employer sign-up view controler
    class employerSignupViewController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
        
        var userRef: DocumentReference? = nil
        let db = Firestore.firestore()
        
        //@IBOutlet weak var imgProfilePic: UIImageView!
        @IBOutlet weak var imgEmployerProfilePic: UIImageView!
        
        @IBOutlet weak var txtName: UITextField!
        @IBOutlet weak var txtEmail: UITextField!
        @IBOutlet weak var txtPassword: UITextField!
        @IBOutlet weak var txtConfirmPassword: UITextField!
        @IBOutlet weak var txtComapanyCategory: UITextField!
        
        @IBOutlet weak var txtCity: UITextField!
        
        
        
        @IBOutlet weak var btnUploadEmployer: UIButton!
        
        
        @IBAction func btnUploadEmployerTapped(_ sender: UIButton) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
        
        // MARK: - UIImagePickerControllerDelegate Methods
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let editedImage = info[.editedImage] as? UIImage {
                imgEmployerProfilePic.image = editedImage // Preview the selected image
            } else if let originalImage = info[.originalImage] as? UIImage {
                imgEmployerProfilePic.image = originalImage // Preview the selected image
            }
            dismiss(animated: true)
            
        }
        
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }

        
            override func viewDidLoad() {
                super.viewDidLoad()
                imgEmployerProfilePic.layer.cornerRadius = imgEmployerProfilePic.frame.size.width / 2
                imgEmployerProfilePic.contentMode = .scaleAspectFill
                imgEmployerProfilePic.clipsToBounds = true
            }
            
            private func showAlert(message: String) {
                let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            private func validateInput() -> Bool {
                if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    showAlert(message: "Name field must be filled.")
                    return false
                }
                if txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    showAlert(message: "Email field must be filled.")
                    return false
                }
                if txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    showAlert(message: "Password field must be filled.")
                    return false
                }
                if txtConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    showAlert(message: "Confirm Password field must be filled.")
                    return false
                }
                if txtPassword.text != txtConfirmPassword.text {
                    showAlert(message: "Passwords entered do not match.")
                    return false
                }
                if txtComapanyCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                    showAlert(message: "Company Category field must be filled.")
                    return false
                }
                return true
            }
            
            private func saveUserData(user: User, completion: @escaping (DocumentReference?) -> Void) {
                let userType: DocumentReference = db.collection("usertype").document("user3")
                let userData: [String: Any] = [
                    "name": user.name,
                    "userId": user.userID,
                    "email": user.email,
                    "userType": userType,
                    "profileImageURL": user.imageURL ?? NSNull()
                ]
                
                db.collection("users").addDocument(data: userData) { [self] error in
                    if let error = error {
                        print("Failed to save user: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        let documentRef = db.collection("users").document(user.userID.description)
                        completion(documentRef)
                    }
                }
            }
            
            private func uploadImageToCloudinary(imageData: Data) async throws -> String {
                let cloudinaryURL = "https://api.cloudinary.com/v1_1/dvxwcsscw/image/upload"
                let uploadPreset = "JobifyImages"
                let parameters: [String: String] = ["upload_preset": uploadPreset]
                
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
                            continuation.resume(returning: cloudinaryResponse.secure_url)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        
        //btn click
        @IBAction func btnSignUp(_ sender: Any) {
            
            Task { @MainActor in
                       guard validateInput() else { return }
                       
                       var profileImageUrl: String? = nil
                       
                       // Check if a profile image exists and upload it
                       if let profileImage = imgEmployerProfilePic.image,
                          let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                           do {
                               profileImageUrl = try await uploadImageToCloudinary(imageData: imageData)
                           } catch {
                               print("Image upload failed: \(error.localizedDescription)")
                               profileImageUrl = nil // Proceed without image
                           }
                       }
                       
                       User.fetchAndSetID { [weak self] in
                           guard let self = self else { return }
                           
                           guard let name = self.txtName.text, !name.isEmpty,
                                 let email = self.txtEmail.text, !email.isEmpty,
                                 let city = self.txtCity.text, !city.isEmpty else {
                               self.showAlert(message: "All fields must be filled.")
                               return
                           }
                           
                           let user = User(
                               name: name,
                               email: email,
                               role: UserType.employer,
                               city: city,
                               profileImageURL: profileImageUrl
                           )
                           
                           Auth.auth().createUser(withEmail: email, password: self.txtPassword.text!) { authResult, error in
                               if let error = error {
                                   self.showAlert(message: "Failed to create user: \(error.localizedDescription)")
                                   return
                               }
                               
                               self.saveUserData(user: user) { userRef in
                                   guard let userRef = userRef else {
                                       self.showAlert(message: "Failed to save user data.")
                                       return
                                   }
                                   
                                   let employerDetailsData: [String: Any] = [
                                       "companyMainCategory": self.txtComapanyCategory.text ?? "",
                                       "userID": userRef,
                                       "aboutUs": "",
                                       "ourEmployiblityGoals": "",
                                       "ourVision": ""
                                   ]
                                   
                                   self.db.collection("employerDetails").addDocument(data: employerDetailsData) { error in
                                       if let error = error {
                                           print("Failed to save employer details: \(error.localizedDescription)")
                                       } else {
                                           print("Employer details successfully saved!")
                                           
                                           // Navigate to the SelectCategory screen
                                           if let logIn = self.storyboard?.instantiateViewController(withIdentifier: "loginScreenViewControler") as? LoginViewController {
                                               self.navigationController?.pushViewController(logIn, animated: true)
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
        
        
        private func loadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.imgEmployerProfilePic.image = UIImage(systemName: "person.crop.circle") // Fallback image
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imgEmployerProfilePic.image = image // Update the imageView directly
                    } else {
                        self.imgEmployerProfilePic.image = UIImage(systemName: "person.crop.circle") // Fallback image
                    }
                }
            }
            task.resume()
        }
        
        
            
        }
        
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

