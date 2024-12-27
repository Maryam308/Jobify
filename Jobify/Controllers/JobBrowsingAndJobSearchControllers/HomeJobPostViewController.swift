//
// HomeJobPostViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit
import FirebaseFirestore


class HomeJobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeStackView: NSLayoutConstraint!
    @IBOutlet weak var recommendedJobViewAllbtn: UIButton!
    @IBOutlet weak var recommendedJobView: UIView!
    @IBOutlet weak var recentJobTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var recommendedJobTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var recommendedJobLabel: UILabel!
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
    
    @IBOutlet weak var btnCreateNewJob: UIButton!
    
    @IBOutlet weak var btnMyJobPosts: UIButton!
    
    
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
    
    // this has been  updated
    @IBAction func viewMyJobPosts(_ sender: Any) {
            let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
            if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
                jobPostsVC.source = .myJobPosts // Set the source to my job posts
                navigationController?.pushViewController(jobPostsVC, animated: true)
            } else {
                print("Failed to instantiate JobPostsViewController for My job posts")
            }
    }
    
    
    
    @IBAction func createJobPosts(_ sender: Any) {
        // Get a reference to the storyboard by its name
            let storyboard = UIStoryboard(name: "EmployerJobPostingAndEmployerApplicantInteraction_MaryamAhmed", bundle: nil)

        // Instantiate the view controller by its identifier

        if let viewController = storyboard.instantiateViewController(withIdentifier: "JobPostCreation") as? JopPostCreationFirstScreenViewController {
            // Navigate to the target view controller

            self.navigationController?.pushViewController(viewController, animated: true)

            } else { print("Error: Could not find view controller with identifier 'TargetViewControllerIdentifier'") }
    }
    
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    let JobsCollectionViewCellId = "JobsCollectionViewCell"
    let recentJobPostCollectionViewCellId = "JobPostCollectionViewCell"
    
    
    
    @IBOutlet var mainHomeView: UIView!
    
    @IBOutlet weak var hamburgerView: UIView!
    
    var isHamburgerMenuOpen = false
    
    var currentUserId: Int = UserSession.shared.loggedInUser?.userID ?? 1
    var currentUserRole: String = UserSession.shared.loggedInUser?.role.rawValue ?? "admin"
    
    var recommendedJobs: [Job] = [] // Array to hold  recommended job postings
    var recentJobs: [Job] = [] // Array to hold recent job postings
    let db = Firestore.firestore() // Firestore instance
    
   // private var dispatchGroup = DispatchGroup() // Declare the DispatchGroup as a property
    let currentTimestamp = Timestamp(date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        if(currentUserRole == "employer" || currentUserRole  == "admin"){
            hideRecommendedJobView()
            fetchRecentJobs()
            fetchAllJobs() // Fetch all jobs for search functionality
            roundButtons()
           
        } else if(currentUserRole == "jobseeker") {
            // Hide the buttons
            btnCreateNewJob.isHidden = true
            btnMyJobPosts.isHidden = true
            fetchRecommendedJobs() // Fetch data from Firestore
            fetchRecentJobs()
            fetchAllJobs() // Fetch all jobs for search functionality
            
        }
  
        // Initially position the hamburgerView off-screen to the left
        hamburgerView.transform = CGAffineTransform(translationX: -hamburgerView.frame.width, y: 0)
        
        // Log the current frame of recommendedJobView
        print("Initial Category Top Constraint: \(categoryTopConstraint.constant)")
        print("Initial Recommended Job View Height: \(recommendedJobView.frame.height)")
         
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         if(currentUserRole == "employer" || currentUserRole  == "admin"){
             fetchRecentJobs()
             fetchAllJobs() // Fetch all jobs for search functionality
             roundButtons()
         } else if currentUserRole == "seeker" {
             // Hide the buttons
             btnCreateNewJob.isHidden = true
             btnMyJobPosts.isHidden = true
             fetchRecommendedJobs() // Fetch data from Firestore
             fetchRecentJobs()
             fetchAllJobs() // Fetch all jobs for search functionality
             
         }
        self.tabBarController?.tabBar.isHidden = false
        searchOverlayView.isHidden = true
        searchResultsTableView.isHidden = true
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
   
    // Function to round buttons
       private func roundButtons() {
           let cornerRadius: CGFloat = 10.0 // Adjust the value as needed
           
           btnCreateNewJob.layer.cornerRadius = cornerRadius
           btnCreateNewJob.clipsToBounds = true
           
           btnMyJobPosts.layer.cornerRadius = cornerRadius
           btnMyJobPosts.clipsToBounds = true
       }
   
        
    //MARK: - Handlers
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count // Return count of filtered jobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchJobsTableViewCell
        
        let testJob = filteredJobs[indexPath.row] // Use filtered jobs
        
        // Load profile picture
        if let imageURLString = UserSession.shared.loggedInUser?.imageURL,
           let imageURL = URL(string: imageURLString) {
                loadImage(from: imageURL, into: cell.imgCompany)
        } else {
            // Use a system-provided placeholder image
            cell.imgCompany.image = UIImage(systemName: "person.fill") // Placeholder for profile picture
            
            // Set clipsToBounds to false when no image is present
                cell.imgCompany.layer.cornerRadius = 0 // Reset corner radius
                cell.imgCompany.clipsToBounds = false // Disable clipping

        }
        
        cell.lblCompanyName.text = testJob.companyDetails?.name ?? "By Jobify" // Use `testJob`
        cell.lblJobTitle.text = testJob.title // Use `testJob`
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected job from the filtered jobs
        let selectedJob = filteredJobs[indexPath.row]
        
        // Load the storyboard containing JobDetailsTableViewController
        let storyboard = UIStoryboard(name: "JobDetailsAndJobRecommendations_FatimaKhamis", bundle: nil) // Ensure this matches your storyboard name
        if let jobDetailsVC = storyboard.instantiateViewController(withIdentifier: "showJobDetails") as? JobDetailsTableViewController { // Use the correct storyboard ID
            jobDetailsVC.job = selectedJob // Pass the selected job to the JobDetailsTableViewController
            
            // Push the JobDetailsTableViewController onto the navigation stack
            navigationController?.pushViewController(jobDetailsVC, animated: true)
        } else {
            print("Failed to instantiate JobDetailsTableViewController")
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchOverlayView.isHidden = false
        searchResultsTableView.isHidden = false
        searchBar.showsCancelButton = true // Show the cancel button
        
        // Hide the tab bar
           self.tabBarController?.tabBar.isHidden = true
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
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // Dismiss the keyboard
            searchBar.resignFirstResponder()

            // Navigate to JobPostsViewController
            navigateToJobPosts()
        }

        func navigateToJobPosts() {
            let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
            if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
                if let searchText = searchBar.text, !searchText.isEmpty {
                    // Filter jobs based on search text
                    filteredJobs = allJobs.filter { job in
                        job.title.lowercased().contains(searchText.lowercased())
                    }
                    jobPostsVC.jobs = filteredJobs// Pass the filtered jobs
                    jobPostsVC.originalJobs = filteredJobs
                } else {
                    jobPostsVC.jobs = allJobs // Pass all jobs if nothing is typed
                    jobPostsVC.originalJobs = allJobs
                }
                navigationController?.pushViewController(jobPostsVC, animated: true)
            } else {
                print("Failed to instantiate JobPostsViewController")
            }
        }
    
    
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
        jobPostCollectionView.isHidden = true
        
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
            return min(categories.count, 5) // Limit to a maximum of 5 cells
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
            // Handle category selection
            let selectedCategory = categories[indexPath.row].title
            let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
            if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
                jobPostsVC.source = .category(selectedCategory) // Pass the selected category
                navigationController?.pushViewController(jobPostsVC, animated: true)
            } else {
                print("Failed to instantiate JobPostsViewController")
            }
        } else {
            // Handle job selection for recommended or recent jobs
            var selectedJob: Job?

            if collectionView == jobPostCollectionView {
                selectedJob = recommendedJobs[indexPath.item]
            } else if collectionView == recentJobPostCollectionView {
                selectedJob = recentJobs[indexPath.item]
            }

            // Navigate to JobDetails if a job was selected
            if selectedJob != nil {
                // Load the storyboard containing JobDetailsTableViewController
                let storyboard = UIStoryboard(name: "JobDetailsAndJobRecommendations_FatimaKhamis", bundle: nil) // Ensure this matches your storyboard name
                if let jobDetailsVC = storyboard.instantiateViewController(withIdentifier: "showJobDetails") as? JobDetailsTableViewController { // Use the correct storyboard ID
                    jobDetailsVC.job = selectedJob
                    navigationController?.pushViewController(jobDetailsVC, animated: true)
                } else {
                    print("Failed to instantiate JobDetailsViewController")
                }
            }
        }
    }
   
    
    //for search table view
    private func fetchAllJobs() {
        db.collection("jobPost").whereField("jobDeadlineDate", isGreaterThanOrEqualTo: currentTimestamp) .order(by: "jobPostDate", descending: true)
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
            db.collection("jobPost").whereField("jobDeadlineDate", isGreaterThanOrEqualTo: currentTimestamp)
                .whereField("jobCategory", isEqualTo: category).order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
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
            self.recommendedJobs = recommendedJobs
            self.jobPostCollectionView.reloadData()
            self.recentJobPostCollectionView.reloadData()
            self.updateParentViewHeight()
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
        
        // Extract extra attachments as a regular string, defaulting to nil if not present
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



   
    
    private func fetchRecentJobs() {
        db.collection("jobPost").whereField("jobDeadlineDate", isGreaterThanOrEqualTo: currentTimestamp).order(by: "jobPostDate", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching recent jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot) { jobs in
                    print("Fetched \(jobs.count) jobs.")
                    
                    self.recentJobs = jobs
                   // self.jobPostCollectionView.reloadData()
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
                let desc = data["jobDescription"] as? String ?? "Unknown"
                let deadline = (data["jobDeadlineDate"] as? Timestamp)?.dateValue()
                let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                
                let extraAttachments = data["imageUrl"] as? String

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
                    extraAttachments: extraAttachments,
                    date: date
                )
                
                dispatchGroup.enter() // Start waiting for company details
                
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
                                if userType == "admin" || userId == 1 {
                                    // Set companyDetails to nil for admin or userId == 1
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
                            
                            // Append the job after all async fetches are completed
                            jobs.append(job)
                            dispatchGroup.leave() // Done fetching user and company details
                        }
                    } else {
                        print("Company data not found for document ID: \(document.documentID)")
                        dispatchGroup.leave() // If company data is missing, leave the group
                    }
                }
            }
        }
        
        // Notify when all async operations are complete
        dispatchGroup.notify(queue: .main) {
            if jobs.isEmpty {
                print("No jobs were fetched.")
            } else {
                print("Successfully fetched \(jobs.count) job postings.")
            }
            completion(jobs) // Send the jobs array back using the completion handler
        }
    }


}

class CustomFlowLayout: UICollectionViewFlowLayout {
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
