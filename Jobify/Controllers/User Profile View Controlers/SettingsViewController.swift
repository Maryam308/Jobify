//
//  Untitled.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

//SettingsViewController
import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet var viewProfileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserSession.shared.loggedInUser!.role == .admin{
            viewProfileBtn.isHidden = true
        }
    }
    @IBAction func viewProfileBtnClicked(_ sender: Any) {
        let role = UserSession.shared.loggedInUser!.role
        if role == .seeker {
            performSegue(withIdentifier: "showSeekerPreview", sender: self)
        } else if role == .employer {
            performSegue(withIdentifier: "showEmployerPreview", sender: self)
        }
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        // Terminate the user session
            UserSession.shared.loggedInUser = nil

            // Navigate back to the login screen
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginNavigationController") {
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true, completion: nil)
            }
    }
}


class settingsSignInAndSecurityViewController: UIViewController{
    
}

class settingsAccountViewController:  UIViewController{
    
    @IBOutlet weak var deleteAccount: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteAccount.layer.cornerRadius = 15.0
        deleteAccount.clipsToBounds = true
    }
    
    @IBAction func btnDeleteAccount(_ sender: Any) {
        
        // Show the alert to confirm deletion
        let alertController = UIAlertController(
            title: "Confirm Account Deletion",
            message: "Are you sure you want to delete the account? All associated data will be permanently deleted.",
            preferredStyle: .alert
        )
        
        // Add the "Confirm" action (in red)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteAccountAndData()
        }))
        
        // Add the "Cancel" action (in default style)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    private func deleteAccountAndData(){
        
        // Fetch the user and role details
            guard let user = UserSession.shared.loggedInUser else {
                print("No user is logged in.")
                return
            }
            let userId = user.userID
            let userRole = user.role
            let db = Firestore.firestore()
            
            print("User ID: \(userId)")
            print("User Role: \(userRole)")
            
            // Fetch the user document
            db.collection("users").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("User document not found.")
                    return
                }
                
                if documents.count > 1 {
                    print("Warning: Multiple user documents found. Only the first one will be deleted.")
                }
                
                // Get the first document reference
                let userDocumentReference = documents.first!.reference
                print("Deleting user document at path: \(userDocumentReference.path)")
                
                // Delete the document
                userDocumentReference.delete { error in
                    if let error = error {
                        print("Error deleting user document: \(error.localizedDescription)")
                        return
                    }
                    
                    print("User document successfully deleted from Firestore.")
                    // Trigger additional cleanup or UI updates if necessary
                }
                
                //Deletion process
                Task {
                    do {
                        //Checks whether the user was admin to delete from the associated tables
                        if userRole == .admin {
                            // Delete from "users" collection using the fetched reference
                            try await userDocumentReference.delete()
                            print("Deleted admin user document from 'users' collection.")
                        }
                        
                        //Checks whether the user was seeker to delete from the associated tables
                        else if userRole == .employer {
                            // Delete from "users" collection using the fetched reference
                            try await userDocumentReference.delete()
                            print("Deleted user document from 'users' collection.")
                            
                            // Delete from "employerDetails" collection
                            let employerDetailsRef = db.collection("employerDetails").whereField("userID", isEqualTo: userDocumentReference)
                            let employerDocuments = try await employerDetailsRef.getDocuments()
                            for document in employerDocuments.documents {
                                try await document.reference.delete()
                            }
                            print("Deleted all documents from 'employerDetails' collection for user \(userId).")
                        }
                        
                        //Checks if the user is seeker to delete from the associated tables
                        else if userRole == .seeker {
                            // Delete from "users" collection using the fetched reference
                            try await userDocumentReference.delete()
                            print("Deleted user document from 'users' collection.")
                            
                            // Delete from "seekerDetails" collection
                            let seekerDetailsRef = db.collection("seekerDetails").whereField("userID", isEqualTo: userDocumentReference)
                            let seekerDocuments = try await seekerDetailsRef.getDocuments()
                            for document in seekerDocuments.documents {
                                try await document.reference.delete()
                            }
                            print("Deleted all documents from 'seekerDetails' collection for user \(userId).")
                            
                            // Delete from "selectedJobCategories" collection
                            let selectedCategoriesRef = db.collection("selectedJobCategories").whereField("userRef", isEqualTo: userDocumentReference)
                            let categoryDocuments = try await selectedCategoriesRef.getDocuments()
                            for document in categoryDocuments.documents {
                                try await document.reference.delete()
                            }
                            print("Deleted all documents from 'selectedJobCategories' collection for user \(userId).")
                        }
                        
                        else {
                            print("User role does not match expected values.")
                        }
                        
                        
                        // Step 2: Delete user from Firebase Authentication
                        if let currentUser = Auth.auth().currentUser {
                            try await currentUser.delete()
                            print("Deleted user from Firebase Authentication.")
                        } else {
                            print("No authenticated user found.")
                        }
                        
                        // Show alert
                        let alertController = UIAlertController(
                            title: "Success",
                            message: "The account and all associated data have been successfully deleted.",
                            preferredStyle: .alert
                        )
                        
                        // Add OK action with a completion handler
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            // Terminate the user session
                            UserSession.shared.loggedInUser = nil
                            
                            // Navigate back to the login screen
                            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationController") {
                                loginVC.modalPresentationStyle = .fullScreen
                                self.present(loginVC, animated: true, completion: nil)
                            }
                        }
                        alertController.addAction(okAction)
                        
                        // Present the alert
                        self.present(alertController, animated: true, completion: nil)
                    
                    }
                    catch {
                            print("Error deleting user records: \(error.localizedDescription)")
                    }
                }

            }
    }
        
}
    
    
    
    





class settingsTermsAndConditionsViewController:   UIViewController{
    
    
    @IBOutlet weak var termsAndConditions: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsAndConditions.layer.cornerRadius = 15.0
        termsAndConditions.clipsToBounds = true
    }
    
}


class termsAndConditionsPrivacyPolicyViewController:   UIViewController{
    
}

class termsAndConditionsDataRetentionPolicyViewController:   UIViewController{
    
}

class settingsFAQs:   UIViewController{
    
}



