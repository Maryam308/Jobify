//
//  JobPosCollectionViewCell.swift
//  Jobify
//
//  Created by Fatima Ali on 10/12/2024.
//

import UIKit
import FirebaseFirestore

protocol CellActionDelegate: AnyObject {
func confirmDelete(forJobPostId: Int)

 }

class JobPostCollectionViewCell: UICollectionViewCell {
    
    /*protocol JobPostCellDelegate: AnyObject {
        func didTapDeleteButton(jobId: String)
    }*/
    
    @IBOutlet weak var jobPostView: UIView!
  
    weak var delegate: CellActionDelegate?
    
    @IBOutlet weak var jobPostImageView: UIImageView!
    @IBOutlet weak var jobPostTimelbl: UILabel!
    @IBOutlet weak var jobPostTitlelbl: UILabel!
    @IBOutlet weak var jobPostDatelbl: UILabel!
    @IBOutlet weak var jobPostLevellbl: UIButton!
    @IBOutlet weak var jobPostEnrollmentTypelbl: UIButton!
    @IBOutlet weak var jobPostCategorylbl: UIButton!
    @IBOutlet weak var joPostLocationlbl: UIButton!
    @IBOutlet weak var jobPostDescriptionTitlelbl: UILabel!
    @IBOutlet weak var jobPostDescriptionlbl: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let jobPostId = jobPostId else { return }

        delegate?.confirmDelete(forJobPostId: jobPostId)
    }
    
    func deleteJobPost(jobPostId: Int) {
            // Reference to the jobPost collection
            let jobPostCollection = db.collection("jobPost")
            
            // Query for the document with the matching jobPostId
            jobPostCollection.whereField("jobPostId", isEqualTo: jobPostId)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error finding job post: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let document = snapshot?.documents.first else {
                        print("No job post found with the provided ID.")
                        return
                    }
                    
                    // Delete the document
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting job post: \(error.localizedDescription)")
                        } else {
                            print("Job post successfully deleted.")
                        }
                    }
                }
        }
    
         
    
    var jobPostId : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Example of setting up a view layout
        jobPostView.layer.cornerRadius = 9
        jobPostView.layer.masksToBounds = true
        
        //round the image view corners
        jobPostImageView.layer.cornerRadius = jobPostImageView.frame.size.width / 2
        jobPostImageView.layer.masksToBounds = true

        // Create an array of labels
            let labels = [jobPostLevellbl, jobPostEnrollmentTypelbl, jobPostCategorylbl, joPostLocationlbl]
            
            // Set corner radius and masks to bounds for each button
            for label in labels {
                if let label = label {
                    label.layer.cornerRadius = label.frame.size.height / 2
                    label.layer.masksToBounds = true
                }
            }
        
        let cornerRadius: CGFloat = 10.0 // Adjust the value as needed
                
        btnDelete.layer.cornerRadius = cornerRadius
        btnDelete.clipsToBounds = true

    }
 
}
