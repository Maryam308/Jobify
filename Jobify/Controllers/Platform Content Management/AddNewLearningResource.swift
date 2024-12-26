//
//  AddNewLearningResource.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import Firebase

// this view controller will be used to construct a learning resource from the admin side and request to add a learning resource if used by  employer
class AddNewLearningResourceViewController : UITableViewController {
    
    // creating class level variables
    let db = Firestore.firestore()
    var skillTitles: [String] = [] //to store skill titles and add to the popup button
        // to fetch the current user and the current user role
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 1
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
    var selectedSkillTitle: [String] = []
    
    //UI elements outlets
    
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var btnSkill: UIButton!
    
    @IBOutlet weak var txtLink: UITextField!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtViewDescriptio: UITextView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    
    //a function to fetch array list of skill titles from the database
    func fetchSkillTitles() {
        
        // fetch from skills collection
        //will have a snapshot for the whole collection
        db.collection("skills").getDocuments { (snapshot, error) in
            if let error = error {
                //return an error if any and stop excuting
                print("Error fetching skills: \(error)")
                return
            }
            
            // Extract titles from each document
            if let snapshot = snapshot {
                self.skillTitles = snapshot.documents.compactMap { document in
                    //cast if string
                    return document["title"] as? String
                }
                //check if the titles are fetched
                print("Fetched Skills: \(self.skillTitles)")
            }
            
            
            
            DispatchQueue.main.async {
                // add all skill titles as well as a disabled placeholder action that will act like a title for the pop-up button
                            var menuItems: [UIAction] = []

                            // Add placeholder option
                            let placeholderAction = UIAction(title: "Choose the skill to develop", attributes: .disabled) { _ in }
                            menuItems.append(placeholderAction)

                            // Add skill titles as options
                            for skillTitle in self.skillTitles {
                                let action = UIAction(title: skillTitle) { _ in
                                    self.btnSkill.setTitle(skillTitle, for: .normal) // Update button title when selected
                                }
                                menuItems.append(action)
                            }

                            // Attach the menu to the button
                            self.btnSkill.menu = UIMenu(title: "", children: menuItems)
                            self.btnSkill.showsMenuAsPrimaryAction = true
                        }
                    
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check if the user is an admin or an employer
        
        //fetch the current user role
        if(currentUserRole == "employer"){
            btnAdd.setTitle("Request to Add", for: .normal)
        }else if(currentUserRole == "admin"){
            btnAdd.setTitle("Add new learning resource", for: .normal)
        }
        
        //if the user is an admin the learning resource will be automatically added else it will be added as a request
                
        //add padding to the text view
        txtViewDescriptio.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //add round borders
        txtViewDescriptio.layer.cornerRadius = 10
        txtViewDescriptio.layer.borderWidth = 1
        txtViewDescriptio.layer.borderColor = UIColor.lightGray.cgColor
        
        //button ui style configuration
        btnAdd.layer.cornerRadius = 15
        btnAdd.backgroundColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
        
        
        //adding options to the skills popup button
        
        fetchSkillTitles()
       
        
        //load options to the category popup button
        let placeholderCategory = UIAction(title: "Choose learning resource category", attributes: .disabled) { _ in }
        
        // Define valid options
        let option1 = UIAction(title: "Certification") { _ in
            self.btnCategory.setTitle("Certification", for: .normal)
        }
        let option2 = UIAction(title: "Article") { _ in
            self.btnCategory.setTitle("Article", for: .normal)
        }
        let option3 = UIAction(title: "Online Course") { _ in
            self.btnCategory.setTitle("Online Course", for: .normal)
        }

        // Create the menu
        let menuCategory = UIMenu(title: placeholderCategory.title, children: [placeholderCategory, option1, option2, option3])
     

        // Assign the menu to the button
        btnCategory.menu = menuCategory
        btnCategory.showsMenuAsPrimaryAction = true //menu shows when tapped

        // Set the default placeholder title
        btnCategory.setTitle(placeholderCategory.title, for: .normal)
        
        
    }
    
    
    // Function to display an error alert
    func showAlert(title: String ,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    // Function to display an alert with a navigation action
    func showAlertAndNavigateBack(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" button that navigates back when tapped
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Navigate back to the previous screen
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    //on the button click
    @IBAction func btnAddClick(_ sender: UIButton) {
      
            // Validate inputs
            guard let selectedTitle = btnSkill.currentTitle, selectedTitle != "Choose the skill to develop" else {
                showAlert( title: "Invalid" , message: "Please select a valid skill.")
                return
            }

            guard let selectedCategory = btnCategory.currentTitle, selectedCategory != "Choose learning resource category" else {
                showAlert( title: "Invalid" ,message: "Please select a valid category.")
                return
            }

            guard let link = txtLink.text?.trimmingCharacters(in: .whitespacesAndNewlines), !link.isEmpty else {
                showAlert( title: "Invalid" ,message: "Please enter a valid link.")
                return
            }

            guard let title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
                showAlert( title: "Invalid" ,message: "Please enter a valid title.")
                return
            }

            guard let description = txtViewDescriptio.text?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty else {
                showAlert( title: "Invalid" ,message: "Please enter a valid description.")
                return
            }

            // Fetch user and skill references
            fetchUserReference(by: currentUserId) { userRef in
                guard let userRef = userRef else {
                    self.showAlert( title: "Invalid" ,message: "Failed to fetch user reference.")
                    return
                }

                self.fetchskillDocumentRefrence(by: selectedTitle) { skillDocRef in
                    guard let skillDocRef = skillDocRef else {
                        self.showAlert( title: "Error Fetching" ,message: "Failed to find the selected skill in the database.")
                        return
                    }

                    

                    if self.currentUserRole == "admin" {
                        
                        //struct a learningResource to generate the id and pass it to the database
                        let lr = LearningResource(type: selectedCategory, summary: description, link: link, title: title, skillRef: skillDocRef)
                        
                        // Prepare data to be added to Firestore for admin learning resources
                        let learningResourceData: [String: Any] = [
                            "learningResourceId": lr.learningResourceId,
                            "title": title,
                            "skill": skillDocRef,
                            "link": link,
                            "description": description,
                            "category": selectedCategory,
                            "datePublished": Date(),
                            "publisher": userRef
                        ]
                        
                        // Add directly to LearningResources collection
                        self.db.collection("LearningResources").addDocument(data: learningResourceData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                                self.showAlert(  title: "Error"  , message: "Failed to add learning resource.")
                            } else {
                                self.clearInputs()
                                self.showAlert( title: "Successful" ,message: "Learning resource added successfully.")
                            }
                        }
                    } else if self.currentUserRole == "employer" {
                        
                        //construct the request first to get an id
                        let lrr = LearningRequest(title: title)
                        
                        //add the learningRequest
                        let learningRequestData: [String: Any] = [
                            "requestId": lrr.requestId,
                            "title": title,
                            "skill": skillDocRef,
                            "link": link,
                            "description": description,
                            "category": selectedCategory,
                            "datePublished": Date(),
                            "publisher": userRef
                        ]
                        
                        
                        // Add to LearningResourcesRequests collection
                        var employerData = learningRequestData
                        employerData["isApproved"] = NSNull() // Approval status is null initially
                        self.db.collection("LearningResourcesRequests").addDocument(data: employerData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                                self.showAlert( title: "Error" ,message: "Failed to request learning resource.")
                            } else {
                                self.clearInputs()
                                self.showAlertAndNavigateBack( title: "Successful" ,message: "Learning resource request successfully submitted!")
                                
                            }
                        }
                    }
                }
            }
        }

    func clearInputs() {
        // Reset all input fields
        btnCategory.setTitle("Choose learning resource category", for: .normal)
        btnSkill.setTitle("Choose the skill to develop", for: .normal)
        txtLink.text = ""
        txtTitle.text = ""
        txtViewDescriptio.text = ""
    }
    
    
    func fetchskillDocumentRefrence (by skillTitle: String, completion: @escaping (DocumentReference?) -> Void) {
        
                db.collection("skills")
                    .whereField("title", isEqualTo: skillTitle)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching user document: \(error)")
                            completion(nil)
                            return
                        }

                        guard let document = snapshot?.documents.first else {
                            print("No user document found for skill title: \(skillTitle)")
                            
                            return
                        }

                        // Return the reference to the found user document
                        completion(document.reference)
                    }
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
    
}
