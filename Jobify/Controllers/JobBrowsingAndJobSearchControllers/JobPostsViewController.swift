
//
//  JobPostsViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//
import UIKit
import FirebaseFirestore

enum JobSource {
   case recommendedJobs
   case recentJobs
   case category(String)
   case myJobPosts
  
}

enum SortOrder {
    case newestToOldest
    case oldestToNewest
}


class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterViewControllerDelegate, SortViewController.SortViewControllerDelegate, CellActionDelegate {
    
   
    
    func didApplyFilters(_ filters: [String : [String]]) {
        // Apply filters only on the already fetched job list (self.jobs)
        filteredJobPosts = self.originalJobs.filter { job in
            let matchesLevel = filters["Level"]?.isEmpty ?? true || filters["Level"]?.contains(job.level.rawValue) ?? false
            let matchesEmploymentType = filters["Employment Type"]?.isEmpty ?? true || filters["Employment Type"]?.contains(job.employmentType.rawValue) ?? false
            let matchesCategory = filters["Category"]?.isEmpty ?? true || filters["Category"]?.contains(job.category.rawValue) ?? false
           /* let matchesCompany = filters["Company"]?.isEmpty ?? true || filters["Company"]?.contains(job.companyDetails?.name ?? "By Jobify") ?? false*/
            let matchesLocation = filters["Location"]?.isEmpty ?? true || filters["Location"]?.contains(job.location) ?? false
            // Initialize matchesCompany
            let matchesCompany: Bool
            
            // Check if "Admin" is selected as a filter
            if filters["Company"]?.contains("Admin") == true {
                // Include jobs with nil company details when "Admin" is selected
                matchesCompany = job.companyDetails?.name == nil // true if companyName is nil
            } else {
                let companyName = job.companyDetails?.name
                matchesCompany = filters["Company"]?.isEmpty ?? true || (companyName != nil && filters["Company"]?.contains(companyName!) ?? false)
            }
            return matchesLevel && matchesEmploymentType && matchesCategory && matchesCompany && matchesLocation
            
        }
        
        // Use the filtered list for displaying the jobs
        self.jobs = filteredJobPosts
        jobPostCollectionView.reloadData() // Reload to display filtered jobs
        
    }
    
    
    func didSelectSortOrder(_ sortOrder: String) {
        // Update currentSortOrder based on the selected option
        switch sortOrder {
        case "Newest to Oldest":
            currentSortOrder = .newestToOldest
        case "Oldest to Newest":
            currentSortOrder = .oldestToNewest
        default:
            currentSortOrder = nil
        }
        
        // Sort jobs after updating the sort order
        sortJobs()
        jobPostCollectionView.reloadData()
    }
    

    func sortJobs() {
        guard let currentSortOrder = currentSortOrder else { return }

        switch currentSortOrder {
        case .newestToOldest:
            jobs.sort { $0.date > $1.date } // Sort by date descending
        case .oldestToNewest:
            jobs.sort { $0.date < $1.date } // Sort by date ascending
        }
        jobPostCollectionView.reloadData() // Reload collection view after sorting
    }
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!

    
        var currentUserId: Int = currentLoggedInUserID
       // var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
        let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
        var currentSortOrder: SortOrder? = .newestToOldest // Set default sort order
        var originalJobs: [Job] = [] // hold original job to allow repeated filtering
        var jobs: [Job] = [] // Array to hold job postings
        var filteredJobPosts: [Job] = [] // Filtered results
        let db = Firestore.firestore() // Firestore instance
        
        var source: JobSource?
        var selectedJob: Job?
    
        private let showJobDetailsSegueIdentifier = "showJobDetails"
        let currentTimestamp = Timestamp(date: Date())
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up your custom collection view layout
               // let layout = CustomFlowLayout()
                //jobPostCollectionView.collectionViewLayout = layout
            
            fetchJobPostings() // Fetch data from Firestore only once
            
            jobPostCollectionView.delegate = self
            jobPostCollectionView.dataSource = self
            
