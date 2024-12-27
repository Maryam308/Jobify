//
//  CompanyProfileEditTableViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 22/12/2024.
//

import UIKit

class CompanyProfileEditTableViewController: UITableViewController {

    //MARK: Outlets
    @IBOutlet weak var txtAboutUs: UITextView!
    @IBOutlet weak var txtOurEmployability: UITextView!
    @IBOutlet weak var txtOurVision: UITextView!
    
    @IBOutlet weak var txtOuremployability: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            let page = (segue.destination as? CompanyProfileViewController2)
            page?.thereIsInfo = true
            page?.AboutUsView.isHidden = false
            page?.ourVisionView.isHidden = false
            page?.OutEmployabiliotyView.isHidden = false
            
            page?.txtAbout.text = txtAboutUs.text
            page?.txtOurVision.text = txtOurVision.text
            page?.txtEmployability.text = txtOuremployability.text
            
            page?.btnEdit.tintColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1)

        }
    }
    
    // MARK: - Table view data source

    

}
