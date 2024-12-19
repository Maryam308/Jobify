//
//  ExperienceTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 16/12/2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    @IBOutlet weak var experienceView: UIView!
    
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var lblRole: UILabel!
    
    @IBOutlet weak var lblFrom: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    
    @IBOutlet weak var lblKeyResponsibility: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add padding to the content view (internal margin for the cell)
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        experienceView.layer.cornerRadius = 10
        experienceView.layer.masksToBounds = true

        // Rounded corners for the content view
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(experience: WorkExperience) {
        lblCompany.text = "Company: " + experience.company!
        lblRole.text = "Role: " + experience.role!
        lblFrom.text = "From: " + DateFormatter.localizedString(from: experience.startDate!, dateStyle: .medium, timeStyle: .none)
        lblTo.text = experience.endDate != nil ? "To: " +  DateFormatter.localizedString(from: experience.endDate!, dateStyle: .medium, timeStyle: .none) : "Present"
        lblKeyResponsibility.text = experience.keyResponsibilities
    }
    
}
