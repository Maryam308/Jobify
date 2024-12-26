//
//  EducationFormViewController.swift
//  testEducation
//
//  Created by Maryam Yousif on 18/12/2024.
//

import UIKit
protocol EducationFormDelegate: AnyObject {
    func didSaveEducation(_ education: Education)
    func didEditEducation(_ education: Education, at index: Int)
}

class EducationFormViewController: UITableViewController {
    @IBOutlet weak var txtDegree: UITextField!
    @IBOutlet weak var txtInstitution: UITextField!
    @IBOutlet weak var from: UIDatePicker!
    @IBOutlet weak var to: UIDatePicker!
    @IBOutlet weak var degreeErr: UILabel!
    @IBOutlet weak var institutionErr: UILabel!
    @IBOutlet weak var btnSaveEducation: UIButton!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblInstitution: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    func adjustFontSizeForDevice() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        txtDegree.font = txtDegree.font?.withSize(20)
        txtInstitution.font = txtInstitution.font?.withSize(20)
        degreeErr.font = degreeErr.font?.withSize(16)
        institutionErr.font = institutionErr.font?.withSize(16)
        btnSaveEducation.titleLabel?.font = btnSaveEducation.titleLabel?.font.withSize(20)
        lblDegree.font = lblDegree.font?.withSize(18)
        lblInstitution.font = lblInstitution.font?.withSize(18)
        lblFrom.font = lblFrom.font?.withSize(18)
        lblTo.font = lblTo.font?.withSize(18)
    }
    
    weak var delegate: EducationFormDelegate?
    var degreeToEdit: Education? // The degree to edit (if editing)
    var editIndex: Int?       // The index of the degree being edited
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustFontSizeForDevice()
        // Populate the text field if editing
        if let degreeToEdit = degreeToEdit {
            txtDegree.text = degreeToEdit.degree
            txtInstitution.text = degreeToEdit.institution // Corrected this line
            from.date = degreeToEdit.startDate!
            to.date = degreeToEdit.endDate!
        }
    }
    
    @IBAction func saveEducationTapped(_ sender: UIButton) {
        // Check for valid education form
          checkForValidEducationForm()
          
          // Ensure all fields are filled
          guard let degree = txtDegree.text, !degree.isEmpty,
                let institution = txtInstitution.text, !institution.isEmpty else {
              let alert = UIAlertController(title: "Error", message: "All fields must be filled out", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true, completion: nil)
              return
          }

          // Ensure end date is greater than or equal to start date
          let startDate = from.date
          let endDate = to.date
          
          guard endDate >= startDate else {
              let alert = UIAlertController(title: "Error", message: "End date must be greater than the start date", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true, completion: nil)
              return
          }

          // Create the Education object
          let education = Education(degree: degree, institution: institution, startDate: startDate, endDate: endDate)

          if let index = editIndex {
              // Editing existing education
              delegate?.didEditEducation(education, at: index)
          } else {
              // Adding new education
              delegate?.didSaveEducation(education)
          }

          navigationController?.popViewController(animated: true)
    }
    
    //validation
    //functions for education validation
    func checkForValidEducationForm(){
        if degreeErr.isHidden && institutionErr.isHidden{
            btnSaveEducation.isEnabled = true
        }else{
            btnSaveEducation.isEnabled = false
        }
    }
    
    func invalidDegree(_ value: String) -> String? {
        // Check if the degree name is empty
        if value.isEmpty {
            return "Must not be empty"
        }

        // Check if the degree name contains only letters, spaces, hyphens, dots, commas, and apostrophes
        let allowedCharacterSet = CharacterSet.letters
            .union(CharacterSet.whitespaces)
            .union(CharacterSet(charactersIn: "-.,'"))
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Contains invalid character"
        }

        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    func invalidInstitution(_ value: String) -> String? {
        // Check if the institution name is empty
        if value.isEmpty {
            return "Must not be empty"
        }

        // Check if the institution name contains only letters, spaces, and permissible punctuation
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces).union(CharacterSet.punctuationCharacters)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters, spaces, or permissible punctuation"
        }
        
        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    
    //text fields validation for education page
    @IBAction func degreeChanged(_ sender: UITextField) {
        if let degree = txtDegree.text {
            if let errMsg = invalidDegree(degree){
                degreeErr.text = errMsg
                degreeErr.isHidden = false
            }else{
                degreeErr.isHidden = true
            }
        }
        checkForValidEducationForm()
    }
    
    
    @IBAction func institutionChanged(_ sender: UITextField) {
        if let institution = txtInstitution.text {
            if let errMsg = invalidInstitution(institution){
                institutionErr.text = errMsg
                institutionErr.isHidden = false
            }else{
                institutionErr.isHidden = true
            }
        }
        checkForValidEducationForm()
    }
    
 

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
