//
//  LearningResourcesSkills.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import Firebase

class LearningResourcesSkillsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        skills.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fetch the cell to reuse using the specified one from the in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillCell", for: indexPath) as! SkillsCollectionViewCells
        
        // Configure the cell with the skill data title and store the id
        cell.configure(with: skills[indexPath.item])
        
        
        //return the ready cell
        return cell
    }
    
    @IBOutlet weak var skillsCollection: UICollectionView!
    
    var skills: [Skill] = []
    
    //skill needs a title and a description
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        skillsCollection.delegate = self
        skillsCollection.dataSource = self
        
        fetchSkills()
        
    }
    
    func fetchSkills() {
        let db = Firestore.firestore()
        
        db.collection("skills")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching skills: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else { return }
                
                self.skills = snapshot.documents.map { document in
                    let data = document.data()
                    let id = data["skillId"] as? Int ?? 0
                    let title = data["title"] as? String ?? "Untitled"
                    let description = data["description"] as? String ?? "No description"
                    let documentReference = document.reference // Get the DocumentReference
                    
                    // Initialize Skill with title, description, and document reference
                    return Skill(skillId: id , title: title, description: description, documentReference: documentReference)
                }
                
                // Reload the collection view or perform any additional actions
                DispatchQueue.main.async {
                    self.skillsCollection.reloadData() // Assuming you have a collection view to reload
                }
            }
    }
    
    
    
    //MARK: showing the action sheet to edit or delete
    func showActionSheet(skillId: Int){
       
        
        // Create the action sheet
        let actionSheet = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        // Add "Edit" action
        let editAction = UIAlertAction(title: "Edit Skill", style: .default) { _ in
            print("Edit action selected")
            self.performEditAction(skillId: skillId) // Call your edit function here
        }
        
        // Add "Remove" action
        let removeAction = UIAlertAction(title: "Remove Skill", style: .destructive) { _ in
            print("Remove action selected")
            self.confirmAndDeleteSkill(skillId: skillId)// Call your remove function here
        }
        
        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add actions to the action sheet
        actionSheet.addAction(editAction)
        actionSheet.addAction(removeAction)
        actionSheet.addAction(cancelAction)
        
        // For iPads: Set the source for the popoverPresentationController
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // The view containing the button
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Center of the screen
            popoverController.permittedArrowDirections = [] // No arrow
        }
        
        // Present the action sheet
        present(actionSheet, animated: true)
        
    }
    
    //MARK: Edit the skill using the add form and changing it to edit mode
    func performEditAction(skillId: Int){
        
        //will navigate to an edit screen passing the skill title along
        db.collection("skills").whereField("skillId", isEqualTo: skillId).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching skill: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No skill found with the id: \(skillId)")
                    return
                }
                
                // fetch the skill descriptioin
                let skillData = document.data()
                let skillTitle = skillData["title"] as? String ?? ""
                let skillDescription = skillData["description"] as? String ?? ""
                
                // Create the AddNewSkillViewController instance
                let storyboard = UIStoryboard(name: "PlatformContentManagement_MaryamAhmed", bundle: nil)
                if let addNewSkillVC = storyboard.instantiateViewController(withIdentifier: "AddNewSkillViewController") as? AddNewSkillViewController {
                    // Pass the data (title and description) to the next screen
                    addNewSkillVC.editSkillId = skillId
                    addNewSkillVC.editSkillTitle = skillTitle
                    addNewSkillVC.editSkillDescription = skillDescription
                    
                    // Navigate to the AddNewSkillViewController
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(addNewSkillVC, animated: true)
                    }
                }
            }
        
    }
    
    
    //MARK: confirm and delete the skill and wait till compeletion to reload
    func confirmAndDeleteSkill(skillId: Int) {
        // Step 1: Show confirmation alert
        let alertController = UIAlertController(
            title: "Delete Skill",
            message: "Are you sure you want to delete this skill and its associated learning resources?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            // Proceed with deletion if user confirms
            self.deleteSkillAndResources(skillId: skillId) {
                // Return after deletion completion
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)

                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }

    private func deleteSkillAndResources(skillId: Int, completion: @escaping () -> Void) {
        let skillsCollection = db.collection("skills")
        let learningResourcesCollection = db.collection("LearningResources")
        
        // Step 2: Find the skill document by ID
        skillsCollection
            .whereField("skillId", isEqualTo: skillId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching skill document: \(error)")
                    completion() // Complete even if there was an error
                    return
                }
                
                guard let skillDoc = snapshot?.documents.first else {
                    print("No skill document found for ID: \(skillId)")
                    completion() // Complete even if no document is found
                    return
                }
                
                let skillDocRef = skillDoc.reference
                
                // Step 3: Delete the skill document
                skillDocRef.delete { error in
                    if let error = error {
                        print("Error deleting skill document: \(error)")
                        completion() // Complete even if there was an error
                        return
                    }
                    
                    print("Skill document deleted successfully: \(skillDocRef.path)")
                    
                    // Step 4: Delete associated learning resources
                    learningResourcesCollection
                        .whereField("skill", isEqualTo: skillDocRef)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                print("Error fetching learning resources: \(error)")
                                completion() // Complete even if there was an error
                                return
                            }
                            
                            guard let resourceDocs = snapshot?.documents else {
                                print("No associated learning resources found for skill: \(skillId)")
                                completion() // Complete even if no resources are found
                                return
                            }
                            
                            let deleteGroup = DispatchGroup()
                            
                            // Delete each associated learning resource document
                            for resourceDoc in resourceDocs {
                                deleteGroup.enter()
                                resourceDoc.reference.delete { error in
                                    if let error = error {
                                        print("Error deleting learning resource: \(error)")
                                    } else {
                                        print("Learning resource deleted successfully: \(resourceDoc.reference.path)")
                                    }
                                    deleteGroup.leave()
                                }
                            }
                            
                            // Wait for all resource deletions to complete
                            deleteGroup.notify(queue: .main) {
                                completion()
                            }
                        }
                }
            }
    }

    
    }
    

