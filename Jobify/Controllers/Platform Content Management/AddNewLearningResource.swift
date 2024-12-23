//
//  AddNewLearningResource.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import Firebase

class AddNewLearningResourceViewController : UITableViewController {
    
    let db = Firestore.firestore()
    var skillTitles: [String] = [] //to store skill titles and add to the popup button
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
    
    //on view did load add border and radius and load values into the pop up button
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if the user is an admin or an employer
            //fetch the user id
        
        //fetch the current user role
        if(currentUserRole == "employer"){
            btnAdd.setTitle("Request to Add", for: .normal)
        }else if(currentUserRole == "admin"){
            btnAdd.setTitle("Add new learning resource", for: .normal)
        }
        
        //if the user is an admin the learning resource will be automatically added
                
        
        //add padding to the text view
        txtViewDescriptio.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //add round borders
        txtViewDescriptio.layer.cornerRadius = 10
        txtViewDescriptio.layer.borderWidth = 1
        txtViewDescriptio.layer.borderColor = UIColor.lightGray.cgColor
        
        //button ui style configuration
        btnAdd.layer.cornerRadius = 15
        btnAdd.backgroundColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
        
        //set menu and options for the pop up menus
        
        
        
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

        // Set the default title (placeholder)
        btnCategory.setTitle(placeholderCategory.title, for: .normal)
        
        
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
    
    
    //on the button click
    @IBAction func btnAddClick(_ sender: UIButton) {
      
            // Validate inputs
            guard let selectedTitle = btnSkill.currentTitle, selectedTitle != "Choose the skill to develop" else {
                showErrorAlert(message: "Please select a valid skill.")
                return
            }

            guard let selectedCategory = btnCategory.currentTitle, selectedCategory != "Choose learning resource category" else {
                showErrorAlert(message: "Please select a valid category.")
                return
            }

            guard let link = txtLink.text?.trimmingCharacters(in: .whitespacesAndNewlines), !link.isEmpty else {
                showErrorAlert(message: "Please enter a valid link.")
                return
            }

            guard let title = txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
                showErrorAlert(message: "Please enter a valid title.")
                return
            }

            guard let description = txtViewDescriptio.text?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty else {
                showErrorAlert(message: "Please enter a valid description.")
                return
            }

            // Fetch user and skill references
            fetchUserReference(by: currentUserId) { userRef in
                guard let userRef = userRef else {
                    self.showErrorAlert(message: "Failed to fetch user reference.")
                    return
                }

                self.fetchskillDocumentRefrence(by: selectedTitle) { skillDocRef in
                    guard let skillDocRef = skillDocRef else {
                        self.showErrorAlert(message: "Failed to find the selected skill in the database.")
                        return
                    }

                    // Prepare data to be added to Firestore
                    let learningResourceData: [String: Any] = [
                        "title": title,
                        "skill": skillDocRef,
                        "link": link,
                        "description": description,
                        "category": selectedCategory,
                        "datePublished": Date(),
                        "publisher": userRef
                    ]

                    if self.currentUserRole == "admin" {
                        // Add directly to LearningResources collection
                        self.db.collection("LearningResources").addDocument(data: learningResourceData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                                self.showErrorAlert(message: "Failed to add learning resource.")
                            } else {
                                print("Learning resource successfully added!")
                            }
                        }
                    } else if self.currentUserRole == "employer" {
                        // Add to LearningResourcesRequests collection
                        var employerData = learningResourceData
                        employerData["isApproved"] = NSNull() // Approval status is null initially
                        self.db.collection("LearningResourcesRequests").addDocument(data: employerData) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                                self.showErrorAlert(message: "Failed to request learning resource.")
                            } else {
                                print("Learning resource request successfully submitted!")
                            }
                        }
                    }
                }
            }
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
