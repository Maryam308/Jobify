//
//  JobDetailsTableViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 25/12/2024.
//

import UIKit

class JobDetailsTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDatePosted: UILabel!
    @IBOutlet weak var lblLevel: UIButton!
    @IBOutlet weak var lblCategory: UIButton!
    @IBOutlet weak var lblLocation: UIButton!
    @IBOutlet weak var lblEmploymentType: UIButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblDeadlineDate: UILabel!
    @IBOutlet weak var imgExtraAttachment: UIImageView!
    
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var txtRequirement: UITextView!
    
    @IBOutlet weak var extraAttachmentView: UIView!
    
    @IBOutlet weak var btnApplyForJobPosition: UIButton!
    
    var job: Job?
    var currentUserId: Int = currentLoggedInUserID
    //var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
    var jobId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Set clipsToBounds to false when no image is present
        imgProfilePic.layer.cornerRadius = 10 // Reset corner radius
        imgProfilePic.clipsToBounds = true // Disable clipping
        
        let cornerRadius: CGFloat = 10.0 // Adjust the value as needed
        
        btnApplyForJobPosition.layer.cornerRadius = cornerRadius
        btnApplyForJobPosition.clipsToBounds = true
        // Update UI with job details
        updateUI()//for upda
        
    }
    
    func updateUI() {
        guard let job = job else { return }
        
        // Populate the UI elements with job data
        lblCompanyName.text = job.companyDetails?.name ?? "By Jobify"
        
        
        // Load profile picture
        if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
           let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL, into: imgProfilePic)
        } else {
            // Use a system-provided placeholder image
            imgProfilePic.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
            
            // Set clipsToBounds to false when no image is present
            imgProfilePic.layer.cornerRadius = 0 // Reset corner radius
            imgProfilePic.clipsToBounds = false // Disable clipping
        }
        
        
        lblDatePosted.text = DateFormatter.localizedString(from: job.date, dateStyle: .medium, timeStyle: .short)
        
        // Create an array of labels
        let labels = [lblLevel, lblCategory, lblLocation, lblEmploymentType]
        
        // Set corner radius and masks to bounds for each button
        for label in labels {
            if let label = label {
                label.layer.cornerRadius = label.frame.size.height / 2
                label.layer.masksToBounds = true
            }
        }
        lblLevel.setTitle(job.level.rawValue, for: .normal)
        lblCategory.setTitle(job.category.rawValue, for: .normal)
        lblLocation.setTitle(job.location, for: .normal)
        lblEmploymentType.setTitle(job.employmentType.rawValue, for: .normal)
        lblJobTitle.text = job.title
        lblDeadlineDate.text = job.deadline != nil ? DateFormatter.localizedString(from: job.deadline!, dateStyle: .medium, timeStyle: .none) : "No Deadline"
        txtDescription.text = job.desc
        txtRequirement.text = job.requirement
        
        // Load extra attachment image, if available
        if let extraImageURLString = job.extraAttachments,
           let extraImageURL = URL(string: extraImageURLString) {
            loadImage(from: extraImageURL, into: imgExtraAttachment)
        }
        
        // Show or hide the delete button based on the current user role
        if (currentUserRole == "admin" || currentUserRole == "employer") {
            btnApplyForJobPosition.isHidden = true
            
        } else if currentUserRole == "seeker" {
            btnApplyForJobPosition.isHidden = false
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
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Assuming all details are in one section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 // Assuming one row for job details
    }
    
    
    
    
    @IBAction func btnApplyJob(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ApplicationTracking_ZahraHusain", bundle: nil)
               
               if let jobApplicationVC = storyboard.instantiateViewController(identifier: "ApplicationTableViewController") as? ApplicationTableViewController {
                   jobApplicationVC.job = job // Pass the job object to the new view controller
                   navigationController?.pushViewController(jobApplicationVC, animated: true)
               }
        }
    
}
