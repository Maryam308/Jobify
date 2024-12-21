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
    
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 0
    
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
    
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
        
        //the placeholder disabled item
        let placeholder = UIAction(title: "Choose the Skill", attributes: .disabled) { _ in }
        
        //adding options to the skills popup button
        
        //call the fetchSkillTitles function and the array will be updated
        fetchSkillTitles()
        
        //loop through the array and add to the popup button menu
        // Create UIActions for each menu item
        let actions = skillTitles.map { item in
                UIAction(title: item) { action in
                    self.btnSkill.setTitle(action.title, for: .normal) // Update button title on selection
                }
            }

            // Combine the placeholder and actions into a menu
            let menu = UIMenu(title: "", children: [placeholder] + actions)

            // Assign the menu to the button
        btnSkill.menu = menu
        btnSkill.showsMenuAsPrimaryAction = true // Show the menu when tapped
        btnSkill.setTitle("Choose the Skill", for: .normal) // Set default button title

        
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
        let menuCategory = UIMenu(title: "", children: [placeholder, option1, option2, option3])
     

        // Assign the menu to the button
        btnCategory.menu = menuCategory
        btnCategory.showsMenuAsPrimaryAction = true //menu shows when tapped

        // Set the default title (placeholder)
        btnCategory.setTitle("Choose learning resource category", for: .normal)
        
        
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
        
        //fetch the inputs
        
        //validate the entered inputs
        guard let selectedTitle = btnSkill.currentTitle, selectedTitle != "Choose the Skill" else {
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


        var enteredSkill = selectedTitle
        var enteredCategory = selectedCategory
        
        if(currentUserRole == "admin"){
            
            //fetch the text inputs
            if let resourceTitle = txtTitle.text, let resourceDescrition = txtViewDescriptio.text , let resourceLink = txtLink.text {
                // Create a dictionary for the career path to add to the firebase document
                let learningResourceData = [
                    "title": resourceTitle,
                    "skill": enteredSkill,
                    "link": resourceLink,
                    "description": resourceDescrition,
                    "category": enteredCategory,
                    "datePubblished": Date(),
                    "publisherId": currentUserId
                ] as [String : Any]
                
                
                
                db.collection("LearningResources").addDocument(data: learningResourceData as [String : Any])
                { error in if let error = error { print("Error adding document: \(error)") } else { print("Document successfully added!") } }
                
            }//completing the add a learning resource
            
        }//closing if admin
        
        
        //adding a request if user is employer
        else if(currentUserRole == "employer"){
            
            //fetch the text inputs
            if let resourceTitle = txtTitle.text, let resourceDescrition = txtViewDescriptio.text , let resourceLink = txtLink.text {
                // Create a dictionary for the career path to add to the firebase document
                let learningResourceData = [
                    "title": resourceTitle,
                    "skill": enteredSkill,
                    "link": resourceLink,
                    "description": resourceDescrition,
                    "category": enteredCategory,
                    "datePubblished": Date(),
                    "publisherId": currentUserId,
                    "isApproved": NSNull()//set to null util the request is reviewed
                ] as [String : Any]
                
                
                
                db.collection("LearningResourcesRequests").addDocument(data: learningResourceData as [String : Any])
                { error in if let error = error { print("Error adding document: \(error)") } else { print("Document successfully added!") } }
                
            }//completing the add a learning resource
            
        }
        
        
        
        
        
        
    }
    
    
    
}
