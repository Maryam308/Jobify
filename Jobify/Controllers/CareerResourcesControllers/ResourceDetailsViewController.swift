//
//  ResourceDetailsViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 24/12/2024.
//

import UIKit

class ResourceDetailsViewController: UIViewController {
    
    @IBOutlet weak var txtResourceDetails: UITextView!
    
    @IBOutlet weak var pageTitle: UITextView!
    

    @IBAction func btnLinkTapped(_ sender: UIButton) {
        // Check if the selected resource has a valid link
        guard let resource = selectedResource, let link = resource.link, let url = URL(string: link) else {
            print("Invalid link")
            return
        }
        
        // Open the URL in Safari
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    var selectedResource: LearningResource? // The selected resource passed from the previous screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI elements with the selected resource's data
        if let resource = selectedResource {
            let summary = resource.summary ?? "No summary available."
            txtResourceDetails.text = summary
            pageTitle.text = resource.title
        } else {
            txtResourceDetails.text = "No resource selected."
        }
       
        
        adjustFontSizeForDevice()
    }
    
    func adjustFontSizeForDevice(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            txtResourceDetails.font = txtResourceDetails.font?.withSize(24)
            pageTitle.font = pageTitle.font?.withSize(28)
        }
    }
}
