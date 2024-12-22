//
//  CollectionViewsCells.swift
//  Jobify
//
//  Created by Maryam Ahmed on 22/12/2024.
//

import UIKit

class MyLearningResourcesCells: UICollectionViewCell {
    
    @IBOutlet weak var lblResourceTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var myTitleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set view rounds
        myTitleView.layer.cornerRadius = 15
        
        //set button rounds
        btnEdit.layer.cornerRadius = 10
        
    }
}


class SkillsCollectionViewCells: UICollectionViewCell {
    
    
    @IBOutlet weak var btnSkillTitle: UIButton!
    
    @IBOutlet weak var skillTitleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set view rounds
        skillTitleView.layer.cornerRadius = 15
        
        
        
    }
    
    
}



class LRRequestCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var lblRequestState: UILabel!
    @IBOutlet weak var btnTitle: UIButton!
    
    @IBOutlet weak var requestView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        requestView.layer.cornerRadius = 15
        
        
        
    }
    
}


class ManageCareerPathCollectionViewCell : UICollectionViewCell {
        
    @IBOutlet weak var btnRemoveCareer: UIButton!
    @IBOutlet weak var btnEditCareer: UIButton!
    @IBOutlet weak var lblCareerTitle: UILabel!
    @IBOutlet weak var careerTitleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        careerTitleView.layer.cornerRadius = 15
        btnEditCareer.layer.cornerRadius = 15
        btnRemoveCareer.layer.cornerRadius = 15
        
        
    }
    
}
