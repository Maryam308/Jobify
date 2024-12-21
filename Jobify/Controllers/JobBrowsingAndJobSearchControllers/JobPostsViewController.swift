import UIKit
import FirebaseFirestore

enum JobSource {
    case recentJobs
  
    case category(String) // Holds the category title
}

class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    var jobs: [Job] = [] // Array to hold job postings
    let db = Firestore.firestore() // Firestore instance
    
    // Property to hold the source of job postings
    var source: JobSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJobPostings() // Call to fetch from Firestore
        
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        // Register cell for job post
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Jobs count: \(self.jobs.count)")
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
        switch source {
        case .recentJobs:
            // Fetch recent job postings
            db.collection("jobPost").order(by: "datePosted", descending: true).getDocuments { (snapshot, error) in
                self.handleJobPostFetch(snapshot: snapshot, error: error)
            }
        case .category(let category):
            // Fetch job postings for a specific category
            db.collection("jobPost").whereField("jobCategory", isEqualTo: category).getDocuments { (snapshot, error) in
                self.handleJobPostFetch(snapshot: snapshot, error: error)
            }
        case .none:
            print("No source provided.")
        }
    }

    private func handleJobPostFetch(snapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("Error fetching job postings: \(error.localizedDescription)")
            return
        }
        
        guard let documents = snapshot?.documents else {
            print("No job postings found")
            return
        }
        
        print("Total documents fetched: \(documents.count)") // Log total documents
        
        // Clear existing jobs
        self.jobs.removeAll()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your format
        
        for document in documents {
            let data = document.data()
            print("Document data: \(data)") // Log each document's data
            
            if let title = data["jobTitle"] as? String {
                print("Processing job title: \(title)") // Log the title being processed
                
                let company = data["companyName"] as? String ?? "Unknown"
                let levelRaw = data["jobLevel"] as? String ?? "Unknown"
                let level = Job.JobLevel(rawValue: levelRaw)
                
                // Safely unwrap JobLevel
                guard let jobLevel = level else {
                    print("Invalid job level: \(levelRaw) for document ID: \(document.documentID)")
                    continue // Skip this document if level is invalid
                }
                
                let categoryRaw = data["jobCategory"] as? String ?? "Unknown"
                let category = Job.JobCategory(rawValue: categoryRaw)
                
                // Safely unwrap JobCategory
                guard let jobCategory = category else {
                    print("Invalid job category: \(categoryRaw) for document ID: \(document.documentID)")
                    continue // Skip this document if category is invalid
                }
                
                let employmentTypeRaw = data["jobEmploymentType"] as? String ?? "Unknown"
                let employmentType = Job.EmploymentType(rawValue: employmentTypeRaw)
                
                // Safely unwrap EmploymentType
                guard let jobEmploymentType = employmentType else {
                    print("Invalid employment type: \(employmentTypeRaw) for document ID: \(document.documentID)")
                    continue // Skip this document if employment type is invalid
                }
                
                let location = data["jobLocation"] as? String ?? "Unknown"
                let datePostedString = data["jobPostDate"] as? String ?? "Unknown"
                let timePostedString = data["jobPostTime"] as? String ?? "Unknown"
                let desc = data["jobDescription"] as? String ?? "Unknown"
                let deadlineString = data["jobDeadlineDate"] as? String ?? "Unknown"
                let deadline = dateFormatter.date(from: deadlineString)
                
                let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                
                let job = Job(
                    title: title,
                    company: company,
                    level: jobLevel,
                    category: jobCategory,
                    employmentType: jobEmploymentType,
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
                print("Failed to parse document: \(data) for document ID: \(document.documentID)") // Log if parsing fails
            }
        }
        
        print("Total valid jobs added: \(self.jobs.count)") // Log valid jobs added
        self.jobPostCollectionView.reloadData()
    }
}
