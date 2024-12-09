//
//  TrackerCell.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 09/12/2024.
//

import UIKit

class TrackerCell: UITableViewCell {
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
