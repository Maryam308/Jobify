//
//  HamburgerViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 16/12/2024.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblWelcomeMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfilePic()

    }
    
    private func setupProfilePic() {
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
    
    //note that btns must have actions to navigate to it
    

    
   

}
