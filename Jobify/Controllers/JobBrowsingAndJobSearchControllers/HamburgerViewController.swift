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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfilePic()

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
