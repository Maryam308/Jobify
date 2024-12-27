//
//  SkillsFormTableViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 19/12/2024.
//

import UIKit

protocol SkillsFormDelegate: AnyObject {
    func didSaveSkill(_ skill: cvSkills)
    func didEditSkill(_ skill: cvSkills, at index: Int)
}

class SkillsFormTableViewController: UITableViewController {
    //outlet for the skill text field
    @IBOutlet weak var txtSkillTitle: UITextField!
    @IBOutlet weak var skillErr: UILabel!
    @IBOutlet weak var lblSkill: UILabel!
    // MARK: - Setup Button Constraints
    private func setupButton() {
        btnSaveSkill.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSaveSkill) // Add button to the view
        
        // Set constraints for the Save button
        NSLayoutConstraint.activate([
            btnSaveSkill.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20), // 20 points to the leading safe area
            btnSaveSkill.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20), // 20 points to the trailing safe area
            btnSaveSkill.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10), // 10 points above the bottom safe area
            btnSaveSkill.heightAnchor.constraint(equalToConstant: 44) // Set a height for the button
        ])
    }
    func adjustFontSize() {
       guard UIDevice.current.userInterfaceIdiom == .pad else { return }
       txtSkillTitle.font = txtSkillTitle.font?.withSize(20)
       skillErr.font = skillErr.font?.withSize(16)
       lblSkill.font = lblSkill.font?.withSize(18)
   }
    
    
    @IBOutlet weak var btnSaveSkill: UIButton!
    weak var delegate: SkillsFormDelegate?
    var skillToEdit: cvSkills? // The skill to edit (if editing)
    var editIndex: Int?       // The index of the skill being edited
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        adjustFontSize()
        // Populate the text field if editing
        if let skillToEdit = skillToEdit {
            txtSkillTitle.text = skillToEdit.skillTitle
        }
    }
    
    
    @IBAction func btnSaveSkillTapped(_ sender: UIButton) {
        checkForValidSkillsForm()
        // Ensure all fields are filled
        guard let skill = txtSkillTitle.text, !skill.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter skill title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let newSkill = cvSkills(title: skill)
        
        
        if let index = editIndex {
            // Editing existing skill
            delegate?.didEditSkill(newSkill, at: index)
        } else {
            // Adding new skill
            delegate?.didSaveSkill(newSkill)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //functions for skills validation
    //only enable the go to experience button when all fields are valid
    func checkForValidSkillsForm(){
        if skillErr.isHidden{
            btnSaveSkill.isEnabled = true
        }else{
            btnSaveSkill.isEnabled = false
        }
    }
    
    
    func invalidSkill(_ value: String) -> String? {
        // Check if the skill name is empty
        if value.isEmpty {
            return "Must not be empty"
        }

        // Check if the skill name contains only letters and spaces
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        let set = CharacterSet(charactersIn: value)
        if !allowedCharacterSet.isSuperset(of: set) {
            return "Must contain letters and spaces only"
        }

        // Check for minimum length
        if value.count < 2 {
            return "Must be at least 2 characters"
        }

        return nil
    }
    
    
    
    @IBAction func skillChanged(_ sender: UITextField) {
        if let skill = txtSkillTitle.text {
            if let errMsg = invalidSkill(skill){
                skillErr.text = errMsg
                skillErr.isHidden = false
            }else{
                skillErr.isHidden = true
            }
        }
        checkForValidSkillsForm()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
