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
    
    
    // Static method to get and increment the ID
        static func getNextID() -> Int {
            JobApplication.applicationIdCounter += 1  // Increment the ID each time it's called
            return JobApplication.applicationIdCounter  // Return the current (incremented) ID
        }
    
    static func fetchAndSetID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("jobApplication")
                .order(by: "applicationId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        applicationIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["applicationId"] as? Int {
                            applicationIdCounter = highestId
                        } else {
                            applicationIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        applicationIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
        }

}



