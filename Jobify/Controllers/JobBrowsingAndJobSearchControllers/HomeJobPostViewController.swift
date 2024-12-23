//
//  JobPosViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit

class HomeJobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchOverlayView: UIView!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    
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
        // Set up your initial view
              // recommendedJobCollectionHide.isHidden = false
              //  recommendedJobView.isHidden = false
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
           jobPostCollectionView.reloadData()
           recentJobPostCollectionView.reloadData()
           updateParentViewHeight()
    }
    
    //MARK: - Handlers
    
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchOverlayView.isHidden = false
        searchResultsTableView.isHidden = false
        searchBar.showsCancelButton = true // Show the cancel button
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchOverlayView.isHidden = true
        searchResultsTableView.isHidden = true
        searchBar.text = "" // Clear search text
        searchBar.showsCancelButton = false // Hide the cancel button
        view.endEditing(true) // Dismiss keyboard
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false // Hide the cancel button when editing ends
    }


    
    
    @IBAction func showHamburgerMenu(_ sender: Any) {
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
            return jobs.count
        } else if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == recentJobPostCollectionView {
            return jobs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == jobPostCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
                   let jobPost = jobs[indexPath.row]
                   
                   // Fill the cell with job data
                   cell.jobPostImageView.image = jobPost.image
                   cell.jobPostTimelbl.text = jobPost.time
                   cell.jobPostTitlelbl.text = jobPost.title
                   cell.jobPostDatelbl.text = jobPost.date
                   cell.jobPostLevellbl.setTitle(jobPost.level, for: .normal)
                   cell.jobPostEnrollmentTypelbl.setTitle(jobPost.enrollmentType, for: .normal)
                   cell.jobPostCategorylbl.setTitle(jobPost.category, for: .normal)
                   cell.joPostLocationlbl.setTitle(jobPost.location, for: .normal)
                   cell.jobPostDescriptionTitlelbl.text = jobPost.description
                   cell.jobPostDescriptionlbl.text = jobPost.jobDescription
                   
                   return cell
        } else if collectionView == categoryCollectionView {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: JobsCollectionViewCellId, for: indexPath) as! JobsCollectionViewCell
            // Populate information from the categories
            categoryCell.setUp(category: categories[indexPath.row])
            return categoryCell
        } else if collectionView == recentJobPostCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentJobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
                   let jobPost = jobs[indexPath.row]
                   
                   // Fill the cell with job data
                   cell.jobPostImageView.image = jobPost.image
                   cell.jobPostTimelbl.text = jobPost.time
                   cell.jobPostTitlelbl.text = jobPost.title
                   cell.jobPostDatelbl.text = jobPost.date
                   cell.jobPostLevellbl.setTitle(jobPost.level, for: .normal)
                   cell.jobPostEnrollmentTypelbl.setTitle(jobPost.enrollmentType, for: .normal)
                   cell.jobPostCategorylbl.setTitle(jobPost.category, for: .normal)
                   cell.joPostLocationlbl.setTitle(jobPost.location, for: .normal)
                   cell.jobPostDescriptionTitlelbl.text = jobPost.description
                   cell.jobPostDescriptionlbl.text = jobPost.jobDescription
                   
                   return cell
        }
        
        return UICollectionViewCell()
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
            let spacing: CGFloat = 0
            let columns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1 // 2 columns for iPad, 1 column for iPhone
            
            // Calculate the width of each cell
            let cellWidth = (collectionViewWidth - spacing) / columns
            let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 260 : 220 // Adjust height for iPad

            return CGSize(width: cellWidth, height: cellHeight)
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
}

    





    
    

