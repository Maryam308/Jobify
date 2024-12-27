//
//  SearchJobsTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 23/12/2024.
//

import UIKit

class SearchJobsTableViewCell: UITableViewCell {

    // UI Outlets
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize the appearance of the company image view
        configureImageView()
    }

    // MARK: - Configuration Methods

    /// Configure the appearance of the company image view
    private func configureImageView() {
        imgCompany.layer.cornerRadius = imgCompany.frame.size.width / 2 // Round the image view corners
        imgCompany.layer.masksToBounds = true // Ensure the image is clipped to the rounded corners
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state if needed
    }
}
