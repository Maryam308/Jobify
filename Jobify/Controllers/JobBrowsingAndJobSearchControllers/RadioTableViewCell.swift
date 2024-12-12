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
    
    
    func setOptionsTitleFrom(_ options:[String]){
        lblOption1.text = options[0]
        lblOption2.text = options[1]
    }
    
    func setOptipotionsSelectedFrom(_ isOption1Selected:Bool){
        if isOption1Selected{
            btnOption1.isSelected = true
            btnOption2.isSelected = false
        }else{
            btnOption1.isSelected = false
            btnOption2.isSelected = true
        }
        
    }
    
    @IBAction func option1Selected(_ sender: UIButton) {
        setOptipotionsSelectedFrom(true)
    }
    
    @IBAction func option2Selected(_ sender: UIButton) {
        setOptipotionsSelectedFrom(false)
    }
    
    func setOption1Selected(_ selected:Bool){
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
