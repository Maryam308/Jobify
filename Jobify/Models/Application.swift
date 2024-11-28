//
//  Application.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct JobApplication{
    static var applicationIdCounter: Int = 0
    var applicationId: Int
    var jobApplicant: Seeker
    //var jobApplied: Job
    var applicationDate: Date
    var applicantCV: CV
    var briefIntroduction: String
    var motivation: String
    var contributionToCompany: String
    var applicantCoverLetter: Data?
    
    enum ApplicationStatus: String, Codable{
        case notViewed = "Not Viewed"
        case viewed = "Viewed"
        case accepted = "Accepted"
        case rejected = "Rejected"
    }
    
    /*init (){
        
    }
    
    init(jobApplicant: Seeker, jobApplied: Job, applicationDate: Date, applicantCV: CV, briefIntroduction: String, motivation: String, contributionToCompany: String, applicantCoverLetter: Data?){
        JobApplication.applicationIdCounter += 1
        applicationId = JobApplication.applicationIdCounter
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        self.applicationDate = applicationDate
        self.applicantCV = applicantCV
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        self.applicantCoverLetter = applicantCoverLetter
    }*/
    
   
    
}
