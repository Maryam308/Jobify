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

class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MonitorCellDelegate{
    var currentUserId: Int = currentLoggedInUserID
   // var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
    private var dispatchGroup = DispatchGroup()
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredByStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Fetched jobs: \(jobs.map { $0.jobId })") // Print all job IDs
        print("Application job IDs: \(filteredApplications.map { $0.jobId })") // Print all application job IDs
        
        if currentUserRole == "seeker" {
            print("Configuring cell for row \(indexPath.row)") // Debug log
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
                let application = filteredByStatus[indexPath.row]

            if let job = jobs.first(where: { $0.jobId == application.jobId }) {
                
                print("Job ID: \(job.jobId), Title: \(job.title), Company: \(job.companyDetails?.name ?? "No Company")")
                print("Job found: \(job.title)") // Debug log
                cell.positionLabel.text = job.title
                cell.companyLabel.text = job.companyDetails?.name ?? "No Company"
                cell.locationLabel.text = job.location
                cell.typeLabel.text = job.employmentType.rawValue
                
            }
            
            else {
                    print("No job found for application: \(application.jobId)") // Debug log
                    cell.positionLabel.text = "Unknown Job"
                    cell.companyLabel.text = "No Company"
                    cell.locationLabel.text = "Unknown Location"
                }
            
            // Load profile picture
            if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
                let imageURL = URL(string: imageURLString) {
                loadImage(from: imageURL, into: cell.ProfileImage)
            } else {
                // Use a system-provided placeholder image
                cell.ProfileImage.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
                
                // Set clipsToBounds to false when no image is present
                cell.ProfileImage.layer.cornerRadius = 0 // Reset corner radius
                cell.ProfileImage.clipsToBounds = false // Disable clipping
            }
                // Status button
                cell.statusButton.setTitle(application.status.rawValue, for: .normal)
                // Set button background color based on status
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

                cell.statusButton.setTitleColor(.white, for: .normal)
                cell.statusButton.layer.cornerRadius = 20
                cell.statusButton.clipsToBounds = true

                return cell
                
            } else if currentUserRole == "employer" || currentUserRole == "admin" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorCell
                let application = filteredByStatus[indexPath.row]
                
                if let job = jobs.first(where: { $0.jobId == application.jobId }) {
                    cell.positionLabel.text = job.title
                    cell.seekerLabel.text = application.jobApplicant?.seekerCVs.first?.personalDetails.name ?? "Unknown Seeker"
                    cell.currentStatusLabel.text = application.status.rawValue
                    
                    switch application.status {
                    case .notReviewed:
                        cell.currentStatusLabel.textColor = UIColor.orange
                    case .reviewed:
                        cell.currentStatusLabel.textColor = UIColor.blue
                    case .approved:
                        cell.currentStatusLabel.textColor = UIColor.green
                    case .rejected:
                        cell.currentStatusLabel.textColor = UIColor.red
                    }
                } else {
                    cell.positionLabel.text = "Unknown Job"
                    cell.seekerLabel.text = "Unknown Seeker"
                    cell.currentStatusLabel.text = application.status.rawValue
                }
                
                
                fetchUserInfo(application: application) { name in
                            DispatchQueue.main.async {
                                cell.seekerLabel.text = name ?? "Unknown Seeker"
                            }
                        }
                
                // Load profile picture
                if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
                    let imageURL = URL(string: imageURLString) {
                    loadImage(from: imageURL, into: cell.profileImage)
                } else {
                    // Use a system-provided placeholder image
                    cell.profileImage.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
                    
                    // Set clipsToBounds to false when no image is present
                    cell.profileImage.layer.cornerRadius = 0 // Reset corner radius
                    cell.profileImage.clipsToBounds = false // Disable clipping
                }
                
