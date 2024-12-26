//
//  ExperienceViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 19/12/2024.
//

import UIKit

class ExperienceViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageHeader: UITextView!
    @IBOutlet weak var sectionTitle: UILabel!
    
    
    var experienceData:[WorkExperience]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adjust font size for iPads
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageHeader.font = pageHeader.font!.withSize(24)
            sectionTitle.font = sectionTitle.font.withSize(20)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the custom cell
        tableView.register(UINib(nibName: "ExperienceTableViewCell", bundle: nil), forCellReuseIdentifier: "ExperienceCell")
        
        //restore data in the table view
        //get the experience array from the CvData shared model:
        let fetchedExperience = CVData.shared.experience
        //loop through the array and add cells in the table view if it contains records (count not equals to 0 )
        if fetchedExperience.count != 0{
            experienceData = fetchedExperience
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Store the experience data back into the CVData model
        CVData.shared.experience = experienceData
    }
    
    @IBAction func btnAddExperienceTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
        if let experienceVC = storyboard.instantiateViewController(identifier: "ExperienceFormVC") as? ExperienceFormTableViewController {
            experienceVC.delegate = self
            navigationController?.pushViewController(experienceVC, animated: true)
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experienceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as? ExperienceTableViewCell else {
            return UITableViewCell()
        }
        let experience = experienceData[indexPath.row]
        cell.setup(experience: experience)
        return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return tableView.frame.width / 3
        } else {
            return tableView.frame.width / 2 + 50
        }
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Show options for Edit or Delete
        let alertController = UIAlertController(title: "Options", message: "What would you like to do?", preferredStyle: .actionSheet)

        // Edit Action
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            let selectedExperience = self.experienceData[indexPath.row]
            self.navigateToExperienceForm(with: selectedExperience, at: indexPath.row)
        }

        // Delete Action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.experienceData.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        // Configure popover for iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = tableView // The source view from which the popover will pop up
            popoverController.sourceRect = tableView.rectForRow(at: indexPath) // Use the selected row as the anchor
        }

        present(alertController, animated: true, completion: nil)
    }

    // Navigate to Experience Form for Add or Edit
    func navigateToExperienceForm(with experience: WorkExperience?, at index: Int?) {
        let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
        if let experienceVC = storyboard.instantiateViewController(identifier: "ExperienceFormVC") as? ExperienceFormTableViewController {
            experienceVC.delegate = self
            experienceVC.experienceToEdit = experience // Pass the experience to edit
            experienceVC.editIndex = index    // Pass the index of the experience being edited
            navigationController?.pushViewController(experienceVC, animated: true)
        }
    }
  
}

// MARK: - Delegate to handle saving and editing
extension ExperienceViewController: ExperienceFormDelegate {

    func didSaveExperience(_ experience: WorkExperience) {
        experienceData.append(experience)
      tableView.reloadData()
  }


    func didEditExperience(_ experience: WorkExperience, at index: Int) {
        experienceData[index] = experience
        tableView.reloadData()
    }
}
