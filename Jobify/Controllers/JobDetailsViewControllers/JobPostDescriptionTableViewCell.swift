//
//  JobPostDescriptionTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 25/12/2024.
//

import UIKit

class JobPostDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblJobDescrption: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        lblJobDescrption.isEditable = false // Make sure the text view is read-only
        // Initialization code
    }


}
