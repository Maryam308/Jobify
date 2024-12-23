//
//  LearningResourcesCollectionViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 23/12/2024.
//

import UIKit

class LearningResourcesCollectionViewCell: UICollectionViewCell {

    var currentUser: User? //a reference to the current user
    var favoriteAction: ((LearningResource) -> Void)? // Closure to handle save action
    
    @IBOutlet weak var saveIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(learningResource: LearningResource){
        lblTitle.text=learningResource.title
    }
    

    

}
