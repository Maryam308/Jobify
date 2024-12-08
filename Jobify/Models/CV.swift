import Foundation

// Education struct to store educational background info
public struct Education {
   
    //Auto-gnerated variabels
    static var educationIdCounter = 0 // Static counter for generating unique education ID
    var educationID: Int
    
    //Passed variables
    var degree: String
    var institution: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
    
    // Custom initializer
    init(
        degree: String,
        institution: String,
        startDate: Date,
        endDate: Date? = nil)
        {
            Education.educationIdCounter+=1
            self.educationID = Education.educationIdCounter
            
            self.degree = degree
            self.institution = institution
            self.startDate = startDate
            self.endDate = endDate
    }
}
// CV model containing all the user information needed for the CV
public struct CV {
    //Auto-generated variabels
    static var cvIDCounter = 0 // Static counter for generating unique CV ID
    var cvID: Int
    
    //Passed variables
    var personalDetails: PersonalDetails
    var education: [Education] = []
    var skills: [String] = []
    var workExperience: [WorkExperience] = []
    var name : String
    var email : String
    var phoneNumber : String
    var country : String
    var city : String
    var profilePicture : Data?
    
    

    
    init(personalDetails: PersonalDetails, skills: [String], education: [Education], workExperience: [WorkExperience], name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: Data? = nil) {
        
        //Auto-gnerated variabels
        CV.cvIDCounter = 0 // Static counter for generating unique education ID
        cvID = CV.cvIDCounter
        
        
        self.personalDetails = personalDetails
        self.skills = skills
        self.education = education
        self.workExperience = workExperience
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.country = country
        self.city = city
        self.profilePicture = profilePicture
    }
    
    
}


// Personal details struct containing basic info about the user
struct PersonalDetails {
    var name : String
    var email : String
    var phoneNumber : String
    var country : String
    var city : String
    var profilePicture : Data?
    
    init(name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: Data? = nil) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.country = country
        self.city = city
        self.profilePicture = profilePicture
    }

}


// Skill struct to store seeker's skill info
struct CVSkill{
    
    //Auto-gnerated variabels
    static var skillIDCounter = 0 // Static counter for generating unique education ID
    var skillID: Int
    
    //Passed variables
    var skillDescription: String

    
    // Custom initializer
    init(skillDescription: String) {
        
        CVSkill.skillIDCounter+=1
        skillID=CVSkill.skillIDCounter
        
        self.skillDescription = skillDescription
    }

}

// Work experience struct to store job-related experience
struct WorkExperience {
   
    static var workExperienceIDCounter = 0 // Static counter for generating unique working experince ID
    var workExperienceID: Int
    
    var company: String
    var role: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
    var keyResponsibilities: String
    
    // Custom initializer
    init(company: String, role: String, startDate: Date, endDate: Date? = nil, keyResponsibilities: String) {
        
        WorkExperience.workExperienceIDCounter+=1
        workExperienceID=WorkExperience.workExperienceIDCounter
        
        self.company = company
        self.role = role
        self.startDate = startDate
        self.endDate = endDate
        self.keyResponsibilities = keyResponsibilities
    }
    
}

// CVManager class to manage multiple CVs for the user
class CVManager {
    static var userCVs: [CV] = []
    
    // Add a new CV
    static func addCV(cv: CV) {
        userCVs.append(cv)
    }
    
    // Retrieve all CVs for a user
    static func getAllCVs() -> [CV] {
        return userCVs
    }
    
    // Retrieve a specific CV by index
    static func getCV(at index: Int) -> CV? {
        guard index >= 0 && index < userCVs.count else { return nil }
        return userCVs[index]
    }
    
    // Remove a CV by index
    static func removeCV(at index: Int) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs.remove(at: index)
    }
    
    // Edit Personal Details of a CV
    static func editPersonalDetails(at index: Int, newPersonalDetails: PersonalDetails) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].personalDetails = newPersonalDetails
    }
    
    // Add Education to a CV
    static func addEducation(at index: Int, education: Education) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].education.append(education)
    }
    
    // Remove Education from a CV
    static func removeEducation(at index: Int, educationIndex: Int) {
        guard index >= 0 && index < userCVs.count else { return }
        guard educationIndex >= 0 && educationIndex < userCVs[index].education.count else { return }
        userCVs[index].education.remove(at: educationIndex)
    }
    
    // Edit a specific Education entry
    static func editEducation(at index: Int, educationIndex: Int, newEducation: Education) {
        guard index >= 0 && index < userCVs.count else { return }
        guard educationIndex >= 0 && educationIndex < userCVs[index].education.count else { return }
        userCVs[index].education[educationIndex] = newEducation
    }
    
    // Add Skill to a CV
    static func addSkill(at index: Int, skill: String) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].skills.append(skill)
    }
    
    // Remove Skill from a CV
    static func removeSkill(at index: Int, skill: String) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].skills.removeAll { $0 == skill }
    }
    
    // Edit a specific Skill in a CV
    static func editSkill(at index: Int, oldSkill: String, newSkill: String) {
        guard index >= 0 && index < userCVs.count else { return }
        if let skillIndex = userCVs[index].skills.firstIndex(of: oldSkill) {
            userCVs[index].skills[skillIndex] = newSkill
        }
    }
    
    // Add Work Experience to a CV
    static func addWorkExperience(at index: Int, workExperience: WorkExperience) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].workExperience.append(workExperience)
    }
    
    // Remove Work Experience from a CV
    static func removeWorkExperience(at index: Int, workExperienceIndex: Int) {
        guard index >= 0 && index < userCVs.count else { return }
        guard workExperienceIndex >= 0 && workExperienceIndex < userCVs[index].workExperience.count else { return }
        userCVs[index].workExperience.remove(at: workExperienceIndex)
    }
    
    // Edit a specific Work Experience entry
    static func editWorkExperience(at index: Int, workExperienceIndex: Int, newWorkExperience: WorkExperience) {
        guard index >= 0 && index < userCVs.count else { return }
        guard workExperienceIndex >= 0 && workExperienceIndex < userCVs[index].workExperience.count else { return }
        userCVs[index].workExperience[workExperienceIndex] = newWorkExperience
    }
    
    // Update Photo for a CV
    static func updatePhoto(at index: Int, photoData: Data?) {
        guard index >= 0 && index < userCVs.count else { return }
        userCVs[index].profilePicture = photoData
    }
}
