//
//  JobPosViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit

class HomeJobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var recentJobPostCollectionView: UICollectionView!
    
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
  
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            categoryCollectionView.collectionViewLayout = layout
        //horizontal job post
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        //job category
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        //vertical recent job post
        recentJobPostCollectionView.delegate = self
        recentJobPostCollectionView.dataSource = self
        
        // register cell for horizontal job post (recommended)
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
        // register cell for job category
        let categoryNib = UINib(nibName: JobsCollectionViewCellId, bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: JobsCollectionViewCellId)
        
        // register cell for vertical recent job post (recommended)
        let recentJobPostnib = UINib(nibName: recentJobPostCollectionViewCellId, bundle: nil)
        recentJobPostCollectionView.register(nib, forCellWithReuseIdentifier: recentJobPostCollectionViewCellId)
        
        
        jobPostCollectionView.reloadData()
    
       // categoryCollectionView.reloadData()
    }
    
    //MARK: - Handlers
    
    
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
            let width = collectionView.frame.width - 20 // Adjust padding as needed
            let height: CGFloat = 220 // Set your desired height
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
}




    
    

