//
//  ExperienceFormTableViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 19/12/2024.
//

import UIKit
protocol ExperienceFormDelegate: AnyObject {
    func didSaveExperience(_ experience: WorkExperience)
    func didEditExperience(_ experience: WorkExperience, at index: Int)
}
class ExperienceFormTableViewController: UITableViewController {
    
    @IBOutlet weak var txtCompany: UITextField!
    
    @IBOutlet weak var txtRole: UITextField!
    

    @IBOutlet weak var experienceFrom: UIDatePicker!
    
    @IBOutlet weak var experienceTo: UIDatePicker!
    
    
    @IBOutlet weak var txtResponsibility: UITextView!
    
    @IBOutlet weak var companyErr: UILabel!
    
    @IBOutlet weak var roleErr: UILabel!
    
    @IBOutlet weak var responsibilityErr: UILabel!
    
    @IBOutlet weak var btnSaveExperience: UIButton!
    weak var delegate: ExperienceFormDelegate?
    var experienceToEdit: WorkExperience? // The experience to edit (if editing)
    var editIndex: Int?       // The index of the experience being edited
    override func viewDidLoad() {
        super.viewDidLoad()
        addBorderToTextView()
        // Populate the text field if editing
        if let experienceToEdit = experienceToEdit {
            txtCompany.text = experienceToEdit.company
            txtRole.text = experienceToEdit.role
            experienceFrom.date = experienceToEdit.startDate!
            experienceTo.date = experienceToEdit.endDate!
        }

    }


    @IBAction func btnSaveExperienceTapped(_ sender: UIButton) {
        // Check for valid experience form
           checkForValidExperienceForm()
           
           // Ensure all fields are filled
           guard let company = txtCompany.text, !company.isEmpty,
                 let role = txtRole.text, !role.isEmpty,
                 let responsibilities = txtResponsibility.text, !responsibilities.isEmpty else {
               let alert = UIAlertController(title: "Error", message: "All fields must be filled out", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
               return
           }

           // Ensure end date is greater than or equal to start date
           let startDate = experienceFrom.date
           let endDate = experienceTo.date
           
           guard endDate >= startDate else {
               let alert = UIAlertController(title: "Error", message: "End date must be greater than the start date", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
               return
           }
           
           let experience = WorkExperience(company: company, role: role, startDate: startDate, endDate: endDate, keyResponsibilities: responsibilities)

           if let index = editIndex {
               // Editing existing experience
               delegate?.didEditExperience(experience, at: index)
           } else {
               // Adding new experience
               delegate?.didSaveExperience(experience)
           }

           navigationController?.popViewController(animated: true)
    }
    
    //validation
    //functions for experience validation
    func checkForValidExperienceForm(){
        if companyErr.isHidden && roleErr.isHidden && responsibilityErr.isHidden{
            btnSaveExperience.isEnabled = true
        }else{
            btnSaveExperience.isEnabled = false
        }
    }
    
    func invalidCompany(_ value: String) -> String? {
        // Check if the company name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        
         //Check if the company name contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)

        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or punctuation"
        }
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }
        return nil
    }
    
    func invalidRole(_ value: String) -> String? {
        // Check if the role name is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        // Check if the role name contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)

        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or permissible punctuation only"
        }
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }
        return nil
    }
    
    func invalidResponsibility(_ value: String) -> String? {
        // Check if the responsibility description is empty
        if value.isEmpty {
            return "Must not be empty"
        }
        // Check if the responsibility description contains only letters, numbers, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.whitespaces)
            .union(CharacterSet.punctuationCharacters)

        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, numbers, spaces, or punctuation"
        }

        // Check for minimum length
        if value.count < 5 {
            return "Must be at least 5 characters"
        }

        return nil
    }
    
    //text fields validation for experience page
    
    @IBAction func companyChanged(_ sender: UITextField) {
        if let company = txtCompany.text {
            if let errMsg = invalidCompany(company){
                companyErr.text = errMsg
                companyErr.isHidden = false
            }else{
                companyErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
    

    @IBAction func roleChanged(_ sender: UITextField) {
        if let role = txtRole.text {
            if let errMsg = invalidRole(role){
                roleErr.text = errMsg
                roleErr.isHidden = false
            }else{
                roleErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
 
    
    @IBAction func responsibilityChanged(_ sender: UITextField) {
        if let responsibility = txtResponsibility.text {
            if let errMsg = invalidResponsibility(responsibility){
                responsibilityErr.text = errMsg
                responsibilityErr.isHidden = false
            }else{
                responsibilityErr.isHidden = true
            }
        }
        checkForValidExperienceForm()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func addBorderToTextView() {
        // Set border color and width
        txtResponsibility.layer.borderColor = UIColor.gray.cgColor
        txtResponsibility.layer.borderWidth = 1.0
        txtResponsibility.layer.cornerRadius = 5.0
    }
}
