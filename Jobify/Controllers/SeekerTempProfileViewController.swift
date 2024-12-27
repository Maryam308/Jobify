//
//  SeekerTempProfileViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/12/2024.
//

import UIKit
import FirebaseAuth
class SeekerTempProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 

    @IBAction func btnCVTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
        if let myCVsVC = storyboard.instantiateViewController(identifier: "myCVs") as? CVBuilderEditorViewController {
                 navigationController?.pushViewController(myCVsVC, animated: true)
             }
    }
    
}
