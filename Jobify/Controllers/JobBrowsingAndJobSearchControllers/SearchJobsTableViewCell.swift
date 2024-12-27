//
//  SearchJobsTableViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 23/12/2024.
//

import UIKit

class SearchJobsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCompany: UIImageView!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var lblJobTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //round the image view corners
        imgCompany.layer.cornerRadius = imgCompany.frame.size.width / 2
        imgCompany.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
