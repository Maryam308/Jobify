//
// HomeJobPostViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit
import FirebaseFirestore


class HomeJobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    struct JobTest {
        var imageTest: UIImage?
        var jobTestCompany: String
        var jobTesttitle: String
        
    }
    
    var testJobs = [
        JobTest(imageTest: UIImage(named: "Gulf Digital Group Logo") ?? UIImage(), jobTestCompany: "Job 1", jobTesttitle: "Programmer"),
        JobTest(imageTest: UIImage(named: "Gulf Digital Group Logo") ?? UIImage(), jobTestCompany: "Job 1", jobTesttitle: "Hacker"),
        JobTest(imageTest: UIImage(named: "Gulf Digital Group Logo") ?? UIImage(), jobTestCompany: "Job 1", jobTesttitle: "Programming")
    ]
    
    
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    
    @IBOutlet weak var homeStackView: NSLayoutConstraint!
    
    @IBOutlet weak var btnCreateNewJob: UIButton!
    
    @IBOutlet weak var btnMyJobPosts: UIButton!
    
    @IBOutlet weak var recommendedJobViewAllbtn: UIButton!
    
    @IBOutlet weak var recommendedJobView: UIView!
    
    @IBOutlet weak var recentJobTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var recommendedJobTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recommendedJobLabel: UILabel!
    
    @IBOutlet weak var recommendedJobCollectionHide: UICollectionView!
    
    @IBOutlet weak var categoryTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var recentJobView: UIView!
    
    
    @IBOutlet weak var recentJobPostCollectionView: UICollectionView!
    
    //search
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchOverlayView: UIView!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var filteredJobs: [Job] = []
    var allJobs: [Job] = [] // Array to hold all job postings for search
    
    
    @IBAction func viewAllRecommendedJobs(_ sender: Any) {
        let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
        if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
            jobPostsVC.source = .recommendedJobs
            navigationController?.pushViewController(jobPostsVC, animated: true)
        } else {
            print("Failed to instantiate JobPostsViewController")
        }
    }
    
    @IBAction func viewAllRecentJobs(_ sender: Any) {
        let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
        if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
            jobPostsVC.source = .recentJobs // Set the source to recent jobs
            navigationController?.pushViewController(jobPostsVC, animated: true)
        } else {
            print("Failed to instantiate JobPostsViewController")
        }
    }
    
    
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    let JobsCollectionViewCellId = "JobsCollectionViewCell"
    let recentJobPostCollectionViewCellId = "JobPostCollectionViewCell"
    
    
    
    @IBOutlet var mainHomeView: UIView!
    
    @IBOutlet weak var hamburgerView: UIView!
    
    var isHamburgerMenuOpen = false
    
    var recommendedJobs: [Job] = [] // Array to hold  recommended job postings
    var recentJobs: [Job] = [] // Array to hold recent job postings
    let db = Firestore.firestore() // Firestore instance
    
    private var dispatchGroup = DispatchGroup() // Declare the DispatchGroup as a property
    
    // 1. fetch all companies information
    // list of companies
    // function: getCompanyDetails(ref)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updated
        //mainHomeView.isHidden = true //because it will hide the view
        // hamburgerView.isHidden = true
        
        
        // Initially position the hamburgerView off-screen to the left
        hamburgerView.transform = CGAffineTransform(translationX: -hamburgerView.frame.width, y: 0)
        
        // Log the current frame of recommendedJobView
        print("Initial Category Top Constraint: \(categoryTopConstraint.constant)")
        print("Initial Recommended Job View Height: \(recommendedJobView.frame.height)")
        // hideRecommendedJobView()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        categoryCollectionView.collectionViewLayout = layout
        
        // Initially hide the overlay view and table view
        
        searchOverlayView.isHidden = true
        searchResultsTableView.isHidden = true
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false // Initially hide the cancel button
        searchBar.delegate = self
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        
        
        
        //horizontal job post
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        //job category
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        //vertical recent job post
        recentJobPostCollectionView.delegate = self
        recentJobPostCollectionView.dataSource = self
        
        fetchRecommendedJobs() // Fetch data from Firestore
        fetchRecentJobs()
        fetchAllJobs() // Fetch all jobs for search functionality
        
        //recent
        // register cell for horizontal job post (recommended)
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
        // register cell for job category
        let categoryNib = UINib(nibName: JobsCollectionViewCellId, bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: JobsCollectionViewCellId)
        
        // register cell for vertical recent job post (recommended)
        _ = UINib(nibName: recentJobPostCollectionViewCellId, bundle: nil)
        recentJobPostCollectionView.register(nib, forCellWithReuseIdentifier: recentJobPostCollectionViewCellId)
        
        
        // Initial reload and height update
        // jobPostCollectionView.reloadData()
        // recentJobPostCollectionView.reloadData()
        // updateParentViewHeight()
    }
    
    //MARK: - Handlers
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count // Return count of filtered jobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchJobsTableViewCell
        
        let testJob = filteredJobs[indexPath.row] // Use filtered jobs
        cell.imgCompany.image = nil // Set an image if available
        cell.lblCompanyName.text = testJob.companyDetails?.name ?? "By Jobify" // Use `testJob`
        cell.lblJobTitle.text = testJob.title // Use `testJob`
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchOverlayView.isHidden = false
        searchResultsTableView.isHidden = false
        searchBar.showsCancelButton = true // Show the cancel button
        // Make sure to reload data if needed
        //searchResultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchOverlayView.isHidden = true
        searchResultsTableView.isHidden = true
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder() // Dismiss keyboard and stop the cursor
        filteredJobs = allJobs // Reset to all jobs
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredJobs = allJobs // Reset to all jobs if search text is empty
        } else {
            filteredJobs = allJobs.filter { job in
                job.title.lowercased().contains(searchText.lowercased()) // Filter by job title
            }
        }
        searchResultsTableView.reloadData() // Reload the table view with filtered results
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false // Hide the cancel button when editing ends
    }
    
    
    /*func hideRecommendedJobView() {
     let recommendedJobHeight = recommendedJobView.frame.height
     recommendedJobTopConstraint.constant = 0 // Reset to zero
     categoryTopConstraint.constant -= recommendedJobHeight
     recommendedJobView.isHidden = true // Hide the recommended job view
     
     homeStackView.constant -= recommendedJobHeight
     
     UIView.animate(withDuration: 0.3) {
     self.view.layoutIfNeeded()
     self.updateScrollViewContentSize()
     }
     }*/
    
    
    private func updateParentViewHeight() {
        // Calculate the height for the recent job posts collection view
        let recentJobPostHeight = calculateCollectionViewHeight(for: recentJobPostCollectionView)
        
        // Log the height for debugging
        print("Recent Job Post Height: \(recentJobPostHeight)")
        
        // Get the heights of category and recommended job views
        let categoryViewHeight = categoryView.frame.height // Assuming this is set correctly
        let recommendedJobViewHeight = recommendedJobView.frame.height // Assuming this is set correctly
        
        // Log the heights for debugging
        print("Category View Height: \(categoryViewHeight)")
        print("Recommended Job View Height: \(recommendedJobViewHeight)")
        
        // Calculate the total height for the stack view
        homeStackView.constant = categoryViewHeight + recommendedJobViewHeight + recentJobPostHeight
        //commented
        // Log the total height for debugging
        print("Total Stack View Height: \(homeStackView.constant)")
        
        // Animate the height change
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func calculateCollectionViewHeight(for collectionView: UICollectionView) -> CGFloat {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        print("Number of Recent Job Items: \(numberOfItems)") // Log the count
        
        let itemHeight: CGFloat = 220 // Adjust based on your cell height
        let spacing: CGFloat = 10 // Space between items
        
        // Calculate total height (spacing only between items)
        let totalHeight = (itemHeight * CGFloat(numberOfItems)) + (spacing * max(0, CGFloat(numberOfItems - 1)))
        print("Calculated Total Height for Recent Job Posts: \(totalHeight)") // Log the calculated height
        
        return max(totalHeight, 0) // Ensure non-negative height
    }
    
    func hideRecommendedJobView() {
        // Calculate the total height for the recommended job view based on the buttons
        let recommendedJobHeight = recommendedJobView.frame.height
        recommendedJobTopConstraint.constant = 0
        let buttonHeight = btnCreateNewJob.frame.height + btnMyJobPosts.frame.height + 20 // Add spacing
        recommendedJobTopConstraint.constant = buttonHeight
        // Adjust the top constraint for the category collection view
        categoryTopConstraint.constant -= recommendedJobHeight
        
        // Ensure category view layout is updated
        categoryCollectionView.layoutIfNeeded()
        let categoryViewHeight = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        categoryTopConstraint.constant += categoryViewHeight // Add the height of the category view
        
        
        // Show the buttons
        btnCreateNewJob.isHidden = false
        btnMyJobPosts.isHidden = false
        
        // Hide the recommended label, button, and collection view
        recommendedJobLabel.isHidden = true
        recommendedJobViewAllbtn.isHidden = true
        recommendedJobCollectionHide.isHidden = true
        
        let recentJobViewHeight = recentJobPostCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        // Set the home stack view height directly based on visible components
        homeStackView.constant -= buttonHeight + categoryViewHeight + recentJobViewHeight + 100 // Total height with spacing
        
        
        
        
        // Animate the layout changes
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.updateScrollViewContentSize()
        }
        
    }
    
    func updateScrollViewContentSize() {
        // Update the scroll view's content size based on the total height of the stack view
        let totalHeight = homeStackView.constant + homeScrollView.frame.origin.y
        homeScrollView.contentSize = CGSize(width: homeScrollView.frame.width, height: totalHeight)
    }
    
    
    
    @IBAction func showHamburgerMenu(_ sender: Any) {
        // Check if the search bar is being edited
        if searchBar.isFirstResponder {
            // Dismiss the keyboard and return early
            searchBar.resignFirstResponder()
            searchOverlayView.isHidden = false  // Hide the overlay
            searchResultsTableView.isHidden = false  // Hide the search results
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            if self.isHamburgerMenuOpen {
                // Slide out (to the left)
                self.hamburgerView.transform = CGAffineTransform(translationX: -self.hamburgerView.frame.width, y: 0)
            } else {
                // Slide in (to the right)
                self.hamburgerView.transform = .identity
            }
        }
        
        // Toggle state
        isHamburgerMenuOpen.toggle()
    }
    
    
    
    
    
    //Recommended Jobs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == jobPostCollectionView {
            return recommendedJobs.count
        } else if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == recentJobPostCollectionView {
            return recentJobs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == jobPostCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
            let job = recommendedJobs[indexPath.row]
            
            configureJobPostCell(cell, with: job)
            return cell
            
        } else if collectionView == categoryCollectionView {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: JobsCollectionViewCellId, for: indexPath) as! JobsCollectionViewCell
            // Populate information from the categories
            categoryCell.setUp(category: categories[indexPath.row])
            return categoryCell
        } else if collectionView == recentJobPostCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentJobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
            
            let job = recentJobs[indexPath.row]
            
            configureJobPostCell(cell, with: job)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func configureJobPostCell(_ cell: JobPostCollectionViewCell, with job: Job) {
        // Configure the cell with job data
        cell.jobPostImageView.image = nil // Set image if available
        cell.jobPostTimelbl.text = job.time
        cell.jobPostTitlelbl.text = job.companyDetails?.name ?? "No Company"
        
        
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
    }
    
    // Adjust the size of collection view cells dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == jobPostCollectionView {
            // Size for job post cells
            return CGSize(width: collectionView.frame.width , height: 220)
        } else if collectionView == categoryCollectionView {
            // Size for category cells
            let padding: CGFloat = 10 // Adjust padding as needed
            let totalSpacing = padding * 2 // Space for left and right edges
            
            // Set the width to be smaller; adjust this value as needed
            let width = (collectionView.bounds.width - totalSpacing) / 2 // For example, 3 cells in a row
            let height: CGFloat = 140 // Set a smaller height for category cells
            
            
            return CGSize(width: width, height: height)
            
        } else if collectionView == recentJobPostCollectionView {
            let collectionViewWidth = collectionView.bounds.width
            let spacing: CGFloat = 10 // Adjust the spacing
            let columns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1 // 2 columns for iPad, 1 for iPhone
            
            // Calculate the width of each cell
            let cellWidth = (collectionViewWidth - (columns - 1) * spacing) / columns
            return CGSize(width: cellWidth, height: 220) // Set appropriate height
        }
        
        
        return CGSize(width: 0, height: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Example spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Example spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Insets for iPad
            return UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 30)
        } else {
            // Insets for iPhone
            return UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 20)
        }
    }
    
    
    //  did select category
    // didSelectItemAt for categoryCollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let selectedCategory = categories[indexPath.row].title
            
            let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
            if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
                jobPostsVC.source = .category(selectedCategory) // Pass the selected category
                navigationController?.pushViewController(jobPostsVC, animated: true)
            }
        }
    }
    
    //for search table view
    private func fetchAllJobs() {
        db.collection("jobPost")
            .order(by: "jobPostDate", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return } // Ensure 'self' is not nil
                
                if let error = error {
                    print("Error fetching all jobs: \(error.localizedDescription)")
                    return
                }
                // Now use 'self' to call handleJobPostFetch
                self.handleJobPostFetch(snapshot: snapshot) { jobs in
                    // Once the fetch is complete, use the 'jobs' array
                    print("Fetched \(jobs.count) jobs.")
                    
                    // Update the UI with the fetched jobs
                    self.allJobs = jobs
                    self.jobPostCollectionView.reloadData()
                    self.recentJobPostCollectionView.reloadData()
                    self.updateParentViewHeight()
                }
            }
    }
    
    private func fetchRecommendedJobs() {
        db.collection("jobPost")
            .order(by: "jobPostDate", descending: false)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching recommended jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot) { jobs in
                    print("Fetched \(jobs.count) jobs.")
                    
                    self.recommendedJobs = jobs
                    self.jobPostCollectionView.reloadData()
                    self.recentJobPostCollectionView.reloadData()
                    self.updateParentViewHeight()
                }
            }
    }
    
    private func fetchRecentJobs() {
        db.collection("jobPost")
            .order(by: "jobPostDate", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching recent jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot) { jobs in
                    print("Fetched \(jobs.count) jobs.")
                    
                    self.recentJobs = jobs
                    self.jobPostCollectionView.reloadData()
                    self.recentJobPostCollectionView.reloadData()
                    self.updateParentViewHeight()
                }
            }
    }
    
    
    
    
    
    private func handleJobPostFetch(snapshot: QuerySnapshot?, completion: @escaping ([Job]) -> Void) {
        var jobs: [Job] = []
        
        guard let documents = snapshot?.documents else {
            print("No job postings found")
            completion(jobs) // Return an empty array if no documents
            return
        }
        
        let dispatchGroup = DispatchGroup() // To wait for asynchronous fetches
        
        for document in documents {
            let data = document.data()
            
            guard let title = data["jobTitle"] as? String,
                  let companyRef = data["companyRef"] as? DocumentReference else {
                continue
            }
            
            let jobId = (data["jobPostId"] as? NSNumber)?.intValue ?? 0
            
            guard let levelRaw = data["jobLevel"] as? String,
                  let level = JobLevel(rawValue: levelRaw) else {
                print("Invalid job level for document ID: \(document.documentID)")
                continue
            }
            
            guard let categoryRaw = data["jobCategory"] as? String,
                  let category = CategoryJob(rawValue: categoryRaw) else {
                print("Invalid job category for document ID: \(document.documentID)")
                continue
            }
            
            let city = data["jobLocation"] as? String ?? "Unknown"
            
            guard let employmentTypeRaw = data["jobEmploymentType"] as? String,
                  let employmentType = EmploymentType(rawValue: employmentTypeRaw) else {
                print("Invalid employment type for document ID: \(document.documentID)")
                continue
            }
            
            if let datePosted = data["jobPostDate"] as? Timestamp {
                let date = datePosted.dateValue() // Convert Timestamp to Date
                let timePostedString = data["jobPostTime"] as? String ?? "Unknown"
                let desc = data["jobDescription"] as? String ?? "Unknown"
                let deadline = (data["jobDeadlineDate"] as? Timestamp)?.dateValue()
                let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                
                var job = Job(
                    jobId: jobId,
                    title: title,
                    companyDetails: nil,
                    level: level,
                    category: category,
                    employmentType: employmentType,
                    location: city,
                    deadline: deadline,
                    desc: desc,
                    requirement: requirement,
                    extraAttachments: nil,
                    date: date,
                    time: timePostedString
                )
                
                dispatchGroup.enter() // Start waiting for company details
                
                companyRef.getDocument { (companySnapshot, error) in
                    if let error = error {
                        print("Error fetching company details: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    if let companyData = companySnapshot?.data() {
                        let companyName = companyData["name"] as? String ?? "Unknown"
                        let userId = companyData["userId"] as? Int ?? 0
                        let email = companyData["email"] as? String ?? "Unknown"
                        let city = companyData["city"] as? String ?? "Unknown"
                        
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
                    
                    jobs.append(job) // Append the job to the list after fetching company details
                    dispatchGroup.leave() // Done fetching company details
                }
            }
            
            // Notify when all async operations are complete
            dispatchGroup.notify(queue: .main) {
                completion(jobs) // Send the jobs array back using the completion handler
            }
        }
        
    }
}
