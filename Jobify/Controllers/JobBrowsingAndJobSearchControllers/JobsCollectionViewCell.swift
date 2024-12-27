//
//  JobsCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 11/12/2024.
//

import UIKit

class JobsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var jobCategoryImageView: UIImageView!
    
    @IBOutlet weak var jobCategorytitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    func setUp(category: JobCategory) {
        jobCategoryImageView.image = category.image
        jobCategorytitleLbl.text = category.title
        
        // Set the corner radius to 10 for the image
        jobCategoryImageView.layer.cornerRadius = 20
        jobCategoryImageView.clipsToBounds = true
        
        
        
        //Title
        jobCategorytitleLbl.textColor = .white // Ensure the text is visible
        jobCategorytitleLbl.textAlignment = .center // Center the text
                
    }
}
