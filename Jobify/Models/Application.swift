//
//  Application.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct JobApplication{
    
    //Auto-generated variables
    static var applicationIdCounter: Int = 0
    var applicationId: Int
    //var applicationDate: String
        
    // Create a Calendar instance to format the date and time
    //var calendar = Calendar.current


    //Passed variables from application form
    var jobApplicant: SeekerDetails
    var briefIntroduction: String
    var motivation: String
    var contributionToCompany: String
    var applicantCV: CV
    //var applicantCoverLetter: Data?
    var jobApplied: Job

    enum ApplicationStatus: String, Codable{
        case notReviewed = "Not Reviewed"
        case reviewed = "Reviewed"
        case approved = "Approved"
        case rejected = "Rejected"
    }
    

    
    // initializer
    init(jobApplicant:  inout SeekerDetails,
         jobApplied: Job,
         applicantCV: CV,
         briefIntroduction: String,
         motivation: String,
         contributionToCompany: String
         ){
        
        //Auto-generated variables
        
        JobApplication.applicationIdCounter += 1
        applicationId = JobApplication.applicationIdCounter
        // Get the current date and time
        //var currentDate = Date()
        
        // Extract the date components for the date
        //var dateComponents = calendar.dateComponents([.day, .month], from: currentDate)
        // Create date and time variables and convert date and time components to string
        //var date = String(format: "%02d-%02d", dateComponents.day!, dateComponents.month!)
        
        //self.applicationDate = date
        
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        self.applicantCV = applicantCV
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        //self.applicantCoverLetter = applicantCoverLetter
        
    }
    }


