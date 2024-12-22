//
//  MyLearningResources.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import FirebaseFirestore

class MyLearningResourcesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let db = Firestore.firestore()
    //fetch the singleton user session user
    let currentUserId = 1 /*UserSession.shared.loggedInUser?.userID*/
    
    //fetch the users' learning resources
    var learningResources: [LearningResource] = []
    
    // the number of items to be displayed using the cells in the collection view
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return   learningResources.count //placeholder length
            
        }

    
    //what to do in each cell : display title of each learning resources added
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            //fetch the cell to reuse using the specified one from the in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyLearningResourceCell", for: indexPath) as! MyLearningResourcesCells
            
            //set the title label to the learning resource title
            cell.lblResourceTitle.text = learningResources[indexPath.item].title
            
            //add target to the edit button
            cell.btnEdit.addTarget(self, action: #selector(btnEditClick(_:)), for: .touchUpInside)
               
            //return the ready cell
            return cell
            
        }

    
        // what will happen after the user select it
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("Selected \(learningResources[indexPath.item].learningResourceId)")
            
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

    
    
    
    func fetchFilteredLearningResources(using publisherRef: DocumentReference) {
        db.collection("LearningResources")
            .whereField("publisher", isEqualTo: publisherRef)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching learning resources: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No learning resources found.")
                    return
                }
                
                // Map each document's data into LearningResource structs
                self.learningResources = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let learningResourceId = data["learningResourceId"] as? Int ?? 0
                    let title = data["title"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let datePublished = data["datePublished"] as? Date ?? Date()
                    let skill = data["skill"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let link = data["link"] as? String ?? ""
                    
                    var learningResource = LearningResource()
                    learningResource.title = title
                    learningResource.learningResourceId = learningResourceId
                    learningResource.skillToDevelop = skill
                    learningResource.datePublished = datePublished
                    learningResource.link = link
                    learningResource.summary = description
                    learningResource.type = category
                    
                    return learningResource
                }
                
                // Reload the collection view on the main thread
                DispatchQueue.main.async {
                    self.myLearningResourcesCollection.reloadData()
                }
            }
    


    
    }
    
    
    @IBOutlet weak var myLearningResourcesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLearningResourcesCollection.delegate = self
        myLearningResourcesCollection.dataSource = self
        //call the fetching to fetch the user (publisher) refrence that will call after the method to fetch the learning resources documets
        fetchUserReference(by: currentUserId) { userRef in
                    if let userRef = userRef {
                        print("Successfully fetched user reference: \(userRef.path)")
                        self.fetchFilteredLearningResources(using: userRef)
                    } else {
                        print("Failed to fetch user reference.")
                    }
                }
            
        }

    
    
    @IBAction func btnEditClick(_ sender: Any) {
    
        // Find the index path of the cell where the button was tapped
        if let cell = (sender as AnyObject).superview as? UICollectionViewCell,
           let indexPath = myLearningResourcesCollection.indexPath(for: cell) {
            let selectedTitle = learningResources[indexPath.item].type
                   // Perform segue to the next screen and pass the title
                   performSegue(withIdentifier: "showDetail", sender: selectedTitle)
               }
        
        
            }
    
    
}



