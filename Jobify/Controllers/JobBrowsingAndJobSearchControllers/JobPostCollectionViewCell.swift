//
//  JobPosCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit

class JobPostCollectionViewCell: UICollectionViewCell {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Example of setting up a view layout
        jobPostView.layer.cornerRadius = 9
        jobPostView.layer.masksToBounds = true
        
        //round the image view corners
        jobPostImageView.layer.cornerRadius = jobPostImageView.frame.size.width / 2
        jobPostImageView.layer.masksToBounds = true

        // Create an array of labels
            let labels = [jobPostLevellbl, jobPostEnrollmentTypelbl, jobPostCategorylbl, joPostLocationlbl]
            
            // Set corner radius and masks to bounds for each button
            for label in labels {
                if let label = label {
                    label.layer.cornerRadius = label.frame.size.height / 2
                    label.layer.masksToBounds = true
                }
            }

    }
 
}
