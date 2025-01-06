//
//  AdminProfileViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

import UIKit
class AdminProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
    }
    
    @IBAction func loginAsSeeker(_ sender: UIButton) {
        // Terminate the user session
            UserSession.shared.loggedInUser = nil

            // Navigate back to the login screen
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginScreenViewControler") {
                loginVC.modalPresentationStyle = .fullScreen
                
                _ = loginVC.view
                
                (loginVC as! LoginViewController).txtUsername.text = "admin.seeker@jobify.com"
                
                (loginVC as! LoginViewController).txtPassword.text = "123456"

                present(loginVC, animated: true, completion: nil)
                
            }
    }
    
    @IBAction func logInAsCompany(_ sender: UIButton) {
        // Terminate the user session
            UserSession.shared.loggedInUser = nil

            // Navigate back to the login screen
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginScreenViewControler") {
                loginVC.modalPresentationStyle = .fullScreen
                
                _ = loginVC.view
                
                (loginVC as! LoginViewController).txtUsername.text = "admin.employer@jobify.com"
                
                (loginVC as! LoginViewController).txtPassword.text = "123456"

                present(loginVC, animated: true, completion: nil)
                
            }
    }
    
    @IBAction func btnChats(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EmployerJobPostingAndEmployerApplicantInteraction_MaryamAhmed", bundle: nil)
        if let chatsAllVC = storyboard.instantiateViewController(identifier: "ChatsAll") as? chatsScreenViewController {
            navigationController?.pushViewController(chatsAllVC, animated: true)
        }
    }
    
}