            // Register the job cell for collection view
            let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
            jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)

        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilterPage", let filterVC = segue.destination as? FilterViewController {
            filterVC.delegate = self
        } else if segue.identifier == "showSortPage", let sortVC = segue.destination as? SortViewController {
            sortVC.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Ensure the tab bar is visible when returning to this controller
           self.tabBarController?.tabBar.isHidden = true
       }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        let job = jobs[indexPath.row]

        cell.jobPostId = job.jobId
        
        // Load profile picture
        if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
            let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL, into: cell.jobPostImageView)
        } else {
            // Use a system-provided placeholder image
            cell.jobPostImageView.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
            
            // Set clipsToBounds to false when no image is present
            cell.jobPostImageView.layer.cornerRadius = 0 // Reset corner radius
            cell.jobPostImageView.clipsToBounds = false // Disable clipping
        }

        cell.jobPostTitlelbl.text = job.companyDetails?.name ?? "By Jobify"
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.jobPostDatelbl.text = dateFormatter.string(from: job.date)
        
        cell.jobPostLevellbl.setTitle(job.level.rawValue, for: .normal)
        cell.jobPostEnrollmentTypelbl.setTitle(job.employmentType.rawValue, for: .normal)
        cell.jobPostCategorylbl.setTitle(job.category.rawValue, for: .normal)
        cell.joPostLocationlbl.setTitle(job.location, for: .normal)
        
        cell.jobPostDescriptionTitlelbl.text = job.title
        cell.jobPostDescriptionlbl.text = job.desc
        
        // Show or hide the delete button based on the current user role
            if currentUserRole == "admin" {
                cell.btnDelete.isHidden = false

            } else if currentUserRole == "seeker" {
                cell.btnDelete.isHidden = true
            } else if currentUserRole == "employer" && currentUserId == job.companyDetails?.userId {
                cell.btnDelete.isHidden = false
            } else {
                cell.btnDelete.isHidden = true // Hide the button for other roles
            }
            cell.jobPostId = job.jobId

            cell.delegate = self// Set the delegate to the view controller
        
        return cell
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
    
    
    func deleteJobPost(jobPostId: Int, completion: @escaping (Bool) -> Void) {
        let jobPostCollection = db.collection("jobPost")
        
        jobPostCollection.whereField("jobPostId", isEqualTo: jobPostId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding job post: \(error.localizedDescription)")
                    completion(false) // Indicate failure
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No job post found with the provided ID.")
                    completion(false) // Indicate failure
                    return
                }
                
                // Delete the document
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting job post: \(error.localizedDescription)")
                        completion(false) // Indicate failure
                    } else {
                        print("Job post successfully deleted.")
                        completion(true) // Indicate success
                    }
                }
            }
    }


    func confirmDelete(forJobPostId jobPostId: Int) {
        let alert = UIAlertController(title: "Delete Confirmation",
                                      message: "Are you sure you want to delete this job post?",
                                      preferredStyle: .alert)
        
        // "Yes" action: Call `deleteJobPost`
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            self?.deleteJobPost(jobPostId: jobPostId) { success in
                if success {
                    // Navigate back only after successful deletion
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    // Show an error message if needed
                    DispatchQueue.main.async {
                        let errorAlert = UIAlertController(title: "Error", message: "Failed to delete the job post. Please try again.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(errorAlert, animated: true)
                    }
                }
            }
        }
        
        // "No" action: Dismiss the alert
        let noAction = UIAlertAction(title: "No", style: .cancel)
        
        // Add actions to the alert
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }

   


    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedJob = jobs[indexPath.row]  // Store the selected job

            
        // Load the storyboard containing JobDetailsTableViewController
        let storyboard = UIStoryboard(name: "JobDetailsAndJobRecommendations_FatimaKhamis", bundle: nil) // Ensure this matches your storyboard name
        if let jobDetailsVC = storyboard.instantiateViewController(withIdentifier: "showJobDetails") as? JobDetailsTableViewController { // Use the correct storyboard ID
            jobDetailsVC.job = selectedJob
            
            // Push the JobDetailsTableViewController onto the navigation stack
            navigationController?.pushViewController(jobDetailsVC, animated: true)
        } else {
            print("Failed to instantiate JobDetailsTableViewController")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 0
        let columns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1 // 2 columns for iPad, 1 column for iPhone
        
        // Calculate the width of each cell
        let cellWidth = (collectionViewWidth - spacing) / columns
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 260 : 220 // Adjust height for iPad
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3 // Set this to a smaller value for less horizontal spacing between cells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Set this to a smaller value for less vertical spacing between rows
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Insets for iPad
            return UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10)
        } else {
            // Insets for iPhone
            return UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 20)
        }
    }
    
    func fetchJobPostings() {
        switch source {
        case .myJobPosts:
            let userId = currentUserId
            print("userId: \(userId)")
            //to get the user refrence
            db.collection("users")
                .whereField("userId", isEqualTo: userId)
                      .getDocuments { (userSnapshot, error) in
                          if let error = error {
                              print("Error fetching user document: \(error.localizedDescription)")
                              return
                          }
                          
                          guard let userDocument = userSnapshot?.documents.first else {
                              print("User document not found.")
                              return
                          }
                          
                          let userRef = userDocument.reference

                            // Now fetch job posts where companyRef matches this user's reference
                          self.db.collection("jobPost").whereField("companyRef", isEqualTo: userRef).order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print("Error fetching job posts for user:\(error.localizedDescription)")
                                return
                                                    
                        }
                        self.handleJobPostFetch(snapshot: snapshot, error: nil)
                    }
            }
        case .recentJobs:
            db.collection("jobPost").whereField("jobDeadlineDate", isGreaterThanOrEqualTo: currentTimestamp).order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching recent jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot, error: nil)
            }
        case .category(let category):
            db.collection("jobPost")
                .whereField("jobCategory", isEqualTo: category)
                .order(by: "jobPostDate", descending: true)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching jobs for category \(category): \(error.localizedDescription)")
                        return
                    }
                    self.handleJobPostFetch(snapshot: snapshot, error: nil)
                }
        case .recommendedJobs:
            fetchRecommendedJobs()
        case nil:
            print("No source provided.")
        }
    }
    
    private func fetchRecommendedJobs() {
        print("fetchRecommendedJobs() called")
        let userId = currentUserId
        print("userId: \(userId)")

        // Fetch user reference
        db.collection("users")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (userSnapshot, error) in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    return
                }
                
                guard let userDocument = userSnapshot?.documents.first else {
                    print("User document not found.")
                    return
                }
                
                let userRef = userDocument.reference
                
                // Step 1: Fetch the user's selected job categories
                self.db.collection("selectedJobCategories")
                    .whereField("userRef", isEqualTo: userRef)
                    .getDocuments { [weak self] (categorySnapshot, error) in
                        guard let self = self else { return }
                        
                        if let error = error {
                            print("Error fetching selected job categories: \(error.localizedDescription)")
                            return
                        }
                        
                        print("Number of documents fetched: \(categorySnapshot?.documents.count ?? 0)")

                        var chosenCategories: [String] = []
                        
                        // Inspect the documents in selectedJobCategories
                        for categoryDocument in categorySnapshot?.documents ?? [] {
                            let documentData = categoryDocument.data()
                            print("Document Data: \(documentData)")  // Debugging print to inspect the document structure

                            // Check if "selectedJobCategories" field exists and is an array of strings
                            if let categories = documentData["selectedJobCategories"] as? [String] {
                                print("Categories found: \(categories)")  // Debugging print to inspect categories
                                chosenCategories.append(contentsOf: categories)
                            } else {
                                print("No 'selectedJobCategories' field found or it's not an array: \(documentData)")  // Debugging print to check the data
                            }
                        }
                        
                        // Debugging print to check the final categories array
                        print("Chosen Categories: \(chosenCategories)")
                        
                        // Step 2: Fetch job applications for the user with the chosen categories
                        self.fetchJobApplications(for: userRef, chosenCategories: chosenCategories)
                    }
            }
    }


    private func fetchJobApplications(for userRef: DocumentReference, chosenCategories: [String]) {
        print("here is the passed chosen categories: \(chosenCategories)")
        db.collection("jobApplication")
            .whereField("userRef", isEqualTo: userRef)
            .getDocuments { [weak self] (applicationSnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching job applications: \(error.localizedDescription)")
                    return
                }
                
                var appliedJobPostRefs: [DocumentReference] = []
                for applicationDocument in applicationSnapshot?.documents ?? [] {
                    if let jobPostRef = applicationDocument.data()["jobPostRef"] as? DocumentReference {
                        appliedJobPostRefs.append(jobPostRef)
                    }
                }
                
                // Step 3: Fetch categories for the applied job posts
                self.fetchCategoriesForJobPosts(appliedJobPostRefs: appliedJobPostRefs, chosenCategories: chosenCategories)
            }
    }
    
    
    private func fetchCategoriesForJobPosts(appliedJobPostRefs: [DocumentReference], chosenCategories: [String]) {
        var appliedCategories: Set<String> = []
        let dispatchGroup = DispatchGroup()

        for jobPostRef in appliedJobPostRefs {
            dispatchGroup.enter()
            jobPostRef.getDocument { (jobPostSnapshot, error) in
                defer { dispatchGroup.leave() }

                if let error = error {
                    print("Error fetching job post: \(error.localizedDescription)")
                    return
                }

                if let jobPostData = jobPostSnapshot?.data(),
                   let jobCategory = jobPostData["jobCategory"] as? String {
                    appliedCategories.insert(jobCategory) // Ensure uniqueness
                }
            }
        }

        // Combine chosen and applied categories and fetch job posts
        dispatchGroup.notify(queue: .main) {
            let combinedCategories = Array(Set(chosenCategories).union(appliedCategories)) // Unique categories
            print("Combined Categories: \(combinedCategories)")

            // Step 4: Fetch job posts based on combined categories
            self.fetchJobPosts(for: combinedCategories)
        }
    }

    private func fetchJobPosts(for categories: [String]) {
        let dispatchGroup = DispatchGroup()
        var recommendedJobs: [Job] = []

        for category in categories {
            dispatchGroup.enter()
            db.collection("jobPost").whereField("jobDeadlineDate", isGreaterThanOrEqualTo: currentTimestamp).whereField("jobCategory", isEqualTo: category).order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                    defer { dispatchGroup.leave() }

                    if let error = error {
                        print("Error fetching job posts for category \(category): \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    for document in documents {
                        let data = document.data()
                        if let job = self.createJob(from: data, document: document) {
                            recommendedJobs.append(job)
                            
                        }
                    }
                }
        }

        dispatchGroup.notify(queue: .main) {
            print("Fetched \(recommendedJobs.count) recommended jobs based on categories.")
            self.originalJobs = recommendedJobs
            self.jobs = recommendedJobs
            self.jobPostCollectionView.reloadData()
           
        }
    }

    private func createJob(from data: [String: Any], document: DocumentSnapshot) -> Job? {
        guard let title = data["jobTitle"] as? String,
              let companyRef = data["companyRef"] as? DocumentReference,
              let jobPostId = (data["jobPostId"] as? NSNumber)?.intValue,
              let levelRaw = data["jobLevel"] as? String,
              let level = JobLevel(rawValue: levelRaw),
              let categoryRaw = data["jobCategory"] as? String,
              let category = CategoryJob(rawValue: categoryRaw),
              let city = data["jobLocation"] as? String,
              let employmentTypeRaw = data["jobEmploymentType"] as? String,
              let employmentType = EmploymentType(rawValue: employmentTypeRaw),
              let datePosted = data["jobPostDate"] as? Timestamp else {
            print("Invalid data for document ID: \(document.documentID)")
            return nil
        }

        let date = datePosted.dateValue()
        let desc = data["jobDescription"] as? String ?? "Unknown"
        let deadline = (data["jobDeadlineDate"] as? Timestamp)?.dateValue()
        let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
        
        let extraAttachments = data["imageUrl"] as? String


        var job = Job(
            jobId: jobPostId,
            title: title,
            companyDetails: nil,
            level: level,
            category: category,
            employmentType: employmentType,
            location: city,
            deadline: deadline,
            desc: desc,
            requirement: requirement,
            extraAttachments: extraAttachments,
            date: date
        )

        // Fetch company details asynchronously
        companyRef.getDocument { (companySnapshot, error) in
            if let error = error {
                print("Error fetching company details: \(error.localizedDescription)")
                return
            }

            if let companyData = companySnapshot?.data() {
                let companyName = companyData["name"] as? String ?? "Unknown"
                let userId = companyData["userId"] as? Int ?? 0
                let email = companyData["email"] as? String ?? "Unknown"
                let city = companyData["city"] as? String ?? "Unknown"
                let userTypeRef = companyData["userType"] as? DocumentReference

                userTypeRef?.getDocument { (userTypeSnapshot, error) in
                    if let error = error {
                        print("Error fetching userType: \(error.localizedDescription)")
                        return
                    }

                    if let userTypeData = userTypeSnapshot?.data(),
                       let userType = userTypeData["userType"] as? String {
                        if userType == "admin" || userId == 1 {
                            job.companyDetails = nil // Set to nil for admin or userId == 1
                        } else if userType == "employer" {
                            // Create companyDetails if employer
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
                }
            } else {
                print("Company data not found for document ID: \(document.documentID)")
            }
        }

        return job
    }

    
    private func handleJobPostFetch(snapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("Error fetching job postings: \(error.localizedDescription)")
            return
        }
        
        guard let documents = snapshot?.documents else {
            print("No job postings found")
            return
        }
        
        self.originalJobs.removeAll()
        self.jobs.removeAll() // Clear existing jobs
        
        let dispatchGroup = DispatchGroup() // To wait for asynchronous fetches
        
        for document in documents {
            let data = document.data()
            
            if let title = data["jobTitle"] as? String,
               let companyRef = data["companyRef"] as? DocumentReference {
                
                let jobId = (data["jobPostId"] as? NSNumber)?.intValue ?? 0
                
                let levelRaw = data["jobLevel"] as? String ?? "Unknown"
                let level = JobLevel(rawValue: levelRaw)
                
                guard let jobLevel = level else {
                    print("Invalid job level: \(levelRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                let categoryRaw = data["jobCategory"] as? String ?? "Unknown"
                let category = CategoryJob(rawValue: categoryRaw)
                
                guard let jobCategory = category else {
                    print("Invalid job category: \(categoryRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                let city = data["jobLocation"] as? String ?? "Unknown"
                let employmentTypeRaw = data["jobEmploymentType"] as? String ?? "Unknown"
                let employmentType = EmploymentType(rawValue: employmentTypeRaw)
                
                guard let jobEmploymentType = employmentType else {
                    print("Invalid employment type: \(employmentTypeRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                if let datePosted = data["jobPostDate"] as? Timestamp {
                    let date = datePosted.dateValue() // Convert Timestamp to Date
                    let desc = data["jobDescription"] as? String ?? "Unknown"
                    
                    let deadline: Date?
                    if let deadlineTimestamp = data["jobDeadlineDate"] as? Timestamp {
                        deadline = deadlineTimestamp.dateValue()
                    } else {
                        deadline = nil
                    }
                    
                    let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                    
                    let extraAttachments = data["imageUrl"] as? String

                    
                    var job = Job(
                        jobId: jobId,
                        title: title,
                        companyDetails: nil,
                        level: jobLevel,
                        category: jobCategory,
                        employmentType: jobEmploymentType,
                        location: city,
                        deadline: deadline,
                        desc: desc,
                        requirement: requirement,
                        extraAttachments: extraAttachments,
                        date: date
                    )
                    
                    dispatchGroup.enter() // Start waiting for the company details
                    
                    // Fetch company details asynchronously
                    companyRef.getDocument { (companySnapshot, error) in
                        if let error = error {
                            print("Error fetching company details: \(error.localizedDescription)")
                            dispatchGroup.leave() // Leave the group if there's an error
                            return
                        }
                        
                        if let companyData = companySnapshot?.data() {
                            let companyName = companyData["name"] as? String ?? "Unknown"
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
                                    if userType == "admin" {
                                        // Set companyDetails to nil for admin
                                        job.companyDetails = nil
                                    } else if userType == "employer" {
                                        // Create companyDetails if employer
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
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    // Wait for all asynchronous fetches to complete
                    dispatchGroup.notify(queue: .main) {
                        self.originalJobs.append(job) // Also append to originalJobs
                        self.jobs.append(job)
                        self.jobPostCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    

}




/*class CustomFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)

        // Check if it's the last item in the section
        if let collectionView = self.collectionView {
            let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
            
            // If there's an odd number of items and this is the last item
            if itemCount % 2 != 0 && indexPath.item == itemCount - 1 {
                // Adjust the frame to align to the left
                attributes?.frame.origin.x = 0
            }
        }
        
        return attributes
    }

    override func prepare() {
        super.prepare()
        
        // Calculate the item size based on safe area insets
        guard let collectionView = self.collectionView else { return }
        
        let safeAreaInsets = collectionView.safeAreaInsets
        let availableWidth = collectionView.bounds.width - safeAreaInsets.left - safeAreaInsets.right

        // Set item width (you can adjust the height as needed)
        let itemWidth = availableWidth // Use the full width of the safe area
        let itemHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 260 : 220 // Adjust height for iPad

        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10) // Set your desired section insets
    }
 }
*/
