//
//  JobPostRequirementTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 25/12/2024.
//

import UIKit

class JobPostRequirementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblJobRequirement: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblJobRequirement.isEditable = false // Make sure the text view is read-only
    }

    

}
