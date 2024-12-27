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
        
        let userData: [String: Any] = [
            "name": user.name,
            "userId": user.userID, // Generate a unique ID for the user
            "email": user.email,
            "userType": userType // Adjust userType value if needed
            //"profileImageUrl": ""
        ]
        
        //Save user data in "users" collection
        let newRef: DocumentReference?
        newRef = db.collection("users").addDocument(data: userData) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to save user: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            //print(newRef?.documentID)
            
            
            //Fetch the document reference for the newly created user
            //let newUserRef = db.collection("users").document(userData["userId"] as! String)
            //completion(newUserRef)
        }
        
        //print(newRef?.documentID)
        completion(newRef)
        
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
            imgSeekerProfilePic.image = editedImage // Preview the selected image
            uploadImageToCloudinary(image: editedImage) // Upload to Cloudinary
        } else if let originalImage = info[.originalImage] as? UIImage {
            imgSeekerProfilePic.image = originalImage // Preview the selected image
            uploadImageToCloudinary(image: originalImage) // Upload to Cloudinary
        }
        dismiss(animated: true)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    
    
    func uploadImageToCloudinary(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data.")
            return
        }
        
        let cloudinaryURL = "https://api.cloudinary.com/v1_1/dvxwcsscw/image/upload"
        let uploadPreset = "JobifyImages"
        
        let parameters: [String: String] = [
            "upload_preset": uploadPreset
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "profile.jpg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: cloudinaryURL)
        .responseDecodable(of: CloudinaryResponse.self) { response in
            switch response.result {
            case .success(let cloudinaryResponse):
                self.uploadedImageURL = cloudinaryResponse.secure_url // Save the uploaded image URL
                print("Image uploaded successfully: \(self.uploadedImageURL ?? "")")
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    @IBAction func btnNext(_ sender: Any) {
        
        //MARK: constructing the user
        if validateInput() {
            // Construct the user
            let user = User(name: txtName.text!, email: txtEmail.text!, role: UserType.seeker)
            
            //MARK: user authentication
            // Firebase Authentication: Create user with email and password
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.showAlert(message: "Failed to create user: \(error.localizedDescription)")
                    return
                }
                
                guard let authResult = authResult else {
                    self.showAlert(message: "Failed to create user. No auth result.")
                    return
                }
                
                // User successfully created in Authentication
                print("Firebase Auth User created with UID: \(authResult.user.uid)")
            }
            
            // Add the user to Firebase collection
            saveUserData(user: user) { [weak self] userRef in
                guard let self = self else { return }
                
                // Ensure `userRef` is available before creating `employerDetails`
                guard let userRef = userRef else {
                    self.showAlert(message: "Failed to fetch user reference.")
                    return
                }
                
                //MARK: Create a seeker details document in Firebase
                let seekerDetailsData: [String: Any] = [
                    "currentJobPosetion": self.txtJobPosition.text ?? "", // Input String
                    "userID": userRef, // DocumentReference
                    "savedLearningResourcesList": [],
                    "seekerCvs": []
                ]
                
                self.db.collection("seekerDetails").addDocument(data: seekerDetailsData) { error in
                    if let error = error {
                        print("Failed to save employer details: \(error.localizedDescription)")
                    } else {
                        print("Employer details successfully saved!")
                    }
                }
            }
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "seekerSignupToCategories" {
//            if let destinationVC = segue.destination as? SelectCategoryViewConroller {
//                // Pass the DocumentReference to the next screen
//                destinationVC.docRef = self.userRef
//            }
//        }
//    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**=====================================================================================================================================**/
    
    
    //MARK: company/employer sign-up view controler
    class employerSignupViewController: UITableViewController {
        
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
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            imgEmployerProfilePic.layer.cornerRadius = imgEmployerProfilePic.frame.size.width / 2
            imgEmployerProfilePic.contentMode = .scaleAspectFill
            imgEmployerProfilePic.clipsToBounds = true
            
            
            
        }
        
        // Function for input validation
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
            
            // Check if Job Category is filled
            if txtComapanyCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                showAlert(message: "Job Category field must be filled.")
                return false
            }
            
            // All fields are filled
            return true
        }
        
        
        
        // Updated saveUserData with completion handler
        private func saveUserData(user: User, completion: @escaping (DocumentReference?) -> Void) {
            let db = Firestore.firestore()
            
            // Prepare user data for "users" collection
            let userData: [String: Any] = [
                  "name": user.name,
                  "userId": user.userID, // Generate a unique ID for the user
                  "email": user.email,
                  "userType": "/usertype/user2" // Adjust userType value if needed
            ]
            
            // Save user data in "users" collection
            db.collection("users").addDocument(data: userData) { [weak self] error in
                if let error = error {
                    self?.showAlert(message: "Failed to save user: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // Fetch the document reference for the newly created user
                let newUserRef = db.collection("users").document(userData["userId"] as! String)
                completion(newUserRef)
            }
        }
        
        
        
        // Function to fetch the user document reference
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
        
        //
        
        
        
        // Function to show alerts in specific shape
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //btn click
        @IBAction func btnSignUp(_ sender: Any) {
            
            
            //will validate
            
            // Validate input
            if validateInput() {
                // Construct the user
                let user = User(name: txtName.text!, email: txtEmail.text!, role: UserType.employer)
                
                // Firebase Authentication: Create user with email and password
                Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] authResult, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.showAlert(message: "Failed to create user: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let authResult = authResult else {
                        self.showAlert(message: "Failed to create user. No auth result.")
                        return
                    }
                    
                    // User successfully created in Authentication
                    print("Firebase Auth User created with UID: \(authResult.user.uid)")
                    
                    
                    
                    // Add the user to Firebase collection
                    saveUserData(user: user) { [weak self] userRef in
                        guard let self = self else { return }
                        
                        // Ensure `userRef` is available before creating `employerDetails`
                        guard let userRef = userRef else {
                            self.showAlert(message: "Failed to fetch user reference.")
                            return
                        }
                        
                        // Create a details document in Firebase
                        let employerDetailsData: [String: Any] = [
                            "companyMainCategory": self.txtComapanyCategory.text ?? "", // Input String
                            "userID": userRef, // DocumentReference
                            "aboutUs": "",
                            "ourEmployiblityGoals": "",
                            "ourVision": ""
                        ]
                        
                        self.db.collection("employerDetails").addDocument(data: employerDetailsData) { error in
                            if let error = error {
                                print("Failed to save employer details: \(error.localizedDescription)")
                            } else {
                                print("Employer details successfully saved!")
                            }
                        }
                        
                        // Show success alert without navigation
                        let alert = UIAlertController(title: "Success", message: "Account created successfully!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

