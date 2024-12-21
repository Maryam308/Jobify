//
//  SkillsTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 16/12/2024.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var skillsView: UIView!
    @IBOutlet weak var lblSkill: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add padding to the content view (internal margin for the cell)
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(skill: cvSkills) {
        lblSkill.text = skill.skillTitle
    }
    
}
