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
        
        
        //add status to the status label
        
        if let reviewed = requests[indexPath.item].isApproved {
            if reviewed {
                //if reviewed = true then the request if approved
                cell.lblRequestState.text = "Approved"
                cell.lblRequestState.textColor = UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0) // Dark Green
            } else {
                //if the reviewed has fetched false then its rejected
                cell.lblRequestState.text = "Rejected"
                cell.lblRequestState.textColor = UIColor(red: 0.55, green: 0.0, blue: 0.0, alpha: 1.0) // Dark Red
            }
        } else {
            //if reviewd is not assign = isApproved is null
            //means the request is still pending
            cell.lblRequestState.text = "Pending"
            cell.lblRequestState.textColor = UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1.0) // Dark Gray
        }
        
        
           
        //return the ready cell
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRequest = requests[indexPath.item]
        
        // Check if the request is not pending (either approved or rejected)
            if let reviewed = selectedRequest.isApproved {
                // If the request is not pending (approved or rejected), do nothing
                // Just return from the function to prevent navigation
                return
            }
            
        
           // Set the requestId to the destination view controller
           if let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewLearningRequest") as? ReviewLearningRequestViewController {
               reviewVC.toReviewRequestId = selectedRequest.requestId
               
               // Navigate to the new view controller
               navigationController?.pushViewController(reviewVC, animated: true)
           }
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
                        let id = data["requestId"] as? Int ?? 0
                        let title = data["title"] as? String ?? "Untitled"
                        let state = data["isApproved"] as? Bool ?? nil
                        
                        return LearningRequest(requestId: id , title: title, isApproved: state)
                    }
                    
                    // Reload the collection view with the fetched data
                    DispatchQueue.main.async {
                        self.LRrequestsCollection.reloadData()
                    }
                }
        }
    
    
    
}
