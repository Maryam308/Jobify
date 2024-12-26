//
//  MainViewController.swift
//  testEducation
//
//  Created by Maryam Yousif on 18/12/2024.
//

import UIKit

class EducationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageHeader: UITextView!
    @IBOutlet weak var sectionTitle: UILabel!
    
    
    var educationData:[Education]=[]
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
         tableView.register(UINib(nibName: "EducationTableViewCell", bundle: nil), forCellReuseIdentifier: "EducationCell")
        
        //restore data in the table view
        //get the education array from the CvData shared model:
        let fetchedEducation = CVData.shared.education
        //loop through the array and add cells in the table view if it contains records (count not equals to 0 )
        if fetchedEducation.count != 0{
            educationData = fetchedEducation
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Store the education data back into the CVData model
        CVData.shared.education = educationData
    }
    

    @IBAction func addeducationTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
             if let educationVC = storyboard.instantiateViewController(identifier: "EducationFormVC") as? EducationFormViewController {
                 educationVC.delegate = self
                 navigationController?.pushViewController(educationVC, animated: true)
             }
    }
    // MARK: - TableView DataSource
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return educationData.count
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EducationCell", for: indexPath) as? EducationTableViewCell else {
            return UITableViewCell()
        }
        let education = educationData[indexPath.row]
        print("Degree: \(String(describing: education.degree)), Institution: \(String(describing: education.institution)), From: \(String(describing: education.startDate)), To: \(String(describing: education.endDate))") // Debug print
        cell.setup(education: education)
        return cell
      }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Show options for Edit or Delete
        let alertController = UIAlertController(title: "Options", message: "What would you like to do?", preferredStyle: .actionSheet)

        // Edit Action
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            let selectedDegree = self.educationData[indexPath.row]
            self.navigateToEducationForm(with: selectedDegree, at: indexPath.row)
        }

        // Delete Action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.educationData.remove(at: indexPath.row)
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
    
      // Navigate to Education Form for Add or Edit
    func navigateToEducationForm(with education: Education?, at index: Int?) {
          let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
          if let educationVC = storyboard.instantiateViewController(identifier: "EducationFormVC") as? EducationFormViewController {
              educationVC.delegate = self
              educationVC.degreeToEdit = education // Pass the degree to edit
              educationVC.editIndex = index    // Pass the index of the degree being edited
              navigationController?.pushViewController(educationVC, animated: true)
          }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return tableView.frame.width / 4.5
        } else {
            return tableView.frame.width / 2
        }
    }

  }

  // MARK: - Delegate to handle saving and editing
extension EducationViewController: EducationFormDelegate {

    func didSaveEducation(_ education: Education) {
        educationData.append(education)
        tableView.reloadData()
    }


      func didEditEducation(_ education: Education, at index: Int) {
          educationData[index] = education
          tableView.reloadData()
      }
  }
