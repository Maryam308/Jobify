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
    
    var currentUserId: Int = currentLoggedInUserID
    //var currentUserRole: String = currentUserRole
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
            
            // Load profile picture
            if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
                let imageURL = URL(string: imageURLString) {
                loadImage(from: imageURL, into: imgProfile)
            } else {
                // Use a system-provided placeholder image
                imgProfile.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
                        
                // Set clipsToBounds to false when no image is present
                imgProfile.layer.cornerRadius = 0 // Reset corner radius
                imgProfile.clipsToBounds = false // Disable clipping
            }
        }
        
        private func loadImage(from url: URL, into imageView: UIImageView) {
               let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   guard let data = data, error == nil else {
                       return // Do not set a fallback image for extra attachment
                   }
                   DispatchQueue.main.async {
                       imageView.image = UIImage(data: data)
                   }
               }
               task.resume()
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
    
    
    @IBAction func btnProfile(_ sender: Any) {
        
        // Show or hide the delete button based on the current user role
        if currentUserRole == "admin"  {
            let storyboard = UIStoryboard(name: "UserProfileAndSettings_ZainabAlawi", bundle: nil)

                   if let adminProfileVC = storyboard.instantiateViewController(identifier: "AdminProfileViewController") as? AdminProfileViewController {

                            navigationController?.pushViewController(adminProfileVC, animated: true)

                        }
            
        } else if currentUserRole == "seeker" {
            let storyboard = UIStoryboard(name: "UserProfileAndSettings_ZainabAlawi", bundle: nil)

                   if let seekerProfileVC = storyboard.instantiateViewController(identifier: "SeekerProfileViewController") as? SeekerProfileViewControllerWithCV {

                            navigationController?.pushViewController(seekerProfileVC, animated: true)

                        }
        } else if currentUserRole == "employer" {
            let storyboard = UIStoryboard(name: "UserProfileAndSettings_ZainabAlawi", bundle: nil)

                   if let employerProfileVC = storyboard.instantiateViewController(identifier: "CompanyProfileViewController") as? CompanyProfileViewController2 {

                            navigationController?.pushViewController(employerProfileVC, animated: true)

                        }
        }
    }
    

}
