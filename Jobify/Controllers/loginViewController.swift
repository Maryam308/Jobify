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
        
        //UserSession.shared.loggedInUser = currentUser
       
    }
    
    // Function to show alerts in specific shape
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
                var userTypeAdmin: DocumentReference = db.collection("usertype").document("user1")
                var userTypeEmployer: DocumentReference = db.collection("usertype").document("user2")
                var userTypeSeeker: DocumentReference = db.collection("usertype").document("user3")
                
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
                                    //usertype/user3
                                    // Create a session for the authenticated user
                                    UserSession.shared.loggedInUser = User(
                                        userID: userID,
                                        name: name,
                                        email: email,
                                        role: role,
                                        imageURL: nil
                                    )
                    
                                    // Notify the user
                                    self.showAlert(message: "Login Successful")

                    // Navigate to home screen
                    self.performSegue(withIdentifier: "loginTwo", sender: self)
                }
            }
        }
        
    }
}
