//
//  CareerPathCollectionViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 22/12/2024.
//

import UIKit

class CareerPathCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCareerPath: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(careerPath: String) {
        lblCareerPath.text = careerPath
        lblCareerPath.textAlignment = .center // Center the text
                
    }

}
