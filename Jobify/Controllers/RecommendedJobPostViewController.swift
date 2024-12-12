//
//  RecommendedJobPostViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 11/12/2024.
//

import UIKit

class RecommendedJobPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
 
    
    var jobs: [JobPost] = []  // Initialize jobs array here

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        // Register cell
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
     
        
        jobs = createJobPosts()
        jobPostCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        
        let jobPost = jobs[indexPath.row]
        
        // fill the cell with job data
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
        return CGSize(width: collectionView.frame.width - 20, height: 200)
    }
    

 
    

    

}
