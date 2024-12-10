//
//  CareerResourcesTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import UIKit

class CareerResourcesTableViewCell: UITableViewCell {

    @IBAction func btnSaveTapped(_ sender: UIButton) {
    }
    @IBOutlet weak var btnResourceName: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
