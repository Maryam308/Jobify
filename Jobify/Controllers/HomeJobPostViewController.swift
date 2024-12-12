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
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    let JobsCollectionViewCellId = "JobsCollectionViewCell"
    
    var jobs: [JobPost] = []  // Initialize jobs array here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            categoryCollectionView.collectionViewLayout = layout
        //horizontal job post
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        //job category
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        // register cell for horizontal job post (recommended)
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
        // register cell for job category
        let categoryNib = UINib(nibName: JobsCollectionViewCellId, bundle: nil)
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: JobsCollectionViewCellId)
        
        jobs = createJobPosts()
        jobPostCollectionView.reloadData()
       // categoryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == jobPostCollectionView {
            return jobs.count
        } else if collectionView == categoryCollectionView {
            return categories.count
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
        }
        
        return UICollectionViewCell()
    }
    
    // Adjust the size of collection view cells dynamically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == jobPostCollectionView {
            // Size for job post cells
            return CGSize(width: collectionView.frame.width - 20, height: 200)
        } else if collectionView == categoryCollectionView {
            // Size for category cells
            let padding: CGFloat = 10 // Adjust padding as needed
                    let totalSpacing = padding * 2 // Space for left and right edges

                    // Set the width to be smaller; adjust this value as needed
                    let width = (collectionView.bounds.width - totalSpacing) / 2 // For example, 3 cells in a row
                    let height: CGFloat = 140 // Set a smaller height for category cells
                    
            
                    return CGSize(width: width, height: height)
                    
                }
        
        return CGSize(width: 0, height: 0)
    }
    
}




    
    

