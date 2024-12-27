//
//  MyLearningResources.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit
import FirebaseFirestore

class MyLearningResourcesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MyLearningResourcesCellDelegate  {
    
    let db = Firestore.firestore()
    //fetch the singleton user session user
    let currentUserId = currentLoggedInUserID
    
    // an  array to fetch the users' learning resources
    var learningResources: [LearningResource] = []
    
    // the number of items to be displayed using the cells in the collection view
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return   learningResources.count //placeholder length
            
        }

    
    //what to do in each cell : display title of each learning resources added
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            //fetch the cell to reuse
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyLearningResourceCell", for: indexPath) as! MyLearningResourcesCells
            
            //set the title label to the learning resource title
            cell.lblResourceTitle.text = learningResources[indexPath.item].title
            cell.delegate = self // Set the delegate

            //return the ready cell
            return cell
            
        }

    
        // what will happen after the user select it
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // for testing purposes
            print("Selected \(learningResources[indexPath.item].learningResourceId)")
            
        }
    
    
    func fetchUserReference(by userId: Int, completion: @escaping (DocumentReference?) -> Void) {
        
        // this function will fetch to the user reference in the database using the user ID of the current user passed in the parameter
        
            db.collection("users")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        // error handling
                        print("Error fetching user document: \(error)")
                        completion(nil)
                        return
                    }

                    guard let document = snapshot?.documents.first else {
                        print("No user document found for userId: \(userId)")
                        completion(nil)
                        return
                    }

                    // after completion the the function will  return the reference to the found user document
                    completion(document.reference)
                }
        }

    
    
    
    func fetchFilteredLearningResources(using publisherRef: DocumentReference) {
        
        // this function will filter the learning resources in the collection by comparing the publisher reference to the current user reference
        
           db.collection("LearningResources")
               .whereField("publisher", isEqualTo: publisherRef)
               .getDocuments { snapshot, error in
                   if let error = error {// error handling and testing
                       print("Error fetching learning resources: \(error)")
                       return
                   }
                   
                   guard let snapshot = snapshot else {
                       print("No learning resources found.")
                       return
                   }
                   
                   // use compact map to map the document data
                   self.learningResources = snapshot.documents.compactMap { document in
                       let data = document.data()
                       // since the learning resource  is already created the ID will be fetched
                       let learningResourceId = data["learningResourceId"] as? Int ?? 0
                       let title = data["title"] as? String ?? ""

                       // start that needed data only which are the ID and the title
                       var learningResource = LearningResource()
                       learningResource.title = title
                       learningResource.learningResourceId = learningResourceId

                       
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

  
    // Implement the delegate method
        func didTapRemoveButton(in cell: MyLearningResourcesCells) {
            guard let indexPath = myLearningResourcesCollection.indexPath(for: cell) else { return }
            let selectedResourceId = learningResources[indexPath.item].learningResourceId
            
            // Show confirmation alert
            let alertController = UIAlertController(
                title: "Delete Learning Resource",
                message: "Are you sure you want to delete this learning resource?",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Perform the deletion logic
                let resourcesCollection = Firestore.firestore().collection("LearningResources")
                resourcesCollection.whereField("learningResourceId", isEqualTo: selectedResourceId)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching document: \(error.localizedDescription)")
                            return
                        }
                        guard let documents = snapshot?.documents, let document = documents.first else {
                            print("No matching document found for learningResourceId \(selectedResourceId)")
                            return
                        }
                        
                        document.reference.delete { error in
                            if let error = error {
                                print("Error deleting document: \(error.localizedDescription)")
                            } else {
                                print("Document deleted successfully.")
                                // Remove the resource from the local array and update the collection view
                                self.learningResources.remove(at: indexPath.item)
                                DispatchQueue.main.async {
                                    self.myLearningResourcesCollection.deleteItems(at: [indexPath])
                                }
                            }
                        }
                    }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    
    
}



