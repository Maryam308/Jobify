//
//  HamburgerViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 16/12/2024.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblWelcomeMessage: UILabel!
    
    
    @IBOutlet weak var manageCareerPaths: UIButton!
    @IBOutlet weak var learningResources: UIButton!
    @IBOutlet weak var manageSkills: UIButton!
    
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 7
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
    var currentUserName: String = UserSession.shared.loggedInUser?.name ?? "Gulf Digital Group"
    var welcomeMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfilePic()
        
        let name = currentUserName
        welcomeMessage = "Welcome \(name)!"
        
        lblWelcomeMessage.text = welcomeMessage
        
        
        // Show or hide the delete button based on the current user role
        if currentUserRole == "admin"  {
            manageCareerPaths.isHidden = false
            learningResources.isHidden = false
            manageSkills.isHidden = false
            
        } else {
            manageCareerPaths.isHidden = true
            learningResources.isHidden = true
            manageSkills.isHidden = true
        }
    }
    private func setupProfilePic() {
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
    
   
    
    @IBAction func ManageCareerPaths(_ sender: Any) {
         
        
        // Get a reference to the storyboard by its name
            let storyboard = UIStoryboard(name: "PlatformContentManagement_MaryamAhmed", bundle: nil)

        // Instantiate the view controller by its identifier

        if let viewController = storyboard.instantiateViewController(withIdentifier: "ManageCareerPaths") as? ManageCareerPathsViewController {
            // Navigate to the target view controller

            self.navigationController?.pushViewController(viewController, animated: true)

            } else { print("Error: Could not find view controller with identifier 'TargetViewControllerIdentifier'") }
        
    }
    
    
    @IBAction func LearningResourcesRequests(_ sender: Any) {
        
        // Get a reference to the storyboard by its name
            let storyboard = UIStoryboard(name: "PlatformContentManagement_MaryamAhmed", bundle: nil)

        // Instantiate the view controller by its identifier
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MyLearningResources") as? MyLearningResourcesViewController {
            // Navigate to the target view controller

            self.navigationController?.pushViewController(viewController, animated: true)

            } else { print("Error: Could not find view controller with identifier 'TargetViewControllerIdentifier'") }

    }
    
    
    @IBAction func ManageSkills(_ sender: Any) {
        // Get a reference to the storyboard by its name
            let storyboard = UIStoryboard(name: "PlatformContentManagement_MaryamAhmed", bundle: nil)

        // Instantiate the view controller by its identifier

            if let viewController = storyboard.instantiateViewController(withIdentifier: "ManageSkills") as? LearningResourcesSkillsViewController {
            // Navigate to the target view controller

            self.navigationController?.pushViewController(viewController, animated: true)

            } else { print("Error: Could not find view controller with identifier 'TargetViewControllerIdentifier'") }

    }
    

}
