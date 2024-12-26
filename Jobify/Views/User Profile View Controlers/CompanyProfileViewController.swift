//
//  CompanyProfileViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

import UIKit

class CompanyProfilePreviewViewController: UIViewController {

    // Connect your view from the storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    @IBOutlet weak var employabilityGoalsTextView: UITextView!
    
    @IBOutlet weak var ourVisionTextView: UITextView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the About Us text view
        setupAboutUsTextView()
        
        // Add border and corner radius to the Our Employability Goals text view
        setupEmployabilityGoalsTextView()
        
        // Add border and corner radius to the Our Vision text view
        setupOurVisionextView()

        }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    // Define the setupAboutUsTextView method
    private func setupAboutUsTextView() {
        aboutUsTextView.layer.borderWidth = 1.0
        aboutUsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        aboutUsTextView.layer.cornerRadius = 15.0
        aboutUsTextView.clipsToBounds = true // Ensures content respects the corner radius
        aboutUsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupmployabilityGoalsTextView method
    private func setupEmployabilityGoalsTextView() {
        employabilityGoalsTextView.layer.borderWidth = 1.0
        employabilityGoalsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        employabilityGoalsTextView.layer.cornerRadius = 15.0
        employabilityGoalsTextView.clipsToBounds = true // Ensures content respects the corner radius
        employabilityGoalsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupOurVisionextView method Our Vision
    private func setupOurVisionextView() {
        ourVisionTextView.layer.borderWidth = 1.0
        ourVisionTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        ourVisionTextView.layer.cornerRadius = 15.0
        ourVisionTextView.clipsToBounds = true // Ensures content respects the corner radius
        ourVisionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}


class CompanyProfileDetailsFormViewController: UIViewController {
    
    //////
}


class CompanyProfileEditViewController: UIViewController {

    // Connect your view from the storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    @IBOutlet weak var employabilityGoalsTextView: UITextView!
    
    @IBOutlet weak var ourVisionTextView: UITextView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the About Us text view
        setupAboutUsTextView()
        
        // Add border and corner radius to the Our Employability Goals text view
        setupEmployabilityGoalsTextView()
        
        // Add border and corner radius to the Our Vision text view
        setupOurVisionextView()

        }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    // Define the setupAboutUsTextView method
    private func setupAboutUsTextView() {
        if let text = aboutUsTextView.text {
            aboutUsTextView.layer.borderWidth = 1.0
            aboutUsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
            aboutUsTextView.layer.cornerRadius = 15.0
            aboutUsTextView.clipsToBounds = true // Ensures content respects the corner radius
            aboutUsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    // Define the setupmployabilityGoalsTextView method
    private func setupEmployabilityGoalsTextView() {
        employabilityGoalsTextView.layer.borderWidth = 1.0
        employabilityGoalsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        employabilityGoalsTextView.layer.cornerRadius = 15.0
        employabilityGoalsTextView.clipsToBounds = true // Ensures content respects the corner radius
        employabilityGoalsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupOurVisionextView method Our Vision
    private func setupOurVisionextView() {
        ourVisionTextView.layer.borderWidth = 1.0
        ourVisionTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        ourVisionTextView.layer.cornerRadius = 15.0
        ourVisionTextView.clipsToBounds = true // Ensures content respects the corner radius
        ourVisionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}

