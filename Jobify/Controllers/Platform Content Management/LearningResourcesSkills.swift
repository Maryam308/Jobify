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
        
        //set the title button to the skill title
        cell.btnSkillTitle.setTitle(skills[indexPath.item].title, for: .normal )
        
        //return the ready cell
        return cell
    }
    
    @IBOutlet weak var skillsCollection: UICollectionView!
    
    var skills: [Skill] = []
    
    //skill needs a title and a description
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillsCollection.delegate = self
        skillsCollection.dataSource = self
        
        fetchSkills()
        
    }
    
    //fetch all the skill titles and add them to the skill array
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
                    
                    let title = data["title"] as? String ?? "Untitled"
                    let description = data["description"] as? String ?? "No description"
                    
                    return Skill(title: title, description: description)
                }
                
                // Reload the collection view after fetching the data
                DispatchQueue.main.async {
                    self.skillsCollection.reloadData()
                }
            }
    }
    
    
    
}
