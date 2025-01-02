//
//  ApplicationTableViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 23/12/2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class ApplicationTableViewController: UITableViewController {
    
    //creates a variable to save the objects passed from different pages
    var selectedCV: CV?
    var job: Job?
    var currentUserId: Int = currentLoggedInUserID
    var seekerDetails: SeekerDetails?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewBorder()
    }
    
    @IBOutlet weak var introductionText: UITextView!
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var contributionText: UITextView!
    
    // create border for the text view
    func createViewBorder() {
        introductionText.layer.borderColor = UIColor.gray.cgColor
        introductionText.layer.borderWidth = 1.0
        introductionText.clipsToBounds = true
        
        motivationText.layer.borderColor = UIColor.gray.cgColor
        motivationText.layer.borderWidth = 1.0
        motivationText.clipsToBounds = true
        
        contributionText.layer.borderColor = UIColor.gray.cgColor
        contributionText.layer.borderWidth = 1.0
        contributionText.clipsToBounds = true
    }
    
    
    @IBOutlet weak var attachmentLabel: UILabel!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChooseCV",
           let navController = segue.destination as? UINavigationController,
           let destinationVC = navController.topViewController as? ChooseCVTableViewController {
            // Pass the closure to handle the selected CV
            destinationVC.onCVSelected = { [weak self] selectedCV in
                self?.selectedCV = selectedCV
                self?.attachmentLabel.text = "Chosen CV: " + selectedCV.cvTitle
            }
        }
        
    }
    
    // function to fetch the user reference
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
    
    // function to fetch the cv reference
    func fetchSelectedCv(by cvID: String, completion: @escaping (String?) -> Void) {
        let seekerDetailsCollectionRef = Firestore.firestore().collection("seekerDetails")
        
        seekerDetailsCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching seekerDetails documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check each document
            for document in snapshot?.documents ?? [] {
                if let seekerCVs = document.data()["seekerCVs"] as? [[String: Any]] {
                    // Iterate through each CV map in the seekerCVs array
                    for cv in seekerCVs {
                        if let id = cv["cvID"] as? String, id == cvID {
                            // Found the CV with the matching cvID
                            completion(cv["cvID"] as? String) // Return the CV ID or other desired data
                            return
                        }
                    }
                }
            }
            
            // If no matching CV is found
            print("No CV document found for cvID: \(cvID)")
            completion(nil)
        }
    }
    
   
    // Function to display an error alert
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Add an "OK" button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Execute the completion handler if it exists
        }
        alertController.addAction(okAction)

        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendApplication(_ sender: UIButton) {
        // Validate inputs
        let jobID = job?.jobId
        guard let introduction = introductionText.text?.trimmingCharacters(in: .whitespacesAndNewlines), !introduction.isEmpty else {
            showAlert(title: "Invalid", message: "Please enter a valid introduction.")
            return
        }
        
        guard let motivation = motivationText.text?.trimmingCharacters(in: .whitespacesAndNewlines), !motivation.isEmpty else {
            showAlert(title: "Invalid", message: "Please enter a valid motivation statement.")
            return
        }
        
        guard let contribution = contributionText.text?.trimmingCharacters(in: .whitespacesAndNewlines), !contribution.isEmpty else {
            showAlert(title: "Invalid", message: "Please enter a valid contribution statement.")
            return
        }
        
        // Ensure selectedCV is available
        guard let selectedCV = selectedCV else {
            showAlert(title: "Invalid", message: "No CV selected.")
            return
        }
        
        // Fetch the CV using cvID
        fetchSelectedCv(by: selectedCV.cvID) { [weak self] cvID in
            guard let self = self else { return }
            
            guard let cvID = cvID else {
                self.showAlert(title: "Invalid", message: "Failed to fetch CV ID.")
                return
            }
            
            // Fetch user reference
            fetchUserReference(by: currentUserId) { userRef in
                guard let userRef = userRef else {
                    self.showAlert(title: "Invalid", message: "Failed to fetch user reference.")
                    return
                }

                
                JobApplication.fetchAndSetID {
                            let applicationId = JobApplication.getNextID()
                    
                    // Prepare data to be added to Firestore
                    let applicationData: [String: Any] = [
                        "contribution": contribution,
                        "cvID": cvID,
                        "userRef": userRef.path, // Reference to the user
                        "date": Date(),
                        "introduction": introduction,
                        "applicationId": applicationId,
                        "jobId": jobID ?? 0,
                        "motivation": motivation,
                        "status": "Not Reviewed" // Initial status
                    ]
                    
                    // Add the application to Firestore
                    self.db.collection("jobApplication").addDocument(data: applicationData) { error in
                        if let error = error {
                            print("Error adding application: \(error.localizedDescription)")
                            self.showAlert(title: "Error", message: "Failed to submit application.")
                        } else {
                            self.showAlert(title: "Successful", message: "Application submitted successfully."){
                                let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil) // Use your storyboard name
                                let homeVC = storyboard.instantiateViewController(withIdentifier: "homePageVC") // Use your view controller ID
                                
                                // Present or push the home view controller
                                self.navigationController?.pushViewController(homeVC, animated: true)}
                        }
                    }
                }
            }
        }
        
    }
    
    
}
