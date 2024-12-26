//
//  ResetPasswordViewControler.swift
//  Jobify
//
//  Created by Zainab Alawi on 23/12/2024.
//

import UIKit
import FirebaseAuth


class ResetPasswordViewControler: UIViewController {
    
    
    
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    
    
    
    @IBAction func btnforgotPassword(_ sender: Any) {
        
        // Validate email input
                guard let email = txtEmail.text, !email.isEmpty else {
                    showAlert(title: "Error", message: "Please enter your email address.")
                    return
                }
                
                // Send the password reset email using FirebaseAuth
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        // Handle error (e.g., invalid email, user not found)
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    // Show success message
                    self.showAlert(title: "Success", message: "A password reset link has been sent to your email.")
                }
            }
            
            // Helper function to display an alert
            private func showAlert(title: String, message: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
            }
        
}
    

