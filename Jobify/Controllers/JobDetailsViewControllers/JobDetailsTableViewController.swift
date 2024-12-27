//
//  JobDetailsTableViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 25/12/2024.
//

import UIKit

class JobDetailsTableViewController: UITableViewController {

    struct JobTestData1 {
        let companyName: String
        let timePosted: String
        let datePosted: String
        let level: String
        let category: String
        let location: String
        let employmentType: String
        let jobTitle: String
        let deadlineDate: String
        let description: String
        let requirement: String
        let profilePic: UIImage?
        let extraAttachment: UIImage?
    }
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTimePosted: UILabel!
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
    
    
    @IBOutlet weak var btnApplyForJobPosition: UIButton!
    
    var job: Job?
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 7
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
               // Update UI with job details
              updateUI()//for upda
        
    }
    
    func updateUI() {
            guard let job = job else { return }

            // Populate the UI elements with job data
            lblCompanyName.text = job.companyDetails?.name ?? "By Jobify"
            lblTimePosted.text = nil
            lblDatePosted.text = DateFormatter.localizedString(from: job.date, dateStyle: .medium, timeStyle: .short)
            lblLevel.setTitle(job.level.rawValue, for: .normal)
            lblCategory.setTitle(job.category.rawValue, for: .normal)
            lblLocation.setTitle(job.location, for: .normal)
            lblEmploymentType.setTitle(job.employmentType.rawValue, for: .normal)
            lblJobTitle.text = job.title
            lblDeadlineDate.text = job.deadline != nil ? DateFormatter.localizedString(from: job.deadline!, dateStyle: .medium, timeStyle: .none) : "No Deadline"
            txtDescription.text = job.desc
            txtRequirement.text = job.requirement
            
        // Show or hide the delete button based on the current user role
            if (currentUserRole == "admin" || currentUserRole == "employer") {
                btnApplyForJobPosition.isHidden = true
                
            } else if currentUserRole == "seeker" {
                btnApplyForJobPosition.isHidden = false
            }
            // Load company profile picture
            loadProfileImage()
        }
        
        private func loadProfileImage() {
            if let imageURL = job?.companyDetails?.imageURL {
                imgProfilePic.image = UIImage(named: imageURL) ?? UIImage(named: "Batelco") // Fallback image
            } else {
                imgProfilePic.image = UIImage(named: "Batelco") // Fallback image
            }
        }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Assuming all details are in one section
           }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 // Assuming one row for job details
    }

    

}
