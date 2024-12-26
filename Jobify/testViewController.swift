//
//  testViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 26/12/2024.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnGoTapped(_ sender: UIButton) {
        // Load the storyboard
        let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
        
        // Instantiate the view controller you want to navigate to
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "myCVsNavigationController") as? UINavigationController,
           let myCVsViewController = navigationController.viewControllers.first {
            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(myCVsViewController, animated: true)
        }
    }
    
}
