import Foundation

// CV model containing all the user information needed for the CV
struct CV {
    var personalDetails: PersonalDetails //will take this from Zainab's file
    var education: [Education]
    var skills: [String]
    var workExperience: [WorkExperience]
    var photo: Data?  // Photo is optional
}

// Personal details struct containing basic info about the user
struct PersonalDetails {

}

// Education struct to store educational background info
struct Education {
    var degree: String
    var institution: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
}

// Work experience struct to store job-related experience
struct WorkExperience {
    var company: String
    var role: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
    var keyResponsibilities: String
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
        userCVs[index].photo = photoData
    }
}
