//
//  CompanyProfileViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 22/12/2024.
//

import UIKit



class CompanyProfileViewController2: UIViewController {

    @IBOutlet weak var btnAddInfo: UIButton!
    var thereIsInfo = false
    
    
    //MARK: Outlets
    @IBOutlet weak var AboutUsView: UIView!
    @IBOutlet weak var ourVisionView: UIView!
    @IBOutlet weak var OutEmployabiliotyView: UIView!
    @IBOutlet weak var txtOurVision: UITextView!
    @IBOutlet weak var txtEmployability: UITextView!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var companyProfileStackView: UIStackView!
    
    //Outlets for the views looks
    @IBOutlet weak var aboutUsContainerView: UIView!
    @IBOutlet weak var employabilityGoalsContainerView: UIView!
    @IBOutlet weak var ourVisionContainerView: UIView!
    @IBOutlet weak var aboutUsTextView: UITextView!
    @IBOutlet weak var employabilityGoalsTextView: UITextView!
    @IBOutlet weak var ourVisionTextView: UITextView!


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AboutUsView.isHidden = true
        ourVisionView.isHidden = true
        OutEmployabiliotyView.isHidden = true
        btnEdit.isEnabled = false
        
        // Do any additional setup after loading the view.
        
        // Set up the circular image
        setupImageUploadCircle()
        
        
        // Set up the views shapes
        setupAboutUsView()
        setupEmployabilityGoalsContainerView()
        setupOurVisionView()
        setupAboutUsTextView()
        setupEmployabilityGoalsContainerTextView()
        setupOurVisionTextView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if thereIsInfo {
            btnAddInfo.isHidden = true
            AboutUsView.isHidden = false
            ourVisionView.isHidden = false
            OutEmployabiliotyView.isHidden = false
            btnEdit.isEnabled = true

            
        }else{
            btnAddInfo.isHidden = false
            AboutUsView.isHidden = true
            ourVisionView.isHidden = true
            OutEmployabiliotyView.isHidden = true
            btnEdit.isEnabled = false
            btnEdit.tintColor = .lightGray
        }
    }
    
    
    @IBAction func unwindSegueBackToCompanyProfile(segue: UIStoryboardSegue) {
        if segue.identifier == "back"{
            
        }
    }
    
    
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    
    private func setupAboutUsView() {
        aboutUsContainerView.layer.cornerRadius = 20.0
        aboutUsContainerView.backgroundColor = .lightGray;
    }
    
    private func setupEmployabilityGoalsContainerView() {
        employabilityGoalsContainerView.layer.cornerRadius = 20.0
        employabilityGoalsContainerView.backgroundColor = .lightGray;
    }
    
    private func setupOurVisionView() {
        ourVisionContainerView.layer.cornerRadius = 20.0
        ourVisionContainerView.backgroundColor = .lightGray;
    }
    
    private func setupAboutUsTextView() {
        aboutUsTextView.backgroundColor = .lightGray;
    }
    
    private func setupEmployabilityGoalsContainerTextView() {
        employabilityGoalsTextView.backgroundColor = .lightGray;
    }
    
    //ourVisionTextView
    private func setupOurVisionTextView() {
        ourVisionTextView.backgroundColor = .lightGray;
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
