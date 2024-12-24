//
//  ReviewLearningRequest.swift
//  Jobify
//
//  Created by Maryam Ahmed on 24/12/2024.
//
import Firebase
import UIKit

class ReviewLearningRequestViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var toReviewRequestId: Int = 0
    
    //all outlets
    
    @IBOutlet weak var lblPublisherName: UILabel!
    
    @IBOutlet weak var lblPublishingDate: UILabel!
    
    
    @IBOutlet weak var txtResourceTitle: UITextField!
    
    
    @IBOutlet weak var txtSkill: UITextField!
    
    
    
    @IBOutlet weak var txtResourceCategory: UITextField!
    
    
    @IBOutlet weak var txtDescription: UITextView!
    
    
    
    @IBOutlet weak var txtLink: UITextField!
    
    
    
    @IBOutlet weak var btnApprove: UIButton!
    
    
    
    @IBOutlet weak var btnReject: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //finalize the design and add rounded corners to the buttons and borders for the text view
        btnReject.layer.cornerRadius = 10
        btnApprove.layer.cornerRadius = 10
        
        txtDescription.layer.cornerRadius = 10
        txtDescription.layer.borderWidth = 1
        txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        
        //fetch the publisher using the publisher id
        
        print("Request ID to review: \(toReviewRequestId)")  // Log to check
            fetchRequestAndPublisherData()
        
    }
    
    private func fetchRequestAndPublisherData() {
        
        print("Request ID to review: \(toReviewRequestId)")  // Log to check

        // fetch the request document
        db.collection("LearningResourcesRequests")
            .whereField("requestId", isEqualTo: toReviewRequestId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching request data: \(error.localizedDescription)")
                    return
                }
                //check if there is a request fetched
                guard let documents = snapshot?.documents, let document = documents.first else {
                    print("No request found for requestId \(self.toReviewRequestId)")
                    return
                }
                
                // if the request exist start extracting data
                let data = document.data()
                let resourceTitle = data["title"] as? String ?? "No Title"
                let category = data["category"] as? String ?? "No Category"
                let skillRef = data["skill"] as? DocumentReference
                let description = data["description"] as? String ?? "No Description"
                let link = data["link"] as? String ?? "No Link"
                let publishingDate = data["publishingDate"] as? Timestamp ?? Timestamp()
                let publisherRef = data["publisher"] as? DocumentReference
                
                // asychronansly add the data to the fields
                DispatchQueue.main.async {
                    self.txtResourceTitle.text = resourceTitle
                    self.txtResourceCategory.text = category
                    self.txtDescription.text = description
                    self.txtLink.text = link
                    self.lblPublishingDate.text = "Submitted On: " +  DateFormatter.localizedString(from: publishingDate.dateValue(), dateStyle: .medium, timeStyle: .none)
                }
                
                // Step 2: Fetch the skill's title
                if let skillRef = skillRef {
                    self.fetchSkillTitle(skillRef: skillRef)
                } else {
                    print("Skill reference not found")
                }
                
                
                
                //start fetching the publisher by passing the refrence to the functioin fetch publisher data
                if let publisherRef = publisherRef {
                    self.fetchPublisherData(publisherRef: publisherRef)
                } else {
                    print("Publisher reference not found")
                }
            }
    }
    
    
    
    
    private func fetchPublisherData(publisherRef: DocumentReference) {
        publisherRef.getDocument { document, error in
            if let error = error {
                print("Error fetching publisher data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("No data found for publisher")
                return
            }
            
            // Extract the publisher data
            let name = data["name"] as? String ?? "Unknown"
            let email = data["email"] as? String ?? "No Email"
            let id = data["userId"] as? String ?? "No ID"
            
            // Update the UI with publisher data
            DispatchQueue.main.async {
                self.lblPublisherName.text = "Submitted By: " +  name
                
                //struct a user to send the review message after the review
                
                
                
                
                
                
                
                
                
                
                
                print("Publisher Data - Name: \(name), Email: \(email), ID: \(id)")
            }
        }
    }
    
    
    private func fetchSkillTitle(skillRef: DocumentReference) {
        skillRef.getDocument { document, error in
            if let error = error {
                print("Error fetching skill data: \(error.localizedDescription)")
                return
            }
            //if the data is not found stop the excuting
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("No data found for skill")
                return
            }
            
            // fetc the skill title field from the skill document
            let skillTitle = data["title"] as? String ?? "Unknown Skill"
            
            // Update the UI with skill title
            DispatchQueue.main.async {
                self.txtSkill.text = skillTitle
            }
        }
        
    }
    
    
    @IBAction func btnApproveClicked(_ sender: Any) {
        
        // Confirm approval with an alert
            let alertController = UIAlertController(title: "Approve Request", message: "Are you sure you want to approve this request?", preferredStyle: .alert)
            
            // Add "Approve" action
            let approveAction = UIAlertAction(title: "Approve", style: .default) { _ in
                // Call the update function with isApproved = true
                self.updateRequestStatus(isApproved: true)
            }
            
            // Add "Cancel" action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(approveAction)
            alertController.addAction(cancelAction)
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnRejectClicked(_ sender: Any) {
        
        // Confirm rejection with an alert
            let alertController = UIAlertController(title: "Reject Request", message: "Are you sure you want to reject this request?", preferredStyle: .alert)
            
            // Add "Reject" action
            let rejectAction = UIAlertAction(title: "Reject", style: .destructive) { _ in
                // Call the update function with isApproved = false
                self.updateRequestStatus(isApproved: false)
            }
            
            // Add "Cancel" action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(rejectAction)
            alertController.addAction(cancelAction)
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
        
    }
    
    
    private func updateRequestStatus(isApproved: Bool) {
        
        
        let requestsCollection = db.collection("LearningResourcesRequests")
        let resourcesCollection = db.collection("LearningResources")
        
        // fetching the request document the request document
        requestsCollection.whereField("requestId", isEqualTo: toReviewRequestId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching request: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, let requestDoc = documents.first else {
                    print("No request found for ID \(self.toReviewRequestId)")
                    return
                }
                
                let requestData = requestDoc.data()
                let requestDocRef = requestDoc.reference
                
                // Step 2: Update the `isApproved` status in the request document
                requestDocRef.updateData(["isApproved": isApproved]) { error in
                    if let error = error {
                        print("Error updating request: \(error.localizedDescription)")
                        return
                    }
                    print("Request updated successfully with isApproved = \(isApproved)")
                }
                
                // if the admiin approve the request will be added as a learning request
                if isApproved {
                    
                    //construct a resorce to generate a new id
                    let newLR = LearningResource()
                    
                    let resourceData: [String: Any] = [
                        "learningResourceId": newLR.learningResourceId ,
                        "title": requestData["title"] ?? "",
                        "category": requestData["category"] ?? "",
                        "description": requestData["description"] ?? "",
                        "link": requestData["link"] ?? "",
                        "datePublished": requestData["publishingDate"] ?? Timestamp(),
                        "publisher": requestData["publisher"] ?? "",
                        "skill": requestData["skill"] ?? ""
                    ]
                    
                    resourcesCollection.addDocument(data: resourceData) { error in
                        if let error = error {
                            print("Error adding learning resource: \(error.localizedDescription)")
                        } else {
                            print("Learning resource added successfully")
                            // Show success alert and navigate back
                            self.showAlert(title: "Success", message: "Learning resource added successfully.", shouldNavigateBack: true)
                        }
                        
                        
                        
                    }//feedback (error or successful)
                    
                    
                    
                }//end of is Approved condition
                else {
                    // If rejected, show rejection alert and navigate back
                    self.showAlert(title: "Rejected", message: "Request has been rejected and not added to learning resources.", shouldNavigateBack: true)
            }
                
                
            }//using the snapshot
        
    }//end of update function
    
    
    
    // Function to show an alert and navigate back upon completion
    private func showAlert(title: String, message: String, shouldNavigateBack: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if shouldNavigateBack {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        // Present the alert on the main thread
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
}
