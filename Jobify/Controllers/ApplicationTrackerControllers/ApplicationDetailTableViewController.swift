//
//  ApplicationDetailTableViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 27/12/2024.
//

import UIKit
import Firebase
import FirebaseFirestore



class ApplicationDetailTableViewController: UITableViewController {
    var currentUserId: Int = currentLoggedInUserID
    var onStatusUpdated: ((JobApplication) -> Void)?
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    
    
    var application: JobApplication?
    var appli:JobApplication = JobApplication() // Variable of type JobApplication incase there is no JobApplication parameter
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var currentStatusButton: UIButton!
    var cvs: [CV] = []
    
    // MARK: Profile Segue Function
    
    @IBAction func profileTapped(_ sender: UIButton) {
        
        if currentUserRole == "seeker" {
            let storyboard = UIStoryboard(name: "UserProfileAndSettings_ZainabAlawi", bundle: nil)
            
            if let employerProfileVC = storyboard.instantiateViewController(identifier: "CompanyProfileViewController") as? CompanyProfileViewController2 {
                
                navigationController?.pushViewController(employerProfileVC, animated: true)
                
            }
            
        } else if currentUserRole == "employer" || currentUserRole == "admin" {
            let storyboard = UIStoryboard(name: "UserProfileAndSettings_ZainabAlawi", bundle: nil)
            
            if let seekerProfileVC = storyboard.instantiateViewController(identifier: "SeekerProfileViewController") as? SeekerProfileViewControllerWithCV {
                
                navigationController?.pushViewController(seekerProfileVC, animated: true)
                
            }
        
        }
      
    }
    @IBOutlet weak var introductionTextView: UITextView!
    
    // MARK: Change application status
    @IBAction func currentStatusTapped(_ sender: UIButton) {
        if currentUserRole == "employer" || currentUserRole == "admin" {
            presentChangeStatusActionSheet(for: application ?? appli)
            
            self.tableView.reloadData()
        }
       
    }
    
    private func presentChangeStatusActionSheet(for application: JobApplication) {
            let currentStatus = application.status // Get current status
            
            print("Current status: \(application.status.rawValue)")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let options = UIAlertController(title: "Change Status", message: nil, preferredStyle: .actionSheet)

            // Helper function to add an action
            func addAction(title: String, newStatus: JobApplication.ApplicationStatus) {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    // Call the updateApplicationStatus method with the application object
                    self.updateApplicationStatus(application: application, newStatus: newStatus)
                }
                options.addAction(action)
            }

            // Add options based on the current status
            switch currentStatus {
            case .notReviewed:
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Rejected", newStatus: .rejected)
                addAction(title: "Approved", newStatus: .approved)
            case .reviewed:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Rejected", newStatus: .rejected)
                addAction(title: "Approved", newStatus: .approved)
            case .approved:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Rejected", newStatus: .rejected)
            case .rejected:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Approved", newStatus: .approved)
            }

            options.addAction(cancelAction)
            
