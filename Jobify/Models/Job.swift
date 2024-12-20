import Foundation

struct Job: Equatable {
    static func == (lhs: Job, rhs: Job) -> Bool {
        lhs.jobId == rhs.jobId
    }
    
    static var jobIdCounter = 0
    var jobId: Int
    var date: String
    var time: String
    var title: String
    var company: String
    var level: JobLevel
    var category: JobCategory
    var employmentType: EmploymentType
    var location: String
    var deadline: Date? // Make this optional
    var desc: String
    var requirement: String // Uncomment this
    var extraAttachments: Data? = nil
    var applications: [JobApplication] = []

    // Custom initializer
    init(
        title: String,
        company: String,
        level: JobLevel,
        category: JobCategory,
        employmentType: EmploymentType,
        location: String,
        deadline: Date?, // Make this optional
        desc: String,
        requirement: String,
        extraAttachments: Data?,
        date: String,
        time: String
    ) {
        Job.jobIdCounter += 1
        self.jobId = Job.jobIdCounter
        
        self.date = date // Pass Firestore's `jobPostDate`
        self.time = time // Pass Firestore's `jobPostTime`
        
        self.title = title
        self.company = company
        self.level = level
        self.category = category
        self.employmentType = employmentType
        self.location = location
        self.deadline = deadline // Assign optional deadline
        self.desc = desc
        self.requirement = requirement // Assign requirement
        self.extraAttachments = extraAttachments
    }

    enum JobLevel: String {
        case entryLevel = "Entry Level"
        case junior = "Junior"
        case midLevel = "Mid-Level"
        case senior = "Senior"
        case lead = "Lead"
        case manager = "Manager"
        case director = "Director"
        case executive = "Executive"
        case intern = "Intern"
    }
    
    enum JobCategory: String {
        case informationTechnology = "Information Technology"
        case business = "Business"
        case healthcare = "Healthcare"
        case education = "Education"
        case engineering = "Engineering"
        case marketing = "Marketing"
        case architectureAndConstruction = "Architecture & Construction"
        case interiorDesign = "Interior Design"
        case finance = "Finance"
        case arts = "Arts"
        case other = "Other"
    }
    
    enum EmploymentType: String {
        case fullTime = "Full-Time"
        case partTime = "Part-Time"
        case intern = "Intern"
        case contract = "Contract"
        case remote = "Remote"
    }
}
