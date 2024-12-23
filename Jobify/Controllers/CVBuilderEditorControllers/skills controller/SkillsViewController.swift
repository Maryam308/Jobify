//
//  SkillsViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 19/12/2024.
//

import UIKit

class SkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var skillsData:[cvSkills]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Register the custom cell
        tableView.register(UINib(nibName: "SkillsTableViewCell", bundle: nil), forCellReuseIdentifier: "SkillsCell")
        
        //restore data in the table view
        //get the skills array from the CvData shared model:
        let fetchedSkills = CVData.shared.skill
        //loop through the array and add cells in the table view if it contains records (count not equals to 0 )
        if fetchedSkills.count != 0{
            skillsData = fetchedSkills
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Store the skills data back into the CVData model
        CVData.shared.skill = skillsData
    }
    

    @IBAction func btnAddSkillTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
             if let skillsVC = storyboard.instantiateViewController(identifier: "SkillsFormVC") as? SkillsFormTableViewController {
                 skillsVC.delegate = self
                 navigationController?.pushViewController(skillsVC, animated: true)
             }
    }
    
    // MARK: - TableView DataSource
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return skillsData.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsCell", for: indexPath) as? SkillsTableViewCell else {
            return UITableViewCell()
        }
        let skill = skillsData[indexPath.row]
        cell.setup(skill: skill)
        return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 5
    }
    
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Show options for Edit or Delete
        let alertController = UIAlertController(title: "Options", message: "What would you like to do?", preferredStyle: .actionSheet)

        // Edit Action
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            let selectedSkill = self.skillsData[indexPath.row]
            self.navigateToSkillsForm(with: selectedSkill, at: indexPath.row)
        }

        // Delete Action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.skillsData.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // Navigate to Education Form for Add or Edit
    func navigateToSkillsForm(with skill: cvSkills?, at index: Int?) {
        let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
        if let skillsVC = storyboard.instantiateViewController(identifier: "SkillsFormVC") as? SkillsFormTableViewController {
            skillsVC.delegate = self
            skillsVC.skillToEdit = skill // Pass the skill to edit
            skillsVC.editIndex = index    // Pass the index of the skill being edited
            navigationController?.pushViewController(skillsVC, animated: true)
        }
    }
}

// MARK: - Delegate to handle saving and editing
extension SkillsViewController: SkillsFormDelegate {

  func didSaveSkill(_ skill: cvSkills) {
      skillsData.append(skill) // Add the new skill to the data source
          tableView.reloadData()   // Reload the table view to reflect the changes
  }

    func didEditSkill(_ skill: cvSkills, at index: Int) {
        skillsData[index] = skill
        tableView.reloadData()
    }
}
