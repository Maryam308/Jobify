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
