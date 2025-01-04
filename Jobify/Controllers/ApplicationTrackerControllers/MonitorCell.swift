//
//  MonitorCell.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 10/12/2024.
//

import UIKit

protocol MonitorCellDelegate: AnyObject {
    func didTapChangeStatusButton(for application: JobApplication)
}


class MonitorCell: UITableViewCell {

    
    @IBOutlet weak var viewApplicationButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var seekerLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeStatusButton: UIButton!
    var application: JobApplication?
    weak var delegate: MonitorCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ChangeStatusClicked(_ sender: UIButton) {
        print("application to be changed status: \(application?.applicationId ?? 0)")
        guard let applicationChange = application else { return }
                delegate?.didTapChangeStatusButton(for: applicationChange)
        
    }
    
}
    

