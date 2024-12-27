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
    
    @IBOutlet weak var keyResponsibilityTitle: UILabel!
    @IBOutlet weak var lblKeyResponsibility: UITextView!
    
    func adjustFontSize() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        
        lblCompany.font = lblCompany.font?.withSize(24)
        lblRole.font = lblRole.font?.withSize(24)
        lblFrom.font = lblFrom.font?.withSize(24)
        lblTo.font = lblTo.font?.withSize(24)
        keyResponsibilityTitle.font = keyResponsibilityTitle.font?.withSize(24)
        lblKeyResponsibility.font = lblKeyResponsibility.font?.withSize(24)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSize()
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
        lblCompany.text = "Company: " + (experience.company ?? "")
        lblRole.text = "Role: " + (experience.role ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Format for month and year
        
        lblFrom.text = "From: " + dateFormatter.string(from: experience.startDate!)
        
        // Check if the end date is greater than the current date
        let currentDate = Date()
        if let endDate = experience.endDate, endDate > currentDate {
            lblTo.text = "To: Present"
        } else {
            lblTo.text = "To: " + dateFormatter.string(from: experience.endDate ?? currentDate)
        }
        
        lblKeyResponsibility.text = experience.keyResponsibilities
    }
}
