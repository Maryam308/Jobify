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
        
        // Convert the datePosted to a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Adjust as needed
        dateFormatter.timeStyle = .none // Set to .short if you want to include time

        // Format the job's datePosted
        cell.jobPostDatelbl.text = dateFormatter.string(from: job.date) // Use job.date for datePosted
        
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
            db.collection("jobPost").order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching recent jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot, error: nil)
            }
        case .category(let category):
            db.collection("jobPost")
                .whereField("jobCategory", isEqualTo: category)
                .order(by: "jobPostDate", descending: true)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching jobs for category \(category): \(error.localizedDescription)")
                        return
                    }
                    self.handleJobPostFetch(snapshot: snapshot, error: nil)
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
        
        // Initialize DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust according to your format if needed
        
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
                
                // Retrieve the timestamp for jobPostDate
                if let datePosted = data["jobPostDate"] as? Timestamp {
                    let date = datePosted.dateValue() // Convert Timestamp to Date
                    let timePostedString = data["jobPostTime"] as? String ?? "Unknown"
                    let desc = data["jobDescription"] as? String ?? "Unknown"
                    
                    // Retrieve the deadline as Timestamp
                    let deadline: Date?
                    if let deadlineTimestamp = data["jobDeadlineDate"] as? Timestamp {
                        deadline = deadlineTimestamp.dateValue() // Convert Timestamp to Date
                    } else {
                        deadline = nil // Handle as optional if not present
                    }
                    
                    let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                    
                    let job = Job(
                        title: title,
                        company: company,
                        level: jobLevel,
                        category: jobCategory,
                        employmentType: jobEmploymentType,
                        location: location,
                        deadline: deadline, // Use Date type for deadline
                        desc: desc,
                        requirement: requirement,
                        extraAttachments: nil,
                        date: date, // Use Date type for job post date
                        time: timePostedString
                    )
                    
                    self.jobs.append(job) // Append the job to the jobs array
                } else {
                    print("Failed to parse date for document ID: \(document.documentID)")
                }
            } else {
                print("Failed to parse document: \(data) for document ID: \(document.documentID)") // Log if parsing fails
            }
        }
        
        print("Total valid jobs added: \(self.jobs.count)") // Log valid jobs added
        self.jobPostCollectionView.reloadData()
    }
}
