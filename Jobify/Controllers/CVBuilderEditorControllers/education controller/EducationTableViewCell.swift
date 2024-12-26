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

        CVCellView.layer.cornerRadius = 10
        CVCellView.layer.masksToBounds = true

        // Rounded corners for the content view
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        // Adjust font size for iPads
        if UIDevice.current.userInterfaceIdiom == .pad {
            lblDegree.font = lblDegree.font.withSize(22)
            lblInstitution.font = lblInstitution.font.withSize(22)
            lblTo.font = lblTo.font.withSize(22)
            lblFrom.font = lblFrom.font.withSize(22)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(education: Education) {
        lblDegree.text = "Degree: " + (education.degree ?? "")
        lblInstitution.text = "Institution: " + (education.institution ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy" // Format for month and year
        
        lblFrom.text = "From: " + dateFormatter.string(from: education.startDate!)
        
        if let endDate = education.endDate {
            if endDate > Date() {
                lblTo.text = "To: Present"
            } else {
                lblTo.text = "To: " + dateFormatter.string(from: endDate)
            }
        } 
    }


}
