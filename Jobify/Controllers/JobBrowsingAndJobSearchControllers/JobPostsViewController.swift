import UIKit
import FirebaseFirestore

enum JobSource {
    case recommendedJobs
    case recentJobs
    case category(String)
}

class JobPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var jobPostCollectionView: UICollectionView!
    
    let JobPostCollectionViewCellId = "JobPostCollectionViewCell"
    var jobs: [Job] = [] // Array to hold job postings
    let db = Firestore.firestore() // Firestore instance
    
    var source: JobSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJobPostings() // Fetch data from Firestore
        
        jobPostCollectionView.delegate = self
        jobPostCollectionView.dataSource = self
        
        // Register the job cell for collection view
        let nib = UINib(nibName: JobPostCollectionViewCellId, bundle: nil)
        jobPostCollectionView.register(nib, forCellWithReuseIdentifier: JobPostCollectionViewCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobPostCollectionViewCellId, for: indexPath) as! JobPostCollectionViewCell
        let job = jobs[indexPath.row]
        
        // Configure the cell with job data
        cell.jobPostImageView.image = nil
//        cell.jobPostTimelbl.text = job.time
        cell.jobPostTitlelbl.text = job.companyDetails?.name ?? "No Company"
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.jobPostDatelbl.text = dateFormatter.string(from: job.date)
        
        cell.jobPostLevellbl.setTitle(job.level.rawValue, for: .normal)
        cell.jobPostEnrollmentTypelbl.setTitle(job.employmentType.rawValue, for: .normal)
        cell.jobPostCategorylbl.setTitle(job.category.rawValue, for: .normal)
        
        if let location = job.companyDetails?.location {
            cell.joPostLocationlbl.setTitle(location.city, for: .normal)
        }
        
        cell.jobPostDescriptionTitlelbl.text = job.title
        cell.jobPostDescriptionlbl.text = job.desc
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 0
        let columns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1 // 2 columns for iPad, 1 column for iPhone
        
        // Calculate the width of each cell
        let cellWidth = (collectionViewWidth - spacing) / columns
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 260 : 220 // Adjust height for iPad

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3 // Set this to a smaller value for less horizontal spacing between cells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Set this to a smaller value for less vertical spacing between rows
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
        case .recommendedJobs:
            db.collection("jobPost").order(by: "jobPostDate", descending: true).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching recommended jobs: \(error.localizedDescription)")
                    return
                }
                self.handleJobPostFetch(snapshot: snapshot, error: nil)
            }
        case nil:
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
        
        self.jobs.removeAll() // Clear existing jobs
        
        let dispatchGroup = DispatchGroup() // To wait for asynchronous fetches
        
        for document in documents {
            let data = document.data()
            
            if let title = data["jobTitle"] as? String,
               let companyRef = data["companyRef"] as? DocumentReference {
                
                let levelRaw = data["jobLevel"] as? String ?? "Unknown"
                let level = JobLevel(rawValue: levelRaw)
                
                guard let jobLevel = level else {
                    print("Invalid job level: \(levelRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                let categoryRaw = data["jobCategory"] as? String ?? "Unknown"
                let category = CategoryJob(rawValue: categoryRaw)
                
                guard let jobCategory = category else {
                    print("Invalid job category: \(categoryRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                let employmentTypeRaw = data["jobEmploymentType"] as? String ?? "Unknown"
                let employmentType = EmploymentType(rawValue: employmentTypeRaw)
                
                guard let jobEmploymentType = employmentType else {
                    print("Invalid employment type: \(employmentTypeRaw) for document ID: \(document.documentID)")
                    continue
                }
                
                if let datePosted = data["jobPostDate"] as? Timestamp {
                    let date = datePosted.dateValue() // Convert Timestamp to Date
                    let timePostedString = data["jobPostTime"] as? String ?? "Unknown"
                    let desc = data["jobDescription"] as? String ?? "Unknown"
                    
                    let deadline: Date?
                    if let deadlineTimestamp = data["jobDeadlineDate"] as? Timestamp {
                        deadline = deadlineTimestamp.dateValue()
                    } else {
                        deadline = nil
                    }
                    
                    let requirement = data["jobRequirement"] as? String ?? "No requirements specified"
                    
                    var job = Job(
                        title: title,
                        companyDetails: nil,
                        level: jobLevel,
                        category: jobCategory,
                        employmentType: jobEmploymentType, location: "",
                        deadline: deadline,
                        desc: desc,
                        requirement: requirement,
                        extraAttachments: nil,
                        date: date,
                        time: timePostedString
                    )
                    
                    dispatchGroup.enter() // Start waiting for the company details
                    
                    // Fetch company details asynchronously
                    companyRef.getDocument { (companySnapshot, error) in
                        if let error = error {
                            print("Error fetching company details: \(error.localizedDescription)")
                            dispatchGroup.leave() // Leave the group if there's an error
                            return
                        }
                        
                        if let companyData = companySnapshot?.data() {
                            let companyName = companyData["name"] as? String ?? "Unknown"
                            let userId = companyData["userId"] as? Int ?? 0
                            let email = companyData["email"] as? String ?? "Unknown"
                            
                            var location: EmployerDetails.Location? = nil
                            if let locationData = companyData["location"] as? [String: Any] {
                                let country = locationData["country"] as? String ?? "Unknown"
                                let city = locationData["city"] as? String ?? "Unknown"
                                location = EmployerDetails.Location(country: country, city: city)
                            }
                            
                            let companyMainCategory = companyData["companyMainCategory"] as? String
                            let aboutUs = companyData["aboutUs"] as? String
                            let employabilityGoals = companyData["employabilityGoals"] as? String
                            let vision = companyData["vision"] as? String
                            
                            let companyDetails = EmployerDetails(
                                name: companyName,
                                userId: userId,
                                email: email,
                                location: location,
                                companyMainCategory: companyMainCategory,
                                aboutUs: aboutUs,
                                employabilityGoals: employabilityGoals,
                                vision: vision
                            )
                            
                            job.companyDetails = companyDetails
                        }
                        
                        dispatchGroup.leave() // Done with fetching company details
                    }
                    
                    // Wait for all asynchronous fetches to complete
                    dispatchGroup.notify(queue: .main) {
                        self.jobs.append(job)
                        self.jobPostCollectionView.reloadData()
                    }
                }
            }
        }
    }
}


