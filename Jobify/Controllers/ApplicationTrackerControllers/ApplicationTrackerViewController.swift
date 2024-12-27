//
//  ApplicationTrackerViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore


let db = Firestore.firestore()



class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 3
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
    private var dispatchGroup = DispatchGroup()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allApplications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorCell
        //let application = applications[indexPath.row]
        //cell.seekerLabel.text = application.seeker
        //cell.positionLabel.text = application.position
        //cell.currentStatusLabel.text = application.status
        //return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        let application = allApplications[indexPath.row]
        
        print("Application at index \(indexPath.row): \(application)")
        print("Job Title: \(application.jobApplied?.title ?? "No Title")")
        print("Company Name: \(application.jobApplied?.companyDetails?.name ?? "No Company")")
        print("Location: \(application.jobApplied?.companyDetails?.city ?? "No Location")")
        // Retrieve job type or ID from jobs dictionary or a similar source
         
        cell.companyLabel.text = application.jobApplied?.companyDetails?.name ?? "No Name"
        cell.typeLabel.text = application.jobApplied?.employmentType.rawValue ?? "No Type"
        
        print("jobs: \(jobs)")
        cell.positionLabel.text = application.jobApplied?.title ?? "No Title"
        cell.locationLabel.text = application.jobApplied?.companyDetails?.city ?? "No location"
        
        
        cell.statusButton.setTitle(application.status.rawValue, for: .normal)
        // Set the button background color based on status
        switch application.status {
        case .notReviewed:
            cell.statusButton.backgroundColor = UIColor.orange
        case .reviewed:
            cell.statusButton.backgroundColor = UIColor.blue
        case .approved:
            cell.statusButton.backgroundColor = UIColor.green
        case .rejected:
            cell.statusButton.backgroundColor = UIColor.red
        }
        
        
        cell.statusButton.setTitleColor(.white, for: .normal) // Set text color to white
        cell.statusButton.layer.cornerRadius = 20            // Make the button rounded
        cell.statusButton.clipsToBounds = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let application = self.allApplications[indexPath.row]
        let currentStatus = application.status // Get current status
        
        let alert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let options = UIAlertController(title: "Change Status", message: nil, preferredStyle: .actionSheet)
        
        // Helper function to add an action
        func addAction(title: String, newStatus: JobApplication.ApplicationStatus) {
            let action = UIAlertAction(title: title, style: .default) { _ in
                self.db.collection("jobApplication")
                    .document("\(application.applicationId)")
                    .updateData(["status": newStatus.rawValue]) // Update Firebase
                // Update local data source
                self.allApplications[indexPath.row].status = newStatus
                // Reload the table view
                DispatchQueue.main.async {
                    self.filterApplications(by: self.currentFilter)
                    //self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
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
        
        options.addAction(alert)
        
        // Configure popoverPresentationController for iPad
        if let popoverController = options.popoverPresentationController {
            popoverController.sourceView = tableView // Set the source view
            popoverController.sourceRect = tableView.rectForRow(at: indexPath) // Set the source rect (cell's frame)
            popoverController.permittedArrowDirections = .any // Optional: set arrow direction
        }
        
        present(options, animated: true, completion: nil)
        
        //self.tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    let db = Firestore.firestore()
    
    var currentFilter: String? = nil
    
    var allApplications: [JobApplication] = []
    
    var filteredApplications: [JobApplication] = []
    
    var dateString: String = ""
    
    func filterApplications(by status: String?) {
        currentFilter = status
        /*
         filteredApplications = applications.filter { application in
         if let status = status, application.status.rawValue != status {
         return false
         }
         
         // Role-specific filtering
         switch currentUserRole {
         case "seeker":
         return application.userId == currentUserId // Assuming applications have userId field
         case "employer":
         return application.companyId == currentUserId // Assuming applications have companyId field
         case "admin":
         return true // Admin sees all applications
         default:
         return false
         
         }
         } */
        
    }
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(hex: "#1D2D44")
    let lightColor = UIColor(hex: "#EEEEEE")
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var notReviewedButton: UIButton!
    @IBOutlet weak var reviewedButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    @IBOutlet weak var rejectedButton: UIButton!
    
    func styleButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor) {
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.baseBackgroundColor = backgroundColor
        buttonConfig.baseForegroundColor = titleColor
        buttonConfig.cornerStyle = .capsule
    }
    
    @IBAction func allButtonTapped(_ sender: Any) {
        //set the colors as needed
        print("all button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: darkColor, titleColor: lightColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
        
        filterApplications(by: nil) // Show all
        
    }
    
    @IBAction func notReviewedButtonTapped(_ sender: UIButton) {
        print("not reviewed button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: darkColor, titleColor: lightColor)
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
        filterApplications(by: "Not Reviewed")
    }
    
    @IBAction func reviewedButtonTapped(_ sender: UIButton) {
        filterApplications(by: "Reviewed")
        print("reviewed button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(reviewedButton, backgroundColor: darkColor, titleColor: lightColor)
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
    }
    
    @IBAction func approvedButtonTapped(_ sender: UIButton) {
        filterApplications(by: "Approved")
        print("approved button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(approvedButton, backgroundColor: darkColor, titleColor: lightColor)
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
    }
    
    
    @IBAction func rejectedButtonTapped(_ sender: UIButton) {
        filterApplications(by: "Rejected")
        print("rejected button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(rejectedButton, backgroundColor: darkColor, titleColor: lightColor)
    }
    
    let placeholderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "No applications found."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.widthAnchor.constraint(equalToConstant: 200), // Adjust width as needed
            placeholderView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        placeholderView.isHidden = true
        /*
         fetchUserReference(by: currentUserId){userRef in
         if let userRef = userRef {
         print("Successfully fetched user reference: \(userRef.path)")
         self.fetchData(using: userRef)
         } else {
         print("Failed to fetch user reference.")
         }
         }
         */
        let nib = UINib(nibName: "TrackerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllApplications()
        //filterApplications(by: nil) // Show all
        
        
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
    
    @IBOutlet var tableView: UITableView!
    /*
     func fetchData(using applicantRef: DocumentReference) {
     db.collection("jobApplication").whereField("applicantRef", isEqualTo: applicantRef).getDocuments { snapshot, error in
     if let error = error {
     print("Error fetching learning resources: \(error)")
     return
     }
     
     guard let snapshot = snapshot else {
     print("No learning resources found.")
     return
     } //to listen to any updates happening in firebase
     
     
     
     self.applications.removeAll()
     
     // Loop through the documents and add buttons
     self.applications = snapshot.documents.compactMap({document in
     let data = document.data()
     
     
     //let docID = document.documentID
     let applicationId = data["applicationId"] as? Int ?? 0
     let introduction = data["introduction"] as? String ?? "Unknown"
     let contribution = data["contribution"] as? String ?? "Unknown"
     let motivation = data["motivation"] as? String ?? "Unknown"
     let applicationStatusRaw = data["status"] as? String ?? "Not Reviewed"
     let applicationStatus = JobApplication.ApplicationStatus(rawValue: applicationStatusRaw)
     
     // Safely unwrap applicationStatus
     guard let status = applicationStatus else {
     print("Invalid application status: \(applicationStatusRaw) for document ID: \(document.documentID)")
     continue // Skip this document if application status is invalid
     }
     
     if let timestamp = data["date"] as? Timestamp {
     let date = timestamp.dateValue()
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "dd-MM-yyyy"
     dateString = dateFormatter.string(from: date)
     } else {
     print("No valid timestamp found for document ID: \(document.documentID)")
     }
     
     // Fetch the applicant reference
     if let applicantRef = data["applicantRef"] as? DocumentReference {
     group.enter() // Start a new async task
     
     fetchUserReference(by: applicantRef) { userRef in
     if let userRef = userRef {
     userRef.getDocument { applicantSnapshot, error in
     if let error = error {
     print("Error fetching applicant document: \(error)")
     group.leave() // End the async task
     return
     }
     
     guard let applicantData = applicantSnapshot?.data() else {
     print("Applicant document not found for reference: \(userRef.path)")
     group.leave() // End the async task
     return
     }
     
     // Extract any relevant applicant data
     let applicantName = applicantData["name"] as? String ?? "Unknown"
     
     var application = JobApplication()
     
     application.briefIntroduction = introduction
     application.applicationId = applicationId
     application.contributionToCompany = contribution
     application.motivation = motivation
     application.status = status
     application.applicationDate = dateString
     application.jobApplicant = jobApplicant
     
     applications.append(application)
     
     return application
     
     }
     
     
     
     
     DispatchQueue.main.async {
     self.filterApplications(by: nil)
     self.tableView.reloadData()
     }
     
     }
     
     */
    
    
    /*
     var jobs: [Job] = []
     
     
     // Fetch applications for a seeker
     func fetchApplicationsForSeeker(userId: Int) {
     let query = db.collection("jobApplication").whereField("seekerId", isEqualTo: userId)
     fetchApplications(query: query)
     }
     
     // Fetch applications for an employer
     func fetchApplicationsForEmployer(userId: Int) {
     let jobQuery = db.collection("jobs").whereField("userId", isEqualTo: userId)
     jobQuery.getDocuments { snapshot, error in
     guard let jobDocuments = snapshot?.documents else {
     print("No jobs found for employer.")
     return
     }
     
     self.jobs.removeAll() // Clear previous jobs
     for jobDocument in jobDocuments {
     // Save job document in the jobs array
     let job = Job(id: jobDocument.documentID, data: jobDocument.data())
     self.jobs.append(job)
     
     let applicationsQuery = db.collection("jobApplication").whereField("jobId", isEqualTo: jobDocument.documentID)
     self.fetchApplications(query: applicationsQuery)
     }
     }
     }
     
     // Fetch applications for an admin
     func fetchApplicationsForAdmin() {
     let query = db.collection("jobApplication")
     fetchApplications(query: query)
     }
     
     // Common method to fetch applications
     private func fetchApplications(query: Query) {
     query.getDocuments { snapshot, error in
     if let error = error {
     print("Error fetching applications: \(error)")
     return
     }
     
     guard let documents = snapshot?.documents else {
     print("No applications found.")
     return
     }
     
     self.applications.removeAll()
     
     let fetchGroup = DispatchGroup()
     
     for document in documents {
     guard let applicantRef = document.data()["applicantRef"] as? DocumentReference else {
     print("Invalid applicant reference for document ID: \(document.documentID)")
     continue
     }
     
     fetchGroup.enter()
     applicantRef.getDocument { applicantSnapshot, error in
     if let error = error {
     print("Error fetching applicant document: \(error)")
     fetchGroup.leave()
     return
     }
     
     guard let applicantSnapshot = applicantSnapshot, applicantSnapshot.exists else {
     print("Applicant document not found for reference: \(applicantRef.path)")
     fetchGroup.leave()
     return
     }
     
     // Create the application object
     let application = JobApplication(
     briefIntroduction: document.data()["introduction"] as? String ?? "Unknown",
     applicationId: document.data()["applicationId"] as? Int ?? 0,
     contributionToCompany: document.data()["contribution"] as? String ?? "Unknown",
     motivation: document.data()["motivation"] as? String ?? "Unknown",
     status: JobApplication.ApplicationStatus(rawValue: document.data()["status"] as? String ?? "Not Reviewed") ?? .notReviewed,
     applicant: applicantSnapshot.data(), // Entire applicant object
     applicationDate: self.formatDate(from: document.data()["date"])
     )
     
     self.applications.append(application)
     fetchGroup.leave()
     }
     }
     
     // Notify when all fetches are done
     fetchGroup.notify(queue: .main) {
     self.tableView.reloadData()
     }
     }
     }*/
    
    private func fetchAllApplications() {
        db.collection("jobApplication")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching all applications: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No applications found in the snapshot.")
                    return
                }
                
                self.handleApplicationFetch(snapshot: snapshot) { jobs in
                    print("Fetched \(self.applications.count) applications.")
                    self.allApplications = self.applications
                    self.tableView.reloadData()
                }
            }
    }
    
    var applications: [JobApplication] = []
    var jobs: [Job] = []
    private func handleApplicationFetch(snapshot: QuerySnapshot?, completion: @escaping ([JobApplication]) -> Void) {
        
        
        guard let documents = snapshot?.documents else {
            print("No job applications found")
            completion(applications) // Return an empty array if no documents
            return
        }
        
        let dispatchGroup = DispatchGroup() // To wait for asynchronous fetches
        
        for document in documents {
            let data = document.data()
            
            guard let introduction = data["introduction"] as? String,
                  let applicantRef = data["applicantRef"] as? DocumentReference,
                  let jobRef = data["jobPostRef"] as? DocumentReference else {
                continue // Skip if any required data is missing
            }
            
            let applicationId = (data["applicationId"] as? NSNumber)?.intValue ?? 0
            
            guard let statusRaw = data["status"] as? String,
                  let status = JobApplication.ApplicationStatus(rawValue: statusRaw) else {
                print("Invalid application status for document ID: \(document.documentID)")
                continue
            }
            
            if let dateApplied = data["date"] as? Timestamp {
                let date = dateApplied.dateValue() // Convert Timestamp to Date
                
                guard let contribution = data["contribution"] as? String,
                      let motivation = data["motivation"] as? String,
                      let cvRef = data["cvRef"] as? DocumentReference else {
                    continue // Skip if any required data is missing
                }

                // Create a new JobApplication instance
                var application = JobApplication(
                    jobApplicant: nil, // Placeholder, set later
                    jobApplied: nil, // Placeholder for Job object, fetch if needed
                    applicantCVId: "", // Update as needed
                    briefIntroduction: introduction,
                    motivation: motivation,
                    contributionToCompany: contribution,
                    status: status,
                    applicationId: applicationId
                )
                
                dispatchGroup.enter() // Enter for fetching applicant details
                
                // Fetch applicant details asynchronously
                applicantRef.getDocument(source: .default) { (applicantSnapshot, error) in
                    if let error = error {
                        print("Error fetching applicant details: \(error.localizedDescription)")
                        dispatchGroup.leave() // Leave if there's an error
                        return
                    }
                    
                    if let applicantData = applicantSnapshot?.data() {
                        let applicantName = applicantData["name"] as? String ?? "Unknown"
                        let applicantEmail = applicantData["email"] as? String ?? "Unknown"
                        let applicantCity = applicantData["city"] as? String ?? "Unknown"
                        let applicantCountry = applicantData["country"] as? String ?? "Unknown"
                        let userId = applicantData["userId"] as? Int ?? 0
                        
                        let applicantDetails = SeekerDetails(
                            seekerName: applicantName,
                            //userId: userId,
                            email: applicantEmail,
                            password: applicantCity,
                            country: applicantCountry,
                            city: "",
                            isMentor: false,
                            selectedJobPosition: ""
                        )
                        
                        application.jobApplicant = applicantDetails
                        self.applications.append(application)
                    }
                    
                    dispatchGroup.enter() // Enter for fetching job details
                    // Fetch job details asynchronously
                    jobRef.getDocument { (jobSnapshot, error) in
                        if let error = error {
                            print("Error fetching job details: \(error.localizedDescription)")
                            dispatchGroup.leave() // Leave if there's an error
                            return
                        }
                        
                        if let jobData = jobSnapshot?.data() {
                            let jobTitle = jobData["jobTitle"] as? String ?? "Unknown"
                            let jobEmploymentType = jobData["jobEmploymentType"] as? String ?? "Unknown"
                            let jobLocation = jobData["jobLocation"] as? String ?? "Unknown"
                            let jobPostId = jobData["jobPostId"] as? Int ?? 0
                            
                            guard let levelRaw = jobData["jobLevel"] as? String,
                                  let level = JobLevel(rawValue: levelRaw),
                                  let categoryRaw = jobData["jobCategory"] as? String,
                                  let category = CategoryJob(rawValue: categoryRaw),
                                  let employmentTypeRaw = jobData["jobEmploymentType"] as? String,
                                  let employmentType = EmploymentType(rawValue: employmentTypeRaw) else {
                                print("Invalid job details for document ID: \(document.documentID)")
                                dispatchGroup.leave() // Leave if data is invalid
                                return
                            }
                            
                            if let datePosted = jobData["jobPostDate"] as? Timestamp {
                                let date = datePosted.dateValue() // Convert Timestamp to Date
                                let desc = jobData["jobDescription"] as? String ?? "Unknown"
                                let deadline = (jobData["jobDeadlineDate"] as? Timestamp)?.dateValue()
                                let requirement = jobData["jobRequirement"] as? String ?? "No requirements specified"
                                
                                guard let companyRef = jobData["companyRef"] as? DocumentReference else {
                                    print("No company reference found for job ID: \(jobPostId)")
                                    dispatchGroup.leave() // Leave if no company reference
                                    return
                                }
                                
                                var job = Job(
                                    jobId: jobPostId,
                                    title: jobTitle,
                                    companyDetails: nil,
                                    level: level,
                                    category: category,
                                    employmentType: employmentType,
                                    location: jobLocation,
                                    deadline: deadline,
                                    desc: desc,
                                    requirement: requirement,
                                    extraAttachments: nil,
                                    date: date
                                )
                                
                                // Fetch company details using the company reference
                                dispatchGroup.enter() // Enter for fetching company details
                                companyRef.getDocument { (companySnapshot, error) in
                                    if let error = error {
                                        print("Error fetching company details: \(error.localizedDescription)")
                                        dispatchGroup.leave() // Leave if there's an error
                                        return
                                    }
                                    
                                    if let companyData = companySnapshot?.data() {
                                        let companyName = companyData["name"] as? String ?? "Unknown Company"
                                        let userId = companyData["userId"] as? Int ?? 0
                                        let email = companyData["email"] as? String ?? "Unknown"
                                        let city = companyData["city"] as? String ?? "Unknown"
                                        
                                        // Fetch userType from the userType collection
                                        let userTypeRef = companyData["userType"] as? DocumentReference
                                        
                                        userTypeRef?.getDocument { (userTypeSnapshot, error) in
                                            if let error = error {
                                                print("Error fetching userType: \(error.localizedDescription)")
                                                dispatchGroup.leave()
                                                return
                                            }
                                            
                                            if let userTypeData = userTypeSnapshot?.data(),
                                               let userType = userTypeData["userType"] as? String {
                                                if userType == "admin" || userId == 1 {
                                                    application.jobApplicant = nil // Set jobApplicant to nil for admin
                                                } else if userType == "employer" || userId == 2 {
                                                    // Create applicant if seeker
                                                    let companyMainCategory = companyData["companyMainCategory"] as? String
                                                    let aboutUs = companyData["aboutUs"] as? String
                                                    let employabilityGoals = companyData["employabilityGoals"] as? String
                                                    let vision = companyData["vision"] as? String
                                                    
                                                    let companyDetails = EmployerDetails(
                                                        name: companyName,
                                                        userId: userId,
                                                        email: email,
                                                        city: city,
                                                        companyMainCategory: companyMainCategory,
                                                        aboutUs: aboutUs,
                                                        employabilityGoals: employabilityGoals,
                                                        vision: vision
                                                    )
                                                    
                                                    job.companyDetails = companyDetails
                                                }
                                            }
                                            
                                            self.jobs.append(job) // Append job after fetching company details
                                            dispatchGroup.leave() // Leave after fetching user and company details
                                        }
                                    } else {
                                        print("Company data not found for document ID: \(document.documentID)")
                                        dispatchGroup.leave() // Leave if company data is missing
                                    }
                                }
                            }
                        }
                        
                        // Leave after fetching job details
                        dispatchGroup.leave()
                    }
                    
                    // Leave after fetching applicant details
                    dispatchGroup.leave()
                }
            }
        }
        
        // Notify when all async operations are complete
        dispatchGroup.notify(queue: .main) {
            if self.applications.isEmpty {
                print("No applications were fetched.")
            } else {
                print("Successfully fetched \(self.applications.count) applications.")
                print("Successfully fetched \(self.jobs.count) jobs.")
            }
            completion(self.applications) // Send the aplication array back using the completion handler
        }
    }}
