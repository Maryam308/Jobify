//
//  ChooseCVCell.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 12/12/2024.
//

import UIKit

class ChooseCVCell: UITableViewCell {

    @IBOutlet var cvTitleLabel: UILabel!
    @IBOutlet var cvDateLabel: UILabel!
    @IBOutlet var viewCVButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
