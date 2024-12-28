//
//  loginViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UITableViewController {
    
    
    let db = Firestore.firestore()
   
    //textfields outlets
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    //bouttons outlets
    
    //as if the admin has logged in

    //var currentUser: User = User(userID: 1, name: "John Doe", email: "adminMaster@jobify.com", role: UserType.admin)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }
    
    // Function to show alerts in specific shape
    private func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: show a successful alert
    private func showSuccessAlert(message: String) {
        
        let alert = UIAlertController(title: "Successful Login", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Navigate to the home screen after dismissing the alert
                self.navigateToHomeScreen()
            }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: validateInput() = function for input validation
    private func validateInput() -> Bool {
        
        // Check if Email is filled
        if txtUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Email field must be filled.")
            return false
        }
        
        // Check if Password is filled
        if txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Password field must be filled.")
            return false
        }
        
        return true
        
    }
    
    
    //MARK: when clicked on login
    @IBAction func btLogin(_ sender: Any) {
        
        if validateInput() {
            
            guard let email = txtUsername.text, let password = txtPassword.text
            else {
                showAlert(message: "Email or Password is invalid.")
                return
            }
            
            // Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    // Show error message if authentication fails
                    self.showAlert(message: "Login failed: \(error.localizedDescription)")
                    return
                }
                
                
                
                let db = Firestore.firestore()
                let userTypeAdmin: DocumentReference = db.collection("usertype").document("user1")
                let userTypeEmployer: DocumentReference = db.collection("usertype").document("user2")
                let userTypeSeeker: DocumentReference = db.collection("usertype").document("user3")
                
                                db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
                                    if let error = error {
                                        self.showAlert(message: "Failed to fetch user data: \(error.localizedDescription)")
                                        return
                                    }

                                    guard let documents = querySnapshot?.documents, let document = documents.first else {
                                        self.showAlert(message: "No user data found.")
                                        return
                                    }

                                    // Extract data from the document
                                    let data = document.data()
                                    let userID = data["userId"] as? Int ?? 0
                                    let name = data["name"] as? String ?? "Unknown User"
                                    let email = data["email"] as? String ?? "No Email"
                                    let userType = data["userType"] as? DocumentReference ?? userTypeSeeker
                                    let imageURL = data["profileImageURL"] as? String ?? ""
                                    let role: UserType
                                    
                                    
                                    if userType == userTypeAdmin{
                                         role = UserType.admin
                                    }
                                    
                                    else if userType == userTypeEmployer{
                                         role = UserType.employer
                                    }
                                    
                                    else{
                                         role = UserType.seeker
                                    }

                                    // Create a session for the authenticated user
                                    UserSession.shared.loggedInUser = User(
                                        userID: userID,
                                        name: name,
                                        email: email,
                                        role: role,
                                        imageURL: imageURL
                                    )
                    
                                    // Notify the user
                                    self.showSuccessAlert(message: "Login Successful")

                                    
                                    
                                    
                                    
                                    
                }
            }
        }
        
    }
    
    private func navigateToHomeScreen() {
        // Step 1: Instantiate the Home storyboard
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)

        // Step 2: Instantiate the HomeViewController from the Home storyboard
        if let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "loginTwo") as? UITabBarController {
            // Step 3: Push the HomeViewController onto the navigation stack
            self.navigationController?.pushViewController(homeVC, animated: true)
        }

    }
    
    
    
    
    
}















    
            
            
           
