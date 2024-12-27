//
//  RadioTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    
    // Outlets for the labels and buttons
    @IBOutlet weak var lblOption1: UILabel!
    @IBOutlet weak var lblOption2: UILabel!
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    
    // Closure to handle option selection
    var onOptionSelected: ((Int) -> Void)?
    
    // MARK: - Configuration Methods
    
    /// Configure the cell with option titles
    /// - Parameter options: Array of option titles
    func setOptionsTitleFrom(_ options: [String]) {
        guard options.count >= 2 else { return } // Ensure there are at least 2 options
        lblOption1.text = options[0]
        lblOption2.text = options[1]
    }
    
    /// Set the selection state of the buttons
    /// - Parameter isOption1Selected: Bool indicating if option 1 is selected
    func setOptionSelected(_ isOption1Selected: Bool) {
        btnOption1.isSelected = isOption1Selected
        btnOption2.isSelected = !isOption1Selected
    }
    
    // MARK: - Action Handlers
    
    @IBAction func option1Selected(_ sender: UIButton) {
        setOptionSelected(true)
        onOptionSelected?(0) // Notify that option 1 is selected
    }
    
    @IBAction func option2Selected(_ sender: UIButton) {
        setOptionSelected(false)
        onOptionSelected?(1) // Notify that option 2 is selected
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
