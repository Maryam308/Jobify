//
//  AdminProfileViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

import UIKit
class AdminProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
    }
    
}
