//
//  AddNewCareerPath.swift
//  Jobify
//
//  Created by Maryam Ahmed on 15/12/2024.
//

import UIKit
import Firebase


class AddNewCareerPathViewController: UITableViewController { 
    
    //setup to use firestore database
    let db = Firestore.firestore()
    
    //in case of editing variables
    var editCareerPathId: Int? // ID for editing mode

    var editCareerPathTitle: String = ""
    var editCareerPathCareer: String = ""
    var editCareerPathRoadMap: String = ""
    var editCareerPathDemand: String = ""
    var forEditing: Bool = false
    
    @IBOutlet weak var btnCareer: UIButton!//add button
    @IBOutlet weak var btnDemand: UIButton! //popup button
    //outlets
    @IBOutlet weak var txtViewCareer: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtViewRoadMap: UITextView!
    
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var screenInstruction: UILabel!
    
    //in the method load borders will be added to the textviews - button radius - load the career demand into the popup button
    
    override func viewDidLoad() {
        
       // Add padding to the views
        txtViewCareer.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        txtViewRoadMap.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

           // Add rounded borders
        txtViewCareer.layer.cornerRadius = 10
        txtViewCareer.layer.borderWidth = 1
        txtViewCareer.layer.borderColor = UIColor.lightGray.cgColor
        txtViewRoadMap.layer.cornerRadius = 10
        txtViewRoadMap.layer.borderWidth = 1
        txtViewRoadMap.layer.borderColor = UIColor.lightGray.cgColor
        
        //add corner radius and color to the add button
        btnCareer.layer.cornerRadius = 15
        btnCareer.backgroundColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
        
        //by default
        //set screen heading
        screenTitle.text = "Add New Career Path"
        screenInstruction.text = "Fill in the details required."
        
        
        // Define the placeholder item (disabled)
           let placeholder = UIAction(title: "Choose the Career Demand", attributes: .disabled) { _ in }

           // Define valid options
           let option1 = UIAction(title: "High") { _ in
               self.btnDemand.setTitle("High", for: .normal)
           }
           let option2 = UIAction(title: "Medium") { _ in
               self.btnDemand.setTitle("Medium", for: .normal)
           }
           let option3 = UIAction(title: "Low") { _ in
               self.btnDemand.setTitle("Low", for: .normal)
           }

           // Create the menu
           let menu = UIMenu(title: "", children: [placeholder, option1, option2, option3])
        

           // Assign the menu to the button
        btnDemand.menu = menu
        btnDemand.showsMenuAsPrimaryAction = true // Ensures the menu shows when tapped

           // Set the default title (placeholder)
        btnDemand.setTitle(placeholder.title, for: .normal)
        
        
        //if the screen is made for editing fetch and display the data
        if let id = editCareerPathId {
               forEditing = true
               btnCareer.setTitle("Save Changes", for: .normal)
            
            //set screen heading
            screenTitle.text = "Edit Career Path"
            screenInstruction.text = "Edit the details as needed."
            
               // Fetch details from Firebase for the given ID
               db.collection("careerPaths")
                   .whereField("careerPathId", isEqualTo: id)
                   .getDocuments { snapshot, error in
                       if let error = error {
                           print("Error fetching career path: \(error)")
                           return
                       }
                       
                       guard let document = snapshot?.documents.first else {
                           print("No matching career path found.")
                           return
                       }
                       
                       let data = document.data()
                       self.txtTitle.text = data["title"] as? String
                       self.txtViewCareer.text = data["description"] as? String
                       self.txtViewRoadMap.text = data["roadmap"] as? String
                       if let demand = data["demand"] as? String {
                           self.btnDemand.setTitle(demand, for: .normal)
                       }
                   }
        }

        
    }
    
    
    // Function to display an error alert
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Add an "OK" button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnAdd_Click(_ sender: Any) {
        
            //fetch the values of the text views
        
        //validate all data is entered
        guard let selectedTitle = btnDemand.currentTitle, selectedTitle != "Choose the Career Demand" else {
            showErrorAlert(message: "Please select a valid demand option.")
            return
        }

        guard let title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            showErrorAlert(message: "Please enter a valid title.")
            return
        }

        guard let careerText = txtViewCareer.text?.trimmingCharacters(in: .whitespacesAndNewlines), !careerText.isEmpty else {
            showErrorAlert(message: "Please enter career description.")
            return
        }

        guard let roadMapText = txtViewRoadMap.text?.trimmingCharacters(in: .whitespacesAndNewlines), !roadMapText.isEmpty else {
            showErrorAlert(message: "Please enter a valid RoadMap.")
            return
        }

        // Proceed with valid inputs


        var enteredDemand: String? = ""
        enteredDemand = selectedTitle
        
           
        if let id = editCareerPathId { // Editing mode
                // Update the existing career path in Firebase
                db.collection("careerPaths")
                    .whereField("careerPathId", isEqualTo: id)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching career path for update: \(error)")
                            return
                        }
                        
                        guard let document = snapshot?.documents.first else {
                            print("No matching career path found.")
                            return
                        }
                        
                        // Update the document
                        document.reference.updateData([
                            "title": title,
                            "description": careerText,
                            "roadmap": roadMapText,
                            "demand": selectedTitle
                        ]) { error in
                            if let error = error {
                                print("Error updating career path: \(error)")
                            } else {
                                print("Career path updated successfully!")
                                self.showAlertWithCompletion(title: "Success", message: "Career Path Updated") {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
        }else{
            
            //validate that the fields are not empty and safely unwrap optional values
            if let enteredTitle = txtTitle.text,
               let enteredCareer = txtViewCareer.text,
               let enteredRoadMap = txtViewRoadMap.text {
                
                CareerPath.fetchAndID { [self] in
                    //construct to get an auto incremented
                    let careerPath = CareerPath(careerName: enteredTitle, demand: enteredDemand, roadmap: enteredRoadMap,description: enteredCareer)
                    // Create a dictionary for the career path to add to the firebase document
                    let careerPathData = [
                        "careerPathId": careerPath.careerId,
                        "title": enteredTitle,
                        "roadmap": enteredRoadMap,
                        "description": enteredCareer,
                        "demand": enteredDemand!
                    ] as [String : Any]
                    
                    // Add values to database
                    //in the collection 'careerPaths' using auto generated id
                    //2- Add document to the collection and pass the data
                    //3- Add error handling if there is a returned error from firebase and provide feedback
                    self.db.collection("careerPaths").addDocument(data: careerPathData as [String : Any])
                    { error in if let error = error { print("Error adding document: \(error)") } else { print("Document successfully added!") } }
                    
                    //clear input and alert success and navigate back
                    txtTitle.text = ""
                    txtViewRoadMap.text = ""
                    txtViewCareer.text = ""
                    btnDemand.setTitle("Choose the Career Demand", for: .normal)
                    showAlertWithCompletion(title: "Success", message: "Career Path Added"){
                        self.navigationController?.popViewController(animated: true)
                    }
                }

                
            }
        }
        
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




