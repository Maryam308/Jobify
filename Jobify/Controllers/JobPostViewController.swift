//
//  JobPosViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit

class JobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    
    var jobs: [JobPost] = []  // Initialize jobs array here

    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Register cell
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        
        // Create and assign job posts to the jobs array
        jobs = createJobPosts()  // Populate jobs array
        
        // Reload collection view to reflect the changes
        jobPostCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        
        let jobPost = jobs[indexPath.row]
        
        // Configure the cell with job post data
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
    
    // Adjust the size of collection view cells dynamically (horizontal scroll)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 200)  // Adjust as needed
    }
}
