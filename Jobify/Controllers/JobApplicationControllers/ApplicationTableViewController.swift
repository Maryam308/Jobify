//
//  ApplicationTableViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 23/12/2024.
//

import UIKit

class ApplicationTableViewController: UITableViewController {

    var selectedCV: CV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewBorder()
        
    }
 
    @IBOutlet weak var introductionText: UITextView!
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var contributionText: UITextView!
    
    
    func createViewBorder() {
        introductionText.layer.borderColor = UIColor.gray.cgColor
        introductionText.layer.borderWidth = 1.0
        introductionText.clipsToBounds = true
        
        motivationText.layer.borderColor = UIColor.gray.cgColor
        motivationText.layer.borderWidth = 1.0
        motivationText.clipsToBounds = true
        
        contributionText.layer.borderColor = UIColor.gray.cgColor
        contributionText.layer.borderWidth = 1.0
        contributionText.clipsToBounds = true
    }
    
    
    @IBOutlet weak var attachmentLabel: UILabel!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChooseCV",
               let navController = segue.destination as? UINavigationController,
               let destinationVC = navController.topViewController as? ChooseCVTableViewController {
                // Pass the closure to handle the selected CV
                destinationVC.onCVSelected = { [weak self] selectedCV in
                    self?.selectedCV = selectedCV
                    self?.attachmentLabel.text = selectedCV.cvTitle
                }
            }
            
        }
    
    @IBAction func sendApplication(_ sender: UIButton) {
        guard let selectedCV = selectedCV else {
                    print("No CV selected.")
                    return
                }

                
                let applicationData = [
                    "cvTitle": selectedCV.cvTitle,
                    "cvID": selectedCV.cvID,
                    "introduction": introductionText.text ?? "",
                    "motivation": motivationText.text ?? "",
                    "contribution": contributionText.text ?? ""
                ]

                print("Application Data: \(applicationData)")
                // Add your logic to send the data to Firestore or your backend
            }
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.count
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


