//
//  Application.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct JobApplication {
    static var applicationIdCounter: Int = 0
    
    var applicationId: Int
    var applicationDate: String
    
    var jobApplicant: SeekerDetails? // Store as object
    var jobApplied: Job? // Store as object
    var briefIntroduction: String
    var motivation: String
    var contributionToCompany: String
    var applicantCVId: String // Use an identifier for the CV
    
    enum ApplicationStatus: String {
        case notReviewed = "Not Reviewed"
        case reviewed = "Reviewed"
        case approved = "Approved"
        case rejected = "Rejected"
    }
    
    var status: ApplicationStatus = .notReviewed

    // Initializer
    //init(){}
    init(jobApplicant: SeekerDetails?,
         jobApplied: Job?,
         applicantCVId: String,
         briefIntroduction: String,
         motivation: String,
         contributionToCompany: String ) {
        
        JobApplication.applicationIdCounter += 1
        self.applicationId = JobApplication.applicationIdCounter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.applicationDate = dateFormatter.string(from: Date())
        
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        self.applicantCVId = applicantCVId
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        
    }
    
    init(jobApplicant: SeekerDetails?,
         jobApplied: Job?,
         applicantCVId: String,
         briefIntroduction: String,
         motivation: String,
         contributionToCompany: String, status: ApplicationStatus,
         applicationId: Int) {
        
        JobApplication.applicationIdCounter += 1
        self.applicationId = JobApplication.applicationIdCounter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.applicationDate = dateFormatter.string(from: Date())
        
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        self.applicantCVId = applicantCVId
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        self.status = status
    }

    
}



