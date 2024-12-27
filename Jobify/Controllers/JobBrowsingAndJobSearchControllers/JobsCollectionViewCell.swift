//
//  JobsCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 11/12/2024.
//

import UIKit

class JobsCollectionViewCell: UICollectionViewCell {
    
    // UI Outlets
    @IBOutlet weak var jobCategoryImageView: UIImageView!
    @IBOutlet weak var jobCategorytitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional setup after loading the view
    }

    // MARK: - Configuration Method

    
    func setUp(category: JobCategory) {
        // Set the image and title for the job category
        jobCategoryImageView.image = category.image
        jobCategorytitleLbl.text = category.title
        
        // Customize the appearance of the job category image view
        configureImageView()
        
        // Customize the appearance of the job category title label
        configureTitleLabel()
    }
    
    // MARK: - UI Configuration Methods

    /// Configure the appearance of the job category image view
    private func configureImageView() {
        jobCategoryImageView.layer.cornerRadius = 20 // Set corner radius for rounded corners
        jobCategoryImageView.clipsToBounds = true // Ensure the image view respects the corner radius
    }

    /// Configure the appearance of the job category title label
    private func configureTitleLabel() {
        jobCategorytitleLbl.textColor = .white // Ensure the text is visible
        jobCategorytitleLbl.textAlignment = .center // Center the text
    }
}
