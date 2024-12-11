//
//  editProfileViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 11/12/2024.
//

import UIKit



class ChildViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray // Optional styling
    }
}




class ParentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initially, the container is empty.
        childView.isHidden = true
    }

    @IBOutlet weak var childView: UIView!
    
    @IBAction func showChildView(_ sender: UIButton) {
        // If the container is hidden, reveal it
                if childView.isHidden {
                    childView.isHidden = false
                    
                    // Add the child view controller (if not already added)
                    let childVC = ChildViewController()
                    addChild(childVC)
                    childVC.view.frame = childView.bounds
                    childView.addSubview(childVC.view)
                    childVC.didMove(toParent: self)
                } else {
                    // Optionally toggle behavior: hide the container again
                    childView.isHidden = true
                }
    }
}

