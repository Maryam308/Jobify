//
//  CareerCustomNavigationController.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/12/2024.
//

import UIKit

class CareerCustomNavigationController: UINavigationController {
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup initial view controller based on user type
        setupInitialViewController()
    }
    
    private func setupInitialViewController() {
        let initialViewController: UIViewController
        
        switch currentUserRole {
        case "employer":
            initialViewController = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil).instantiateViewController(withIdentifier: "EmployerCareerResourcesViewController")
        case "admin":
            initialViewController = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil).instantiateViewController(withIdentifier: "EmployerCareerResourcesViewController")
        case "seeker":
            initialViewController = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil).instantiateViewController(withIdentifier: "SeekerCareerResourcesViewController")
        default:
            initialViewController = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil).instantiateViewController(withIdentifier: "SeekerCareerResourcesViewController")
        }
        
        // Set the initial view controller
        setViewControllers([initialViewController], animated: false)
    }
}
