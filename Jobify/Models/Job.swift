import Foundation
struct Job: Equatable {
    static func == (lhs: Job, rhs: Job) -> Bool {
        lhs.jobId == rhs.jobId
    }
    
    static var jobIdCounter = 0
    var jobId: Int
    var date: Date // Change to Date type
    var time: String
    var title: String
    var companyDetails: EmployerDetails? // Store the company details object
    var adminDetails: User?
    var level: JobLevel
    var category: CategoryJob
    var employmentType: EmploymentType
    var location: String
    var deadline: Date?
    var desc: String
    var requirement: String
    var extraAttachments: String?
    var applications: [JobApplication] = []
    
    init(
        title: String,
        companyDetails: EmployerDetails?,
        level: JobLevel,
        category: CategoryJob,
        employmentType: EmploymentType,
        location: String,
        deadline: Date?,
        desc: String,
        requirement: String,
        extraAttachments: String?,
        date: Date,
        time: String
    ) {
        
        Job.jobIdCounter += 1
        self.jobId = Job.jobIdCounter
        
        self.date = date
        self.time = time
        self.title = title
        self.companyDetails = companyDetails
        self.level = level
        self.category = category
        self.employmentType = employmentType
        self.location = location
        self.deadline = deadline
        self.desc = desc
        self.requirement = requirement
        self.extraAttachments = extraAttachments
    }
    
    // Employer Custom constructor
        init(
            jobId: Int,
            title: String,
            companyDetails: EmployerDetails?,
            level: JobLevel,
            category: CategoryJob,
            employmentType: EmploymentType,
            location: String,
            deadline: Date?,
            desc: String,
            requirement: String,
            extraAttachments: String?,
            date: Date,
            time: String
        ) {
            
            self.jobId = jobId
            self.title = title
            self.companyDetails = companyDetails
            self.level = level
            self.category = category
            self.employmentType = employmentType
            self.location = location
            self.deadline = deadline
            self.desc = desc
            self.requirement = requirement
            self.extraAttachments = extraAttachments
            self.date = date
            self.time = time
        }
    // Admin Custom constructor
        init(
            jobId: Int,
            title: String,
            adminDetails: User?,
            level: JobLevel,
            category: CategoryJob,
            employmentType: EmploymentType,
            location: String,
            deadline: Date?,
            desc: String,
            requirement: String,
            extraAttachments: String?,
            date: Date,
            time: String
        ) {
            
            self.jobId = jobId
            self.title = title
            self.adminDetails = adminDetails
            self.level = level
            self.category = category
            self.employmentType = employmentType
            self.location = location
            self.deadline = deadline
            self.desc = desc
            self.requirement = requirement
            self.extraAttachments = extraAttachments
            self.date = date
            self.time = time
        }
}



    // Enums remain unchanged
    
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
    
    enum CategoryJob: String {
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
    

