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
            self.RemoveSkill(skillId: skillId) // Call your remove function here
        }
        
        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add actions to the action sheet
        actionSheet.addAction(editAction)
        actionSheet.addAction(removeAction)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        present(actionSheet, animated: true)
        
    }
    
    
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
    
    
    //a function to remove the skill and all its related learning resources
    func RemoveSkill(skillId: Int){
        
        //will navigate to an edit screen passing the skill title along
        
        let skillsCollection = db.collection("skills")
            let learningResourcesCollection = db.collection("LearningResources")
            
            // Step 1: Find the skill document by title
            skillsCollection
                .whereField("skillId", isEqualTo: skillId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching skill document: \(error)")
                        return
                    }
                    
                    guard let skillDoc = snapshot?.documents.first else {
                        print("No skill document found for title: \(skillId)")
                        return
                    }
                    
                    let skillDocRef = skillDoc.reference
                    
                    // Step 2: Delete the skill document
                    skillDocRef.delete { error in
                        if let error = error {
                            print("Error deleting skill document: \(error)")
                            return
                        }
                        
                        print("Skill document deleted successfully: \(skillDocRef.path)")
                        
                        // Step 3: Delete associated learning resources
                        learningResourcesCollection
                            .whereField("skill", isEqualTo: skillDocRef)
                            .getDocuments { snapshot, error in
                                if let error = error {
                                    print("Error fetching learning resources: \(error)")
                                    return
                                }
                                
                                guard let resourceDocs = snapshot?.documents else {
                                    print("No associated learning resources found for skill: \(skillId)")
                                    return
                                }
                                
                                // Delete each associated learning resource document
                                for resourceDoc in resourceDocs {
                                    resourceDoc.reference.delete { error in
                                        if let error = error {
                                            print("Error deleting learning resource: \(error)")
                                        } else {
                                            print("Learning resource deleted successfully: \(resourceDoc.reference.path)")
                                            self.skillsCollection.reloadData()
                                        }
                        
                                    }
                                }
                            }
                    }
                }
        
        
    }
    
    
    }
    

