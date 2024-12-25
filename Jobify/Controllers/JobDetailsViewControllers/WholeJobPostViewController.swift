//
//  WholeJobPostViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 25/12/2024.
//
import UIKit

class WholeJobPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var JobPostTableView: UITableView!
    
    // Single job instance
    var job: Job?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        JobPostTableView.delegate = self
        JobPostTableView.dataSource = self
        
        // Automatic dimension for cell height
        JobPostTableView.estimatedRowHeight = 100
        JobPostTableView.rowHeight = UITableView.automaticDimension
        
        // Initialize the job (replace with actual data)
        let exampleJob = Job(
            title: "Software Developer",
            companyDetails: nil, // Add your company details here
            level: .junior,
            category: .informationTechnology,
            employmentType: .fullTime,
            location: "Bahrain",
            deadline: nil,
            desc: "Develop and maintain software solutions.",
            requirement: "Experience with Swift and iOS development.",
            extraAttachments: nil,
            date: Date(),
            time: "12:00, 25-12-2024"
        )
        
        self.job = exampleJob
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Fixed number of rows for each job post
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let job = job else { return UITableViewCell() }

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostCompanyCell", for: indexPath) as! JobPostCompanyTableViewCell
            cell.lblCompanyName.text = job.title
            cell.lblDateJobPosted.text = DateFormatter.localizedString(from: job.date, dateStyle: .short, timeStyle: .none)
            cell.lblTimeJobPosted.text = job.time
            cell.lblLevel.setTitle(job.level.rawValue, for: .normal)
            cell.lblEmploymentType.setTitle(job.employmentType.rawValue, for: .normal)
            cell.lblCategory.setTitle(job.category.rawValue, for: .normal)
            cell.lblJobLocation.setTitle(job.location, for: .normal)
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostDescriptionCell", for: indexPath) as! JobPostDescriptionTableViewCell
            cell.lblJobDescrption.text = job.desc
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostExtraAttachmentCell", for: indexPath) as! JobPostExtraAttachmentTableViewCell
            // Configure as needed, e.g., set an image
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostInfoCell", for: indexPath) as! JobPostInfoTableViewCell
            cell.lblJobTitle.text = job.title
            cell.lblJopPostDeadlineDate.text = DateFormatter.localizedString(from: job.deadline ?? Date(), dateStyle: .short, timeStyle: .none)
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobPostRequirementCell", for: indexPath) as! JobPostRequirementTableViewCell
            cell.lblJobRequirement.text = job.requirement
            return cell

        default:
            return UITableViewCell() // Fallback
        }
    }
}
