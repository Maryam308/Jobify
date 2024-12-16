//
//  RadioTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOption1: UILabel!
    @IBOutlet weak var lblOption2: UILabel!
    
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    
    
    // Configure the cell with option titles
        func setOptionsTitleFrom(_ options: [String]) {
            guard options.count >= 2 else { return } // Ensure there are at least 2 options
            lblOption1.text = options[0]
            lblOption2.text = options[1]
        }
        
        // Set the selection state of the buttons
        func setOptionSelected(_ isOption1Selected: Bool) {
            btnOption1.isSelected = isOption1Selected
            btnOption2.isSelected = !isOption1Selected
        }
    
    @IBAction func option1Selected(_ sender: UIButton) {
        setOptionSelected(true)
    }
    
    @IBAction func option2Selected(_ sender: UIButton) {
        setOptionSelected(false)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
