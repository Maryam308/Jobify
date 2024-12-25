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
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 0
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
    
    // function to fetch the user reference
    func fetchSelectedCv(by userId: Int, completion: @escaping (DocumentReference?) -> Void) {
        // Ensure selectedCV is valid
        guard let cvID = selectedCV?.cvID else {
            print("Selected CV is nil or invalid.")
            completion(nil)
            return
        }
        
        db.collection("MaryamForTesting")
            .whereField("cvID", isEqualTo: cvID) // Use the cvID from the selected CV
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching CV document: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No CV document found for cvID: \(cvID)")
                    completion(nil)
                    return
                }
                
                // Return the reference to the found CV document
                completion(document.reference)
            }
    }
    
    
    // Function to display an error alert
    func showAlert(title: String ,message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func sendApplication(_ sender: UIButton) {
        // Validate inputs
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
        
        // Fetch the CV reference using cvID
        fetchSelectedCv(by: currentUserId) { [weak self] cvRef in
            guard let self = self else { return }
            
            guard let cvRef = cvRef else {
                self.showAlert(title: "Invalid", message: "Failed to fetch CV reference.")
                return
            }
            
            fetchUserReference(by: currentUserId) { userRef in
                guard let userRef = userRef else {
                    self.showAlert( title: "Invalid" ,message: "Failed to fetch user reference.")
                    return
                }
                
                // Prepare data to be added to Firestore
                let applicationData: [String: Any] = [
                    "contribution": contribution,
                    "cvRef": cvRef, // Reference to the selected CV
                    "userRef": userRef.path, // Reference to the user
                    "date": Date(),
                    "id": 1, // Replace with a dynamically generated ID if needed
                    "introduction": introduction,
                    "jobPostRef": "/jobPost/id", // Replace with the actual job post reference
                    "motivation": motivation,
                    "status": "Not Reviewed" // Initial status
                ]
                
                // Add the application to Firestore
                self.db.collection("jobApplication").addDocument(data: applicationData) { error in
                    if let error = error {
                        print("Error adding application: \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: "Failed to submit application.")
                    } else {
                        self.showAlert(title: "Successful", message: "Application submitted successfully.")
                    }
                }
                
            }
            
            
            
        }
    }
}
