//
//  JobPostsViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        // register cell for  job post
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
        
        jobPostCollectionView.reloadData()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return jobs.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    // Set the size for the collection view cells
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = collectionView.frame.width - 20 // Adjust padding as needed
           let height: CGFloat = 220 // Set your desired height
           return CGSize(width: width, height: height)
       }
}
