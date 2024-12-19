//
//  CVTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import UIKit

class CVTableViewCell: UITableViewCell {
    //creating outlets
    var onDelete: (() -> Void)?
    @IBOutlet weak var CVCellView: UIView!
    
    @IBOutlet weak var lblCVTitle: UILabel!
    
    @IBOutlet weak var lblCVAddDate: UILabel!
    
    //creating actions for buttons
    @IBAction func btnViewCVTapped(_ sender: UIButton) {
    }
    
    @IBAction func btnDownloadTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func btnDeleteCVTapped(_ sender: UIButton) {
        onDelete?()
    }
    
    //setup the cell
    func setup(_ cv:CV){
        lblCVTitle.text = cv.cvTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: cv.creationDate)
        lblCVAddDate.text = formattedDate
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CVCellView.layer.cornerRadius = contentView.frame.height / 9
        // Shadow configuration
        CVCellView.layer.shadowColor = UIColor.black.cgColor
        CVCellView.layer.shadowOpacity = 0.2
        CVCellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        CVCellView.layer.shadowRadius = 6
        CVCellView.layer.shadowPath = UIBezierPath(rect: CVCellView.bounds).cgPath
        CVCellView.layer.shouldRasterize = false
        
        //content view configuration
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
