import UIKit
import FirebaseFirestore

class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    var jobs: [Job] = [] // Array to hold job postings
    let db = Firestore.firestore() // Firestore instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        // Register cell for job post
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
        
        fetchJobPostings() // Call to fetch from Firestore
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        let job = jobs[indexPath.row]
        
        // Fill the cell with job data
        cell.jobPostImageView.image = nil // Ensure this property is handled correctly
        cell.jobPostTimelbl.text = job.time
        cell.jobPostTitlelbl.text = job.company
        cell.jobPostDatelbl.text = job.date
        cell.jobPostLevellbl.setTitle(job.level.rawValue, for: .normal)
        cell.jobPostEnrollmentTypelbl.setTitle(job.employmentType.rawValue, for: .normal)
        cell.jobPostCategorylbl.setTitle(job.category.rawValue, for: .normal)
        cell.joPostLocationlbl.setTitle(job.location, for: .normal)
        cell.jobPostDescriptionTitlelbl.text = job.title
        cell.jobPostDescriptionlbl.text = job.desc
        
        return cell
    }
    
    func fetchJobPostings() {
        print("Fetching job postings...")
        db.collection("jobPost").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching job postings: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No job postings found")
                return
            }
            
            print("Documents fetched: \(documents.count)")
            
            // Clear existing jobs
            self.jobs.removeAll()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your format
            
            for document in documents {
                let data = document.data()
                print("Document data: \(data)") // Log each document's data
                
                if let title = data["jobTitle"] as? String,
                   let company = data["companyName"] as? String,
                   let levelRaw = data["jobLevel"] as? String,
                   let level = Job.JobLevel(rawValue: levelRaw),
                   let categoryRaw = data["jobCategory"] as? String,
                   let category = Job.JobCategory(rawValue: categoryRaw),
                   let employmentTypeRaw = data["jobEmploymentType"] as? String,
                   let employmentType = Job.EmploymentType(rawValue: employmentTypeRaw),
                   let location = data["jobLocation"] as? String,
                   let datePostedString = data["jobPostDate"] as? String,
                   let timePostedString = data["jobPostTime"] as? String,
                   let desc = data["jobDescription"] as? String,
                   let deadlineString = data["jobDeadlineDate"] as? String,
                   let deadline = dateFormatter.date(from: deadlineString) { // Use the custom date formatter
                    
                    let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                    
                    let job = Job(
                        title: title,
                        company: company,
                        level: level,
                        category: category,
                        employmentType: employmentType,
                        location: location,
                        deadline: deadline,
                        desc: desc,
                        requirement: requirement,
                        extraAttachments: nil,
                        date: datePostedString,
                        time: timePostedString
                    )
                    
                    self.jobs.append(job) // Append the job to the jobs array
                } else {
                    print("Failed to parse document: \(data)") // Log if parsing fails
                }
            }
            
            DispatchQueue.main.async {
                print("Jobs array count before reload: \(self.jobs.count)")
                self.jobPostCollectionView.reloadData() // Reload collection view with fetched jobs
            }
        }
    }
}
