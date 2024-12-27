//
//  ApplicationTrackerViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore


let db = Firestore.firestore()

let seekerRef = db.collection("users").document("userID")

class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 3
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
    private var dispatchGroup = DispatchGroup()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allApplications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentUserRole == "seeker" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
            let application = allApplications[indexPath.row]
            
            
            print("jobs: \(jobs)")
            
            
            var jobTitle: String = ""
            var companyName: String = ""
            var jobLocation: String = ""
            for job in jobs {
                if job.jobId == application.jobId {
                    jobTitle = job.title
                    companyName = job.companyDetails?.name ?? "No Company"
                    jobLocation = job.location
                    print("//////////////////////////////")
                    print("jobLocation: \(jobLocation)")
                    print("companyName: \(companyName)")
                    print("jobTitle: \(jobTitle)")
                    cell.positionLabel.text = jobTitle
                    cell.companyLabel.text = companyName
                    cell.locationLabel.text = jobLocation
                    break // Exit the loop once the job is found
                }
            }
            
            
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
            
        } else if currentUserRole == "employer" || currentUserRole == "admin" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorCell
            
            let application = allApplications[indexPath.row]
            
            print("jobs: \(jobs)")
            
            
            var jobTitle: String = ""
            
            for job in jobs {
                if let myJobPosts = job.companyDetails?.myJobPostsList {
                    // Check if the jobId of the application matches any job's jobId in the myJobPostsList
                    if myJobPosts.contains(where: { $0.jobId == application.jobId }) {
                        jobTitle = job.title
                        print("//////////////////////////////")
                        print("jobTitle: \(jobTitle)")
                        cell.positionLabel.text = jobTitle
                        break // Exit the loop once the job is found
                    }
                }
            }
            cell.seekerLabel.text = application.jobApplicant?.seekerCVs.first?.personalDetails.name
            
            cell.currentStatusLabel.text = application.status.rawValue
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
            return cell
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentUserRole == "seeker"{
            var application = self.allApplications[indexPath.row]
            // Instantiate the detail view controller using the storyboard
            // Find the corresponding job for the application
            if let matchingJob = jobs.first(where: { $0.jobId == application.jobId }) {
                // Add the job object to the application
                application.jobApplied = matchingJob // Assuming `JobApplication` has a `job` property
            }
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ApplicationDetailTableViewController") as! ApplicationDetailTableViewController
            
            // Pass the application data to the detail view controller
            detailVC.application = application
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(detailVC, animated: true)
            
            // Deselect the cell after selection
            tableView.deselectRow(at: indexPath, animated: true)
        }else if currentUserRole == "employer" || currentUserRole == "admin"{
            let application = self.allApplications[indexPath.row]
            // Instantiate the detail view controller using the storyboard
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ApplicationDetailTableViewController") as! ApplicationDetailTableViewController
            
            // Pass the application data to the detail view controller
            detailVC.application = application
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(detailVC, animated: true)
            
            // Deselect the cell after selection
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
       /*
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
        */
    
    }
    let db = Firestore.firestore()
    
    
    var currentFilter: String? = nil
    
    var allApplications: [JobApplication] = []
    
    var filteredApplications: [JobApplication] = []
    
    var dateString: String = ""
    
    func filterApplications(by status: String?) {
        currentFilter = status
        /*
         filteredApplications = allApplications.filter { application in
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
         }*/
        
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
            fetchUserReference(by: currentUserId) { userRef, userType in
                if let userRef = userRef {
                    print("Successfully fetched user reference: \(userRef.path)")
                    
                    switch userType {
                    case "admin":
                        print("User is an admin.")
                        
                        self.currentUserRole = "admin"
                        
                        break
                    case "employer":
                        print("User is an employer.")
                        
                        self.currentUserRole = "employer"
                        
                        break
                        
                    case "seeker":
                        print("User is a seeker.")
                        
                        self.currentUserRole = "seeker"
                        
                        break
                    default:
                        print("Unknown user type.")
                    }
                } else {
                    print("Failed to fetch user reference.")
                }
            }
        */
         
        updateApplications()
        let nib = UINib(nibName: "TrackerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //filterApplications(by: nil) // Show all
       
        
    }
    
    func updateApplications() {
        fetchAllApplications { [weak self] applications in
            DispatchQueue.main.async {
                self?.allApplications = applications
                self?.tableView.reloadData() // Reload table view on main thread
            }
        }
    }
    
    func fetchUserReference(by userId: Int, completion: @escaping (DocumentReference?, String?) -> Void) {
        db.collection("users")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error)")
                    completion(nil, nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No user document found for userId: \(userId)")
                    completion(nil, nil)
                    return
                }
                
                // Retrieve the userType field
                let userTypeRef = document.reference.collection("userType").document("type") // Adjust the path as necessary
                
                userTypeRef.getDocument { (typeSnapshot, error) in
                    if let error = error {
                        print("Error fetching userType: \(error)")
                        completion(nil, nil)
                        return
                    }
                    
                    guard let typeData = typeSnapshot?.data(),
                          let userType = typeData["userType"] as? String else {
                        print("User type not found for user ID: \(userId)")
                        completion(nil, nil)
                        return
                    }
                    
                    // Return the reference and userType
                    completion(document.reference, userType)
                }
            }
    }
  
    @IBOutlet var tableView: UITableView!
    
    private func fetchAllApplications(completion: @escaping ([JobApplication]) -> Void) {
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
                let jobId = (data["jobId"] as? NSNumber)?.intValue ?? 0
                
                guard let statusRaw = data["status"] as? String,
                      let status = JobApplication.ApplicationStatus(rawValue: statusRaw) else {
                    print("Invalid application status for document ID: \(document.documentID)")
                    continue
                }
                
                if let dateApplied = data["date"] as? Timestamp {
                    let date = dateApplied.dateValue() // Convert Timestamp to Date
                    // Convert Date to String
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateStyle = .medium // or .short, .long depending on your needs
                                dateFormatter.timeStyle = .none // Change to .short, .medium if you want to include time

                                let applicationDateString = dateFormatter.string(from: date)
                    let cvRef = data["cvRef"] as? DocumentReference
                    let applicantRef = data["applicantRef"] as? DocumentReference
                    guard let contribution = data["contribution"] as? String,
                          let motivation = data["motivation"] as? String,
                          let cvRef = data["cvRef"] as? DocumentReference else {
                        continue // Skip if any required data is missing
                    }

                    // Create a new JobApplication instance
                    var application = JobApplication(
                        jobApplicant: nil,
                        jobApplied: nil,
                        //applicantCVId: "",
                        briefIntroduction: introduction,
                        motivation: motivation,
                        contributionToCompany: contribution,
                        status: status,
                        applicationId: applicationId,
                        jobId: jobId,
                        applicationDate: applicationDateString,
                        applicantRef: applicantRef,
                        employerRef: nil,
                        cvRef: cvRef
                    )
                    
                    dispatchGroup.enter() // Enter for fetching applicant details
                    
                    // Fetch applicant details asynchronously
                    applicantRef?.getDocument(source: .default) { (applicantSnapshot, error) in
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
        }
}
