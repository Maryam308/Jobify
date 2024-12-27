//
//  JobPostCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit

// Custom UICollectionViewCell to display job posts
class JobPostCollectionViewCell: UICollectionViewCell {
    
    // Protocol to handle delete button actions
    protocol JobPostCellDelegate: AnyObject {
        func didTapDeleteButton(jobId: String) // Delegate method for delete action
    }
    
    // Outlets for UI elements
    @IBOutlet weak var jobPostView: UIView!
    @IBOutlet weak var jobPostImageView: UIImageView!
    @IBOutlet weak var jobPostTimelbl: UILabel!
    @IBOutlet weak var jobPostTitlelbl: UILabel!
    @IBOutlet weak var jobPostDatelbl: UILabel!
    @IBOutlet weak var jobPostLevellbl: UIButton!
    @IBOutlet weak var jobPostEnrollmentTypelbl: UIButton!
    @IBOutlet weak var jobPostCategorylbl: UIButton!
    @IBOutlet weak var joPostLocationlbl: UIButton!
    @IBOutlet weak var jobPostDescriptionTitlelbl: UILabel!
    @IBOutlet weak var jobPostDescriptionlbl: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    // Delegate to notify about delete button tap
    weak var delegate: JobPostCellDelegate?
    var jobId: String? // Variable to hold the job ID for deletion
    
    // Action for delete button tap
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let jobId = jobId else { return } // Ensure jobId is not nil
        delegate?.didTapDeleteButton(jobId: jobId) // Notify delegate about the delete action
    }
    
    // Called when the cell is loaded from the nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup job post view appearance
        jobPostView.layer.cornerRadius = 9 // Round corners of the job post view
        jobPostView.layer.masksToBounds = true // Ensure subviews are clipped to the rounded corners
        
        // Round the image view corners
        jobPostImageView.layer.cornerRadius = jobPostImageView.frame.size.width / 2
        jobPostImageView.layer.masksToBounds = true // Clip image view to its bounds

        // Create an array of label buttons for styling
        let labels = [jobPostLevellbl, jobPostEnrollmentTypelbl, jobPostCategorylbl, joPostLocationlbl]
        
        // Set corner radius and masks to bounds for each button
        for label in labels {
            if let label = label {
                label.layer.cornerRadius = label.frame.size.height / 2 // Round corners
                label.layer.masksToBounds = true // Clip to bounds
            }
        }
        
        // Set corner radius for the delete button
        let cornerRadius: CGFloat = 10.0 // Corner radius for delete button
        btnDelete.layer.cornerRadius = cornerRadius // Apply corner radius
        btnDelete.clipsToBounds = true // Ensure button is clipped to bounds
    }
}