            // Present the action sheet
            present(options, animated: true, completion: nil)
        }
        
        private func updateApplicationStatus(application: JobApplication, newStatus: JobApplication.ApplicationStatus) {
            // Update the status in Firestore for the application object
            db.collection("jobApplication")
                .whereField("applicationId", isEqualTo: application.applicationId) // Assume applicationId is Int
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        print("No documents found with applicationId: \(application.applicationId)")
                        return
                    }
                    
                    // Update the status in the found document
                    for document in documents {
                        document.reference.updateData(["status": newStatus.rawValue]) { error in
                            if let error = error {
                                print("Error updating status: \(error.localizedDescription)")
                            } else {
                                var updatedApplication = application  // Create a mutable copy
                                updatedApplication.status = newStatus  // Update the status
                                
                                self.currentStatusButton.setTitle(updatedApplication.status.rawValue, for: .normal)
                                
                                self.application?.status = updatedApplication.status
                               
                                
                                self.onStatusUpdated?(updatedApplication)
                                
                            }
                        }
                    
                    }
                }
        }
    
    @IBOutlet weak var motivationTextView: UITextView!
    
    @IBOutlet weak var contributionTextView: UITextView!
    
    @IBOutlet weak var viewCVButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    
    // MARK: View CV
    
    @IBAction func ViewCVButtonClicked(_ sender: UIButton) {
       
        if let matchingCV = findCV(by: application?.applicantCVId ?? "") {
               let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
               if let cvViewerVC = storyboard.instantiateViewController(withIdentifier: "cvViewer") as? CVViewerViewController {
                   cvViewerVC.cv = matchingCV
                   navigationController?.pushViewController(cvViewerVC, animated: true)
               }
           } else {
               print("No CV found with ID: \(application?.applicantCVId ?? "unknown ID")")
           }
 
    }
    
    func fetchCVs() {
        // Create a test CV asynchronously
        Task {
            do {
                let fetchedCVs = try await CVManager.getUserAllCVs()
                DispatchQueue.main.async {
                    self.cvs = fetchedCVs
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    }
    
    func findCV(by cvID: String) -> CV? {
        // Loop through the array of CVs to find a match
        for cv in cvs {
            if cv.cvID == cvID {
                return cv // Return the matching CV
            }
        }
        return nil // Return nil if no match is found
    }
    
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
            tableView.dataSource = self
        fetchCVs()
        
        
        guard let application = application else {
                print("Error: Application is nil!")
                return
            }

        
        if currentUserRole == "seeker" {
            // Populate labels and text fields with the application's data
            companyNameLabel.text = application.jobApplied?.companyDetails?.name
            positionLabel.text = application.jobApplied?.title
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
            
            currentStatusButton.setTitle(application.status.rawValue, for: .normal)
            profileButton.setTitle("Show employer profile", for: .normal)
            
            // Load profile picture
            if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
                let imageURL = URL(string: imageURLString) {
                loadImage(from: imageURL, into: profileImage)
            } else {
                // Use a system-provided placeholder image
                profileImage.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
                
                // Set clipsToBounds to false when no image is present
                profileImage.layer.cornerRadius = 0 // Reset corner radius
                profileImage.clipsToBounds = false // Disable clipping
            }
       } else if currentUserRole == "employer" || currentUserRole == "admin" {
           
           fetchUserInfo(application: application) { name in
                       DispatchQueue.main.async {
                           self.companyNameLabel.text = name ?? "Unknown Seeker"
                       }
                   }
           // Load profile picture
           if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
               let imageURL = URL(string: imageURLString) {
               loadImage(from: imageURL, into: profileImage)
           } else {
               // Use a system-provided placeholder image
               profileImage.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
               
               // Set clipsToBounds to false when no image is present
               profileImage.layer.cornerRadius = 0 // Reset corner radius
               profileImage.clipsToBounds = false // Disable clipping
           }
           
           positionLabel.text = application.jobApplied?.title
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
           currentStatusButton.setTitle(application.status.rawValue, for: .normal)
           profileButton.setTitle("Show seeker profile", for: .normal)
        }
            
        
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   return // Do not set a fallback image for extra attachment
               }
               DispatchQueue.main.async {
                   imageView.image = UIImage(data: data)
               }
           }
           task.resume()
       }
    
    // MARK: Fetch applicant Information
    // To fetch the name of the current user for the application
    func fetchUserInfo(application: JobApplication, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        // Query to find the document with the specific userId
        db.collection("users").whereField("userId", isEqualTo: application.applicantId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No user found with the given user ID.")
                completion(nil)
                return
            }
            
            // Assuming there's only one document per userId
            for document in documents {
                let userData = document.data()
                print("User data: \(userData)")
                
                // Access specific information
                let name = userData["name"] as? String
                completion(name)
            }
        }
    }

  


}
