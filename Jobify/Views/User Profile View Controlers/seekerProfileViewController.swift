//
//  Untitled.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//
import UIKit

class SeekerProfileViewController: UIViewController {
    
    // Define the imageView property
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
    }
    
    
    @IBAction func btnMyCVs(_ sender: UIButton) {
    }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
}

class SeekerProfileViewControllerWithCV: UIViewController {

    // Define the imageView property
    @IBOutlet weak var imageView: UIImageView!
    
    // Define the EducationtextView property
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!



    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the circular image
        setupImageUploadCircle()

        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()
    }

    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}


class SeekerProfileViewControllerWithCV_EditViewController: UIViewController {
    
    // Define the imageView property
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()
    }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}





class SeekerProfilePreviewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()

        }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}


    

class SeekerProfileNoCVEditViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
    }
    
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

class seekerProfilePreviewViewController: UIViewController {
        
        
        
    }

