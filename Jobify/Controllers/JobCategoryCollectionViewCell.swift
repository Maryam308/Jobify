//
//  JobCategoryCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 09/12/2024.
//

import UIKit

class JobCategoryCollectionViewCell: UICollectionViewCell {
    
 
    @IBOutlet weak var jobCategoryImageView: UIImageView!
    
    
    @IBOutlet weak var jobCategorytitleLbl: UILabel!
    
    
    func setUp(category: JobCategory) {
        jobCategoryImageView.image = category.image
        jobCategorytitleLbl.text = category.title
        
        // Set the corner radius to 10 for the image
        jobCategoryImageView.layer.cornerRadius = 30.5
        jobCategoryImageView.clipsToBounds = true
        
        
        
        //Title
        jobCategorytitleLbl.textColor = .white // Ensure the text is visible
        jobCategorytitleLbl.textAlignment = .center // Center the text
                
    }
    
    
}

