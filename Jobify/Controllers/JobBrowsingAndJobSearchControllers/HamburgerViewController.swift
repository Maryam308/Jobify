//
//  HamburgerViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 16/12/2024.
//

import UIKit

class HamburgerViewController: UIViewController {

    // UI Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblWelcomeMessage: UILabel!
    @IBOutlet weak var manageCareerPaths: UIButton!
    @IBOutlet weak var learningResources: UIButton!
    @IBOutlet weak var manageSkills: UIButton!
    
    // User session information
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 1
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
    var currentUserName: String = UserSession.shared.loggedInUser?.name ?? "Gulf Digital Group"
    var welcomeMessage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup profile picture and welcome message
        setupProfilePic()
        welcomeMessage = "Welcome \(currentUserName)!"
        lblWelcomeMessage.text = welcomeMessage
        
       
        
        // Show or hide buttons based on user role
        toggleButtonsVisibility()
    }

    // MARK: - Setup Methods

    /// Setup the profile picture to be circular
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


    /// Toggle visibility of management buttons based on user role
    private func toggleButtonsVisibility() {
        let isAdmin = currentUserRole == "admin"
        manageCareerPaths.isHidden = !isAdmin
        learningResources.isHidden = !isAdmin
        manageSkills.isHidden = !isAdmin
    }

    // MARK: - Action Handlers

    @IBAction func manageCareerPaths(_ sender: Any) {
        navigateToViewController(identifier: "ManageCareerPaths", viewControllerType: ManageCareerPathsViewController.self)
    }

    @IBAction func learningResourcesRequests(_ sender: Any) {
        navigateToViewController(identifier: "MyLearningResources", viewControllerType: MyLearningResourcesViewController.self)
    }

    @IBAction func manageSkills(_ sender: Any) {
        navigateToViewController(identifier: "ManageSkills", viewControllerType: LearningResourcesSkillsViewController.self)
    }

    // MARK: - Navigation

    /// Navigate to a specified view controller
    /// - Parameters:
    ///   - identifier: The storyboard identifier of the view controller
    ///   - viewControllerType: The type of the view controller to navigate to
    private func navigateToViewController<T: UIViewController>(identifier: String, viewControllerType: T.Type) {
        // Get a reference to the storyboard by its name
        let storyboard = UIStoryboard(name: "PlatformContentManagement_MaryamAhmed", bundle: nil)

        // Instantiate the view controller by its identifier
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            // Navigate to the target view controller
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Error: Could not find view controller with identifier '\(identifier)'")
        }
    }
}
