//
//  AddNewSkill.swift
//  Jobify
//
//  Created by Maryam Ahmed on 23/12/2024.
//

import UIKit
import Firebase


class AddNewSkillViewController: UITableViewController {
    
    
    
    let db = Firestore.firestore()
    
    //these variables will be null if the screen has it passed for editing an existing skill
    var editSkillId: Int? = nil
    var editSkillTitle: String? = ""
    var editSkillDescription: String? = ""
    var edittingMode: Bool = false
    
    
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    @IBOutlet weak var lblScreenInstruction: UILabel!
    @IBOutlet weak var txtSkillDescription: UITextView!
    
    @IBOutlet weak var txtSkillTitle: UITextField!
    
    
    @IBOutlet weak var btnAddSkill: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //finalize the design by adding the rounded borders
        btnAddSkill.layer.cornerRadius = 10
        txtSkillDescription.layer.cornerRadius = 10
        txtSkillDescription.layer.borderWidth = 1
        txtSkillDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtSkillDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // If the skillTitle and skillDescription are set, it means you're editing
        if let title = editSkillTitle, !title.isEmpty,
               let description = editSkillDescription, !description.isEmpty  {
                    edittingMode = true
                    txtSkillTitle.text = title
                    txtSkillDescription.text = description
                    btnAddSkill.setTitle("Save Changes", for: .normal) // Change button title to "Save Changes" for edit mode
                    
                    //change the screen title
                    lblScreenTitle.text = "Edit Skill"
                    lblScreenInstruction.text = "Modify the skill details below."
                    
                } else {
                    btnAddSkill.setTitle("Add Skill", for: .normal) // Button title for adding a new skill
                    
                    //change the screen titles
                    lblScreenTitle.text = "Add New Skill"
                    lblScreenInstruction.text = "Enter the skill details below."
                    
                }
        
        
    }
   
    @IBAction func btnAddSkillClicked(_ sender: UIButton) {
        //validate all data inputs are added
        // if a field is not filled so then return
            guard let skillTitle = txtSkillTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines), !skillTitle.isEmpty else {
                showAlert( title: "Error" , message: "Please enter a valid skill title.")
                return
            }
            
            guard let skillDescription = txtSkillDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines), !skillDescription.isEmpty else {
                showAlert( title: "Error" ,message: "Please enter a valid skill description.")
                return
            }
        
        
        if edittingMode {
            
            // Editing existing skill
                    // Find the existing skill and update its data
                    
            db.collection("skills").whereField("skillId", isEqualTo: editSkillId!).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching skill to update: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("Skill not found for title: \(skillTitle)")
                    return
                }
                
                // Update the skill document with new data
                document.reference.updateData([
                    "title": skillTitle,
                    "description": skillDescription
                ]) { error in
                    if let error = error {
                        print("An error has occured \(error)")
                        self.showAlert(title: "Error", message: "Failed to update skill.")
                    } else {
                        self.showAlertWithCompletion(title: "Success", message: "Skill updated successfully." ){
                            self.navigationController?.popViewController(animated: true)}
                    }
                }
            }
            
        }else {
            
            let skill = Skill(title: skillTitle, description: skillDescription)
            
            // Create a dictionary to add directly to the skill document
                let skillData: [String: Any] = [
                    "skillId": skill.skillId,
                    "title": skill.title,
                    "description": skill.description,
            ]
            
            
            //add to the skills collection
            db.collection("skills").addDocument(data: skillData) { error in
                if let error = error {
                    print("Error adding skill: \(error)")
                    self.showAlert(title: "Error while adding to skill" ,message: "Failed to add skill. Please try again.")
                } else {
                    // Clear the form inputs
                    self.txtSkillTitle.text = ""
                    self.txtSkillDescription.text = ""
                    
                    // Show a success alert and navigate back after dismissal
                    self.showAlertWithCompletion(title: "Success", message: "Skill has been added successfully.") {
                        self.navigationController?.popViewController(animated: true)
                        
                        
                    }
                }
            }
            
            
        }
        
 
        
    }
    
        //this alert type wont do any action after clicked on 
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    //alerts that have action after completion
    func showAlertWithCompletion(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
   
    
    
}
