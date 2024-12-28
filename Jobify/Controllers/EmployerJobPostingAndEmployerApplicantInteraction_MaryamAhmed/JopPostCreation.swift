//
//  JopPostCreation.swift
//  Jobify
//
//  Created by Maryam Ahmed on 24/12/2024.
//

import UIKit
import Firebase

class JopPostCreationFirstScreenViewController: UITableViewController {
    
    @IBOutlet weak var btnEmploymentType: UIButton!
    
    //all outlets
    @IBOutlet weak var txtPositionTitle: UITextField!
    
    
    @IBOutlet weak var txtJobLocation: UITextField!
    
    
    @IBOutlet weak var btnPositionLevel: UIButton!
    
    
    
    @IBOutlet weak var btnPositionCategory: UIButton!
    
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //will load into the popup button
        
        setupBtnPositionLevel()
        setupCategoryMenu()
        setupEmploymentTypeMenu()
        
        
    }
    
    private func setupBtnPositionLevel() {
        let menuItems = JobLevel.allCases.map { level in
            UIAction(title: level.rawValue, handler: { [weak self] _ in
                self?.btnPositionLevel.setTitle(level.rawValue, for: .normal)
                print("Selected Job Level: \(level.rawValue)")
            })
        }
        
        btnPositionLevel.menu = UIMenu(title: "Select Position Level", children: menuItems)
        btnPositionLevel.showsMenuAsPrimaryAction = true
        btnPositionLevel.setTitle("Position Level", for: .normal) // Placeholder
    }

    
    private func setupCategoryMenu() {
        // Create menu actions for each category
        let menuItems = CategoryJob.allCases.map { category in
            UIAction(title: category.rawValue, handler: { [weak self] _ in
                // Update button title when an option is selected
                self?.btnPositionCategory.setTitle(category.rawValue, for: .normal)
                print("Selected Category: \(category.rawValue)")
            })
        }
        
        // Assign the menu to the button
        btnPositionCategory.menu = UIMenu(title: "Select Job Category", children: menuItems)
        btnPositionCategory.showsMenuAsPrimaryAction = true
        btnPositionCategory.setTitle("Select Category", for: .normal) // Placeholder
    }
    
    private func setupEmploymentTypeMenu() {
        // Create menu actions for each employment type
        let menuItems = EmploymentType.allCases.map { type in
            UIAction(title: type.rawValue, handler: { [weak self] _ in
                // Update button title when an option is selected
                self?.btnEmploymentType.setTitle(type.rawValue, for: .normal)
                print("Selected Employment Type: \(type.rawValue)")
            })
        }
        
        // Assign the menu to the button
        btnEmploymentType.menu = UIMenu(title: "Select Employment Type", children: menuItems)
        btnEmploymentType.showsMenuAsPrimaryAction = true
        btnEmploymentType.setTitle("Select Employment Type", for: .normal) // Placeholder
    }
    
    
    
    @IBAction func btnNextClick(_ sender: Any) {
        
        
        // Validate all fields are not empty and valid options are selected
           guard let positionTitle = txtPositionTitle.text, !positionTitle.isEmpty else {
               showAlert(message: "Please enter the position title.")
               return
           }
           
           guard let jobLocation = txtJobLocation.text, !jobLocation.isEmpty else {
               showAlert(message: "Please enter the job location.")
               return
           }
           
           guard let positionLevel = btnPositionLevel.title(for: .normal), positionLevel != "Position Level" else {
               showAlert(message: "Please select a position level.")
               return
           }
           
           guard let positionCategory = btnPositionCategory.title(for: .normal), positionCategory != "Select Category" else {
               showAlert(message: "Please select a job category.")
               return
           }
           
           guard let employmentType = btnEmploymentType.title(for: .normal), employmentType != "Select Employment Type" else {
               showAlert(message: "Please select an employment type.")
               return
           }
        
        
        //fetch the user refrence //and add it to the jobdata
        let currentId = currentLoggedInUserID
        
        
        fetchUserReference(by: currentId) { userRef in
            guard let userRef = userRef else {
                self.showAlert(message: "User reference not found.")
                return
            }
        
        var jobId: Int = 0
        //increment the jobId +=1 and assighn it as the jobId
            Job.fetchAndSetID {
                jobId = Job.jobIdCounter + 1
            
           
           // Create a dictionary to pass to the next screen
           let jobData: [String: Any] = [
            "jobPostId": jobId,
            "companyRef": userRef,
               "jobTitle": positionTitle,
               "jobLocation": jobLocation,
               "jobLevel": positionLevel,
               "jobCategory": positionCategory,
               "jobEmploymentType": employmentType
           ]
           
        
        
           // create the document and add data to it then navigate to the second screen
            db.collection("jobs").addDocument(data: jobData) { error in
                    if let error = error {
                        print("Error adding job post: \(error.localizedDescription)")
                        self.showAlert(message: "Failed to add job post. Please try again.")
                    } else {
                        print("Job post added successfully!")
                        
                        
                        // Navigate to the second screen if it's not already in the stack
                        if let secondScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "JopPostCreationSecondScreenViewController") as? JopPostCreationSecondScreenViewController {
                            secondScreenVC.jopPostId = jobId
                            print(jobId)
                            
                            if let existingVC = self.navigationController?.viewControllers.first(where: { $0 is JopPostCreationSecondScreenViewController }) {
                                // If the view controller is already in the stack, pop to it
                                self.navigationController?.popToViewController(existingVC, animated: true)
                            } else {
                                // Otherwise, push the new instance
                                self.navigationController?.pushViewController(secondScreenVC, animated: true)
                            }
                        }

                            
                    }
                }
           }
        
        }
        
        
       }
    
    // Helper function to show alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
   
    
    func fetchUserReference(by userId: Int, completion: @escaping (DocumentReference?) -> Void) {
            
        db.collection("users")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching user document: \(error)")
                        completion(nil)
                        return
                    }

                    guard let document = snapshot?.documents.first else {
                        print("No user document found for userId: \(userId)")
                        completion(nil)
                        return
                    }

                    // Return the reference to the found user document
                    completion(document.reference)
                }
        }
    
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    
}
