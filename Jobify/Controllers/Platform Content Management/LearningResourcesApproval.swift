//
//  LearningResourcesApproval.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//
import Firebase
import UIKit

class LearningResourcesApprovalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    //fetched requests
    var requests: [LearningRequest] = []
    
    @IBOutlet weak var LRrequestsCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        requests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fetch the cell to reuse using the specified one from the in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LRrequestCell", for: indexPath) as! LRRequestCollectionCell
        
        //set the title label to the learning resource title
        cell.btnTitle.setTitle(requests[indexPath.item].title, for: .normal)
        
        //add target to the edit button
        
        
        
        
        
        
        //add status to the status label
        
        if let reviewed =  requests[indexPath.item].isApproved{
            
            //if there is a value in then it is either approved or not
            if(reviewed){
                cell.lblRequestState.text = "Approved"
            }else {
                cell.lblRequestState.text = "Rejected"
            }
            
        }else{
            //if it is null then the status is pending
            cell.lblRequestState.text = "Pending"
            
        }
        
        
           
        //return the ready cell
        return cell

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LRrequestsCollection.delegate = self
        LRrequestsCollection.dataSource = self
                
        // Fetch the requests
        fetchLearningResourcesRequests()
        
    }
    
    func fetchLearningResourcesRequests() {
            
            db.collection("LearningResourcesRequests")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching requests: \(error)")
                        return
                    }
                    
                    guard let snapshot = snapshot else { return }
                    
                    self.requests = snapshot.documents.compactMap { document in
                        let data = document.data()
                        
                        let title = data["title"] as? String ?? "Untitled"
                        let state = data["isApproved"] as? Bool ?? nil
                        
                        return LearningRequest(title: title, isApproved: state)
                    }
                    
                    // Reload the collection view with the fetched data
                    DispatchQueue.main.async {
                        self.LRrequestsCollection.reloadData()
                    }
                }
        }
    
    
    
}
