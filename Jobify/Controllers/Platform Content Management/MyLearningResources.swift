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
    
    var learningResources: [LearningResource] = []
    
    
    // the number of items to be displayed using the cells
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return data.count //placeholder length
            
        }

    
    //what to do in each cell : display title
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyLearningResourceCell", for: indexPath) as! MyLearningResourcesCells
            
            cell.lblResourceTitle.text = data[indexPath.item]
            
            cell.btnEdit.addTarget(self, action: #selector(btnEditClick(_:)), for: .touchUpInside)
                    
            return cell
            
        }

    
        // what will happen after the user select it
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("Selected \(data[indexPath.item])")
            
        }
    
    //placeholder
    let data = ["Item 1", "Item 2", "Item 3"]
    
    @IBOutlet weak var myLearningResourcesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLearningResourcesCollection.delegate = self
        myLearningResourcesCollection.dataSource = self
        
        //fetch into an array learning resources
            
        //take a snapshot of the colection of learningResources
        
        
        
        db.collection("LearningResources").getDocuments{ snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            // Map each document's data into a LearningResource struct
            self.learningResources = snapshot.documents.map { document in
                // Here, you map the data from Firestore into your LearningResource struct
                let data = document.data()
                let learningResourceId = data["learningResourceId"] as? Int ?? 0
                let title = data["title"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let datePublished = data["datePublished"] as? Date ?? Date()
                let skill = data["skill"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let link = data["link"] as? String ?? ""
                
                let publisher = data["publisher"] as? DocumentReference
                
                var learningResourcel =  LearningResource(type: category, summary: description, link: link, skillToDevelop: skill)
                
                
                return learningResourcel
                
            }

            
        }
            
            
            
                        
                        
    }
    
    
    
    
    
    
    @IBAction func btnEditClick(_ sender: Any) {
    
        // Find the index path of the cell where the button was tapped
        if let cell = (sender as AnyObject).superview as? UICollectionViewCell,
           let indexPath = myLearningResourcesCollection.indexPath(for: cell) {
               let selectedTitle = data[indexPath.item]
                   
                   // Perform segue to the next screen and pass the title
                   performSegue(withIdentifier: "showDetail", sender: selectedTitle)
               }
        
        
    }
    
    
    
}