                // Set delegate for button action in MonitorCell
                        cell.delegate = self // Assuming MonitorCell has a delegate property
                        cell.application = application // Pass the application to the cell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
                return cell
            }
        }
        

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentUserRole == "seeker"{
            var application = self.filteredByStatus[indexPath.row]
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
            var application = self.filteredByStatus[indexPath.row]
            // Instantiate the detail view controller using the storyboard
            if let matchingJob = jobs.first(where: { $0.jobId == application.jobId }) {
                // Add the job object to the application
                application.jobApplied = matchingJob // Assuming `JobApplication` has a `job` property
            }
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ApplicationDetailTableViewController") as! ApplicationDetailTableViewController
            
            // Pass the application data to the detail view controller
            detailVC.application = application
            
            print("sending application \(application.applicationId)")
            print("sending application cv id: \(application.applicantCVId)")
            
            
            // Push the detail view controller onto the navigation stack
            navigationController?.pushViewController(detailVC, animated: true)
            
            // Deselect the cell after selection
            tableView.deselectRow(at: indexPath, animated: true)
            
            
            
        }}
    let db = Firestore.firestore()
    
    // MARK: MonitorCellDelegate
        func didTapChangeStatusButton(for application: JobApplication) {
            presentChangeStatusActionSheet(for: application)
        }
      
    
    private func presentChangeStatusActionSheet(for application: JobApplication) {
        let currentStatus = application.status // Get current status
        
        print("Current status: \(application.status.rawValue)")
        
        let alert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let options = UIAlertController(title: "Change Status", message: nil, preferredStyle: .actionSheet)

        // Helper function to add an action
        func addAction(title: String, newStatus: JobApplication.ApplicationStatus) {
            let action = UIAlertAction(title: title, style: .default) { _ in
                // Call the updateApplicationStatus method instead of directly updating Firestore
                self.updateApplicationStatus(applicationId: application.applicationId, newStatus: newStatus)
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
                
                // Find the index of the application in the filteredByStatus array
                if let applicationIndex = self.filteredByStatus.firstIndex(where: { $0.applicationId == application.applicationId }) {
                    popoverController.sourceRect = tableView.rectForRow(at: IndexPath(row: applicationIndex, section: 0)) // Set the source rectangle
                } else {
                    print("Application index not found.")
                }
                
            }

        present(options, animated: true, completion: nil)
    }
    
    private func updateApplicationStatus(applicationId: Int, newStatus: JobApplication.ApplicationStatus) {
        // Query Firestore to find the document with the matching applicationId
        db.collection("jobApplication")
            .whereField("applicationId", isEqualTo: applicationId) // applicationId should be Int
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No documents found with applicationId: \(applicationId)")
                    return
                }

                // Assuming there's only one document with the matching applicationId
                for document in documents {
                    // Update the status in the found document
                    document.reference.updateData(["status": newStatus.rawValue]) { error in
                        if let error = error {
                            print("Error updating status: \(error.localizedDescription)")
                        } else {
                            // Update local data source
                            if let index = self.filteredByStatus.firstIndex(where: { $0.applicationId == applicationId }) {
                                self.filteredByStatus[index].status = newStatus
                                // Reload the table view
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
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
    
    var applicationChangeStatus: JobApplication?
    
    var currentFilter: String? = nil
    
    var allApplications: [JobApplication] = []
    
    var filteredApplications: [JobApplication] = []
    
    var filteredByStatus: [JobApplication] = []
    
    var dateString: String = ""
    
    // MARK: filtering applications
    
    private func filterApplicationsForCurrentUser() {
        print("Total applications before filtering: \(allApplications.count)")
        switch currentUserRole {
            case "seeker":
                filterApplicationsForSeeker()
            case "employer":
                filterApplicationsForEmployer()
            case "admin":
                filterApplicationsForAdmin()
            default:
                filteredApplications = allApplications // Fallback
            }
        print("Total applications after filtering: \(filteredApplications.count)")
        }

    private func filterApplicationsForSeeker() {
        print("Current User Applicant ID: \(currentUserId)") // Debugging line
            
        filteredApplications = allApplications.filter { application in
                // Directly retrieve the applicantId from the application
                let applicationApplicantId = application.applicantId
                
                // Print for debugging
                print("Application Applicant ID: \(applicationApplicantId)")
                
                // Compare the application's applicantId with the current user's applicantId
                return applicationApplicantId == currentUserId
            }
        }

    private func filterApplicationsForEmployer() {
        filteredApplications = allApplications.filter { application in
            // Check if jobId is not nil and corresponds to a job in the user's jobs
            let jobId = application.jobId
            guard let job = jobs.first(where: { $0.jobId == jobId }) else {
                return false
            }
            return job.companyDetails?.userId == currentUserId // Check if the job belongs to the current employer
        }
    }

        private func filterApplicationsForAdmin() {
            // Admin can see all applications
            filteredApplications = allApplications
        }

        func filterApplications(by status: String?) {
            if let status = status {
                filteredByStatus = filteredApplications.filter { $0.status.rawValue == status }
            }
            if (status == nil){
                filteredByStatus = filteredApplications
            }
            print("Filtered applications count: \(filteredByStatus.count)")
            
            if(filteredByStatus.count == 0){
                placeholderView.isHidden = false
            }else{
                placeholderView.isHidden = true
            }
                
            self.tableView.reloadData() // Refresh the table view

        }
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(hex: "#1D2D44")
    let lightColor = UIColor(hex: "#EEEEEE")
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var notReviewedButton: UIButton!
    @IBOutlet weak var reviewedButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    @IBOutlet weak var rejectedButton: UIButton!
    
    func styleButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, titleText: String) {
        var buttonConfig = UIButton.Configuration.filled()
        
        buttonConfig.baseBackgroundColor = backgroundColor
        buttonConfig.baseForegroundColor = titleColor
        buttonConfig.cornerStyle = .capsule
        
        button.configuration = buttonConfig
        button.setTitle(titleText, for: .normal)
            
            // Set border properties
        //button.layer.borderColor = borderColor.cgColor
            //button.layer.borderWidth = borderWidth
            //button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        //button.layer.borderWidth = 0.5
        //button.layer.borderColor = borderColor.cgColor
        button.setTitleColor(titleColor, for: .normal)
    }
    
    @IBAction func allButtonTapped(_ sender: Any) {
        //set the colors as needed
        print("all button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Rejected")
        
        filterApplications(by: nil) // Show all
        
    }
    
    @IBAction func notReviewedButtonTapped(_ sender: UIButton) {
        print("not reviewed button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Rejected")
        filterApplications(by: "Not Reviewed")
    }
    
    @IBAction func reviewedButtonTapped(_ sender: UIButton) {
        print("reviewed button clicked")
        
        
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Rejected")
        
        filterApplications(by: "Reviewed")
    }
    
    @IBAction func approvedButtonTapped(_ sender: UIButton) {
        
        print("approved button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Rejected")
        
        filterApplications(by: "Approved")
    }
    
    
    @IBAction func rejectedButtonTapped(_ sender: UIButton) {
        
        print("rejected button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "Rejected")
        filterApplications(by: "Rejected")
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
    
    // MARK: viewDidLoad()
    
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
            
        if currentUserRole == "admin" || currentUserRole == "employer"{
            
            updateApplications()
            filterApplications(by: nil) // Show all applications
            let nib1 = UINib(nibName: "MonitorCell", bundle: nil)
                    tableView.register(nib1, forCellReuseIdentifier: "MonitorCell")
            tableView.delegate = self
            tableView.dataSource = self
        } else {
            updateApplications()
            filterApplications(by: nil) // Show all applications
            let nib = UINib(nibName: "TrackerCell", bundle: nil)
                    tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        
        // Style each button
        styleButton(allButton, backgroundColor: darkColor, titleColor: lightColor, borderColor: darkColor, borderWidth: 5, titleText: "All")
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Not Reviewed")
        styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Reviewed")
        styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Approved")
        styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor, borderColor: .clear, borderWidth: 0, titleText: "Rejected")
       
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.tableView.reloadData()
        }
    
    
    func loadingPage() {
        
    }
    
    func updateApplications() {
        fetchAllApplications { [weak self] applications in
            DispatchQueue.main.async {
                self?.allApplications = applications
                print("Total applications fetched: \(self?.allApplications.count ?? 0)")
                self?.filterApplicationsForCurrentUser() // Ensure this is executed
                print("Filtering applications for current user.")
                self?.filterApplications(by: nil)
                self?.tableView.reloadData()
            }
        }
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
    
    
    /*
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
  */
    @IBOutlet var tableView: UITableView!
    
    // MARK: fetching the data
    
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
                        completion(self.applications)
                        //self.tableView.reloadData()
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
                  let applicantRef = data["applicantRef"] as? DocumentReference else {
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
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                
                let applicationDateString = dateFormatter.string(from: date)
                let contribution = data["contribution"] as? String ?? ""
                let motivation = data["motivation"] as? String ?? ""
                let cvID = data["cvID"] as? String
                let applicantId = (data["applicantId"] as? NSNumber)?.intValue ?? 0
                
                // Create a new JobApplication instance
                var application = JobApplication(
                    jobApplicant: nil,
                    jobApplied: nil,
                    briefIntroduction: introduction,
                    motivation: motivation,
                    contributionToCompany: contribution,
                    status: status,
                    applicationId: applicationId,
                    jobId: jobId,
                    applicationDate: applicationDateString,
                    applicantRef: applicantRef,
                    applicantCVId: cvID ?? "",
                    applicantId: applicantId
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
                        //let userId = applicantData["userId"] as? Int ?? 0
                        
                        let applicantDetails = SeekerDetails(
                            seekerName: applicantName,
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
                    
                    // Fetch job details asynchronously using jobId
                    dispatchGroup.enter() // Enter for fetching job details
                    let jobsCollection = Firestore.firestore().collection("jobs")
                    print("Fetching job details for jobId: \(jobId)")

                    jobsCollection.whereField("jobPostId", isEqualTo: jobId).getDocuments { (jobSnapshot, error) in
                        if let error = error {
                            print("Error fetching job details: \(error.localizedDescription)")
                            dispatchGroup.leave() // Leave if there's an error
                            return
                        }
                        
                        print("Job snapshot count for jobId \(jobId): \(jobSnapshot?.documents.count ?? 0)") // Log document count
                        
                        if let jobDocument = jobSnapshot?.documents.first {
                            let jobData = jobDocument.data()
                            let jobTitle = jobData["jobTitle"] as? String ?? "Unknown"
                            let jobLocation = jobData["jobLocation"] as? String ?? "Unknown"
                            
                            // Continue with the rest of your job data extraction logic...
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
                        } else {
                            print("No job found with jobId: \(jobId)")
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
            completion(self.applications) // Send the application array back using the completion handler
        }
    }
}
