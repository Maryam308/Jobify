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
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var showProfileLabel: UILabel!
    
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    var application: JobApplication?
    //var currentUserId: Int?
    //var currentUserRole: String?
    var cvs: [CV] = []
    
    @IBOutlet weak var introductionTextView: UITextView!
    
    @IBOutlet weak var motivationTextView: UITextView!
    
    @IBOutlet weak var contributionTextView: UITextView!
    
    @IBOutlet weak var viewCVButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    /*
     func fetchSelectedCv(by cvID: String, completion: @escaping (CV?) -> Void) {
     // Assume this function fetches the CV from Firestore
     let db = Firestore.firestore()
     let docRef = db.collection("seekerDetails").document("userID").collection("CVs").document(cvID)
     
     docRef.getDocument { (document, error) in
     if let error = error {
     print("Error fetching CV: \(error.localizedDescription)")
     completion(nil)
     return
     }
     
     guard let document = document, document.exists, let data = document.data() else {
     completion(nil)
     return
     }
     
     // Assuming you have a CV initializer that accepts a dictionary
     //let cv = CV(dictionary: data)
     //completion(cv)
     }
     }
     */
    /*
     func fetchSelectedCv(by cvID: String, completion: @escaping (CV?) -> Void) {
     
     let db = Firestore.firestore()
     let docRef = db.collection("seekerDetails").document(currentUserId).collection("CVs").document(cvID)
     
     docRef.getDocument { (document, error) in
     if let error = error {
     print("Error fetching CV: \(error.localizedDescription)")
     completion(nil)
     return
     }
     
     guard let document = document, document.exists, let data = document.data() else {
     print("CV document does not exist or has no data.")
     completion(nil)
     return
     }
     
     // Assuming you have a CV initializer that accepts a dictionary
     let cv = CV(dictionary: data) // Make sure your CV model has a proper initializer
     completion(cv)
     }
     }
     */
    @IBAction func ViewCVButtonClicked(_ sender: UIButton) {
        /*
         // Ensure you have a valid applicant CV ID
         guard let cvId = application?.applicantCVId, !cvId.isEmpty else {
         print("No CV ID found.")
         return
         }
         
         // Fetch CVs asynchronously
         Task {
         do {
         let fetchedCVs = try await CVManager.getUserAllCVs()
         
         // Find the CV with the matching ID
         if let matchingCV = fetchedCVs.first(where: { $0.cvID == cvId }) {
         // Load the storyboard
         let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
         
         // Instantiate the CVViewerViewController
         if let cvViewerVC = storyboard.instantiateViewController(withIdentifier: "cvViewer") as? CVViewerViewController {
         cvViewerVC.cv = matchingCV // Assuming `cv` is the property in CVViewerViewController to hold the CV data
         navigationController?.pushViewController(cvViewerVC, animated: true)
         }
         } else {
         print("No CV found with ID: \(cvId)")
         }
         } catch {
         print("Error fetching CVs: \(error.localizedDescription)")
         }
         }
         */
        // Ensure you have a valid applicant CV ID
        guard let cvId = application?.applicantCVId, !cvId.isEmpty else {
            print("No CV ID found.")
            return
        }
        
        // Fetch all CVs asynchronously
        Task {
            do {
                let fetchedCVs = try await CVManager.getUserAllCVs()
                
                // Find the CV with the matching ID
                if let matchingCV = fetchedCVs.first(where: { $0.cvID == cvId }) {
                    // Load the storyboard
                    let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
                    
                    // Instantiate the CVViewerViewController
                    if let cvViewerVC = storyboard.instantiateViewController(withIdentifier: "cvViewer") as? CVViewerViewController {
                        cvViewerVC.cv = matchingCV // Assuming `cv` is the property in CVViewerViewController to hold the CV data
                        navigationController?.pushViewController(cvViewerVC, animated: true)
                    }
                } else {
                    print("No CV found with ID: \(cvId)")
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
            tableView.dataSource = self
        
        //currentUserId = currentLoggedInUserID
        //currentUserRole = UserSession.shared.loggedInUser?.role.rawValue
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*
        // Set the underlined text
                let text = "Underlined Text"
                let attributedString = NSMutableAttributedString(string: text)
                
                // Set the underline style
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
                
                // Set the attributed text to the label
        showProfileLabel.attributedText = attributedString
        currentStatusLabel.attributedText = attributedString
        */
        guard let application = application else {
                print("Error: Application is nil!")
                return
            }

        
        if currentUserRole == "seeker" {
            // Populate labels and text fields with the application's data
            companyNameLabel.text = application.jobApplied?.companyDetails?.name
            positionLabel.text = application.jobApplied?.title
            currentStatusLabel.text = application.status.rawValue
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
            
            
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
            currentStatusLabel.text = application.status.rawValue
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
           showProfileLabel.text = "Show seeker profile"
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

    // MARK: - Table view data source


}
