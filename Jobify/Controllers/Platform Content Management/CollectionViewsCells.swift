//
//  CollectionViewsCells.swift
//  Jobify
//
//  Created by Maryam Ahmed on 22/12/2024.
//

import UIKit

protocol MyLearningResourcesCellDelegate: AnyObject {
    func didTapRemoveButton(in cell: MyLearningResourcesCells)
}

class MyLearningResourcesCells: UICollectionViewCell {
    
    weak var delegate: MyLearningResourcesCellDelegate? // adding the delegate var
    
    @IBOutlet weak var lblResourceTitle: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var myTitleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set view rounds
        myTitleView.layer.cornerRadius = 15
        
        //set button rounds
        btnRemove.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func btnRemoveClick(_ sender: Any) {
        delegate?.didTapRemoveButton(in: self)
            
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


//to tell the view controller that the button has been tapped and send the title
protocol CareerPathCellDelegate: AnyObject {
    func didTapEditButton(id: Int)
    func didTapRemoveButton(id: Int)
}


class ManageCareerPathCollectionViewCell : UICollectionViewCell {
        
    @IBOutlet weak var btnRemoveCareer: UIButton!
    @IBOutlet weak var btnEditCareer: UIButton!
    @IBOutlet weak var lblCareerTitle: UILabel!
    @IBOutlet weak var careerTitleView: UIView!
    
    weak var delegate: CareerPathCellDelegate?
    private var id: Int? // Store the id
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        careerTitleView.layer.cornerRadius = 15
        btnEditCareer.layer.cornerRadius = 15
        btnRemoveCareer.layer.cornerRadius = 15
        
        
    }
    
    func configure(with careerPath: CareerPath) {
        lblCareerTitle.text = careerPath.title
        id = careerPath.careerId
        }
    
    //actions for tapping the buttons
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        
        if let id = id {
                    delegate?.didTapEditButton(id: id)
                }
        
    }
    
    
    //removing the career path
    @IBAction func btnRemoveTapped(_ sender: UIButton) {
        if let id = id {
                    delegate?.didTapEditButton(id: id)
                }
    }
    
    
    
}
