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
    
    weak var delegate: EducationFormDelegate?
    var degreeToEdit: Education? // The degree to edit (if editing)
    var editIndex: Int?       // The index of the degree being edited
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the text field if editing
        if let degreeToEdit = degreeToEdit {
            txtDegree.text = degreeToEdit.degree
            txtInstitution.text = degreeToEdit.institution // Corrected this line
            from.date = degreeToEdit.startDate!
            to.date = degreeToEdit.endDate!
        }
    }
    @IBAction func saveEducationTapped(_ sender: UIButton) {
        // Ensure all fields are filled
          guard let degree = txtDegree.text, !degree.isEmpty,
                let institution = txtInstitution.text, !institution.isEmpty else {
              let alert = UIAlertController(title: "Error", message: "Please enter all education details", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              present(alert, animated: true, completion: nil)
              return
          }

          let startDate = from.date
          let endDate = to.date
          let education = Education(degree: degree, institution: institution, startDate: startDate, endDate: endDate)

          // Print the education record for debugging
          print("Saving Education Record: \(education)")

          if let index = editIndex {
              // Editing existing education
              delegate?.didEditEducation(education, at: index)
          } else {
              // Adding new education
              delegate?.didSaveEducation(education)
          }

          navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using 1 segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
