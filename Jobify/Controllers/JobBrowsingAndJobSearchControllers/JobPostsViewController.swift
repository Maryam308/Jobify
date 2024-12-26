
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


class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterViewControllerDelegate, SortViewController.SortViewControllerDelegate {
    
    func didApplyFilters(_ filters: [String : [String]]) {
        // Apply filters only on the already fetched job list (self.jobs)
        filteredJobPosts = self.originalJobs.filter { job in
            let matchesLevel = filters["Level"]?.isEmpty ?? true || filters["Level"]?.contains(job.level.rawValue) ?? false
            let matchesEmploymentType = filters["Employment Type"]?.isEmpty ?? true || filters["Employment Type"]?.contains(job.employmentType.rawValue) ?? false
            let matchesCategory = filters["Category"]?.isEmpty ?? true || filters["Category"]?.contains(job.category.rawValue) ?? false
            let matchesCompany = filters["Company"]?.isEmpty ?? true || filters["Company"]?.contains(job.companyDetails?.name ?? "By Jobify") ?? false
            let matchesLocation = filters["Location"]?.isEmpty ?? true || filters["Location"]?.contains(job.location) ?? false
            
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
  
    
   
        var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 7
        var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "seeker"
        let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
        var currentSortOrder: SortOrder? = .newestToOldest // Set default sort order
        var originalJobs: [Job] = [] // hold original job to allow repeated filtering
        var jobs: [Job] = [] // Array to hold job postings
        var filteredJobPosts: [Job] = [] // Filtered results
        let db = Firestore.firestore() // Firestore instance
        
        var source: JobSource?
        var selectedJob: Job?
    
        private let showJobDetailsSegueIdentifier = "showJobDetails"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up your custom collection view layout
                //let layout = CustomFlowLayout()
               // jobPostCollectionView.collectionViewLayout = layout
            
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

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Ensure the tab bar is visible when leaving this controller
           self.tabBarController?.tabBar.isHidden = false
       }
 
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        let job = jobs[indexPath.row]
        
        // Configure the cell with job data
        cell.jobPostImageView.image = nil

        cell.jobPostTimelbl.text = nil
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
        
        return cell
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
            db.collection("jobPost").order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
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
            db.collection("jobPost").order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching recommended jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot, error: nil)
            }
        case nil:
            print("No source provided.")
        }
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
                        extraAttachments: nil,
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
 }*/
