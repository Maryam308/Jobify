//
//  EducationTableViewTableViewCell.swift
//  testEducation
//
//  Created by Maryam Yousif on 18/12/2024.
//

import UIKit

class EducationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblInstitution: UILabel!
    
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var CVCellView: UIView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add padding to the content view (internal margin for the cell)
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        // Optional: Add a background view with a margin (for visual margin inside the cell)
        CVCellView.layer.cornerRadius = 10
        CVCellView.layer.masksToBounds = true

        // Rounded corners for the content view
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(education: Education) {
        lblDegree.text = education.degree
        lblInstitution.text = education.institution
        lblFrom.text = DateFormatter.localizedString(from: education.startDate!, dateStyle: .medium, timeStyle: .none)
        lblTo.text = education.endDate != nil ? DateFormatter.localizedString(from: education.endDate!, dateStyle: .medium, timeStyle: .none) : "Present"
    }



}
