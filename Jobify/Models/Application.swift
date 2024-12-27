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
    var jobId: Int
    var jobApplicant: SeekerDetails? // Store as object
    var jobApplied: Job? // Store as object
    var briefIntroduction: String
    var motivation: String
    var contributionToCompany: String
    //var applicantCVId: String // Use an identifier for the CV
    var employerRef: DocumentReference?
    var seekerRef: DocumentReference?
    var cvRef: DocumentReference?
    
    
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
         //applicantCVId: String,
         briefIntroduction: String,
         motivation: String,
         contributionToCompany: String,
         jobId: Int,
         applicantRef: DocumentReference?,
         employerRef: DocumentReference?) {
        
        JobApplication.applicationIdCounter += 1
        self.applicationId = JobApplication.applicationIdCounter
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.applicationDate = dateFormatter.string(from: Date())
        
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        //self.applicantCVId = applicantCVId
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        self.jobId = jobId
        
    }
    
    init(jobApplicant: SeekerDetails?,
         jobApplied: Job?,
         briefIntroduction: String,
         motivation: String,
         contributionToCompany: String,
         status: ApplicationStatus,
         applicationId: Int,
         jobId: Int,
         applicationDate: String,
         applicantRef: DocumentReference?,
         employerRef: DocumentReference?,
         cvRef: DocumentReference?) {
        
        
        self.applicationId = applicationId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.applicationDate = dateFormatter.string(from: Date())
        
        self.jobApplicant = jobApplicant
        self.jobApplied = jobApplied
        self.cvRef = cvRef
        self.briefIntroduction = briefIntroduction
        self.motivation = motivation
        self.contributionToCompany = contributionToCompany
        self.status = status
        self.jobId = jobId
        self.seekerRef = applicantRef
        self.employerRef = employerRef

    }
/*
    // Method to fetch seeker data (applicant)
        func fetchSeekerData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
            seekerRef?.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let document = document, document.exists {
                    completion(.success(document.data() ?? [:]))
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Seeker document does not exist"])))
                }
            }
        }
 */
}



