//
//  Seeker.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct SeekerDetails {
    var country: String
    var city: String
    var seekerMessageList: [Message] = []
    var isMentor: Bool
    var savedLearningResourcesList: [LearningResource] = []
    var jobsApplicationList: [JobApplication] = []
    var notificationList: [Notification] = []
    var selectedJobPosition: String

    // Custom initializer
    init(
        seekerName: String,
        email: String,
        password: String,
        country: String,
        city: String,
        isMentor: Bool = false,
        selectedJobPosition: String = ""
    ) {
        

        // Assign other properties
        
        self.country = country
        self.city = city
        self.isMentor = isMentor
        self.selectedJobPosition = selectedJobPosition
    }
    
    //===================================================================================================================//
    
    // Validating user's credentials for login
//    func login(email: String, password: String) -> Bool {
//        guard self.email == email && self.password == password else {
//            //print("Invalid email or password.")
//            return false
//        }
//        //print("Login successful for \(self.seekerName)")
//        return true
//    }
//    
//    
//    //===================================================================================================================//
//    
//    
//    // Chnaging user's passwords, key-word mutating is used to make the function follow Swift's value type safety principles
//    mutating func resetPassword(newPassword: String) {
//        self.password = newPassword
//        //print("Password reset successful for \(self.seekerName).")
//    }
    
    
    //===================================================================================================================//
    
    
    // Everytime the seeker applies for a new job, this application will be created and added to his profile directly
//    mutating func CreateJobApplication(
//    jobApplicant: inout Seeker,
//    jobApplied: Job,
//    applicantCV: CV,
//    briefIntroduction: String,
//    motivation: String,
//    contributionToCompany: String,
//    applicantCoverLetter: Data?){
//        
//        //Creating job application
//        let newApplication = JobApplication(
//            jobApplicant: &jobApplicant,
//                 jobApplied: jobApplied,
//                 applicantCV: applicantCV,
//                 briefIntroduction: briefIntroduction,
//                 motivation: motivation,
//                 contributionToCompany: contributionToCompany,
//                 applicantCoverLetter: applicantCoverLetter
//        )
//        
//        // Adding the job application to the seeker's list
//        self.jobsApplicationList.append(newApplication)
//    }
    
    //===================================================================================================================//
    
    
    //Creating the message object, then adding it for bothe the sender's messages list.
    mutating func sendMessage(messageBody: String, messageReceiver: Any) {
       
        let message = Message(
            messageSender: self,
            messageReceiver: messageReceiver,
            messageBody: messageBody)
        
        // Add to sender list
        seekerMessageList.append(message)
    }
    
    
    //===================================================================================================================//
    
    
    //
    func sendMentorshipRequest() {
        
        // Creating a mentorship request object
        //let mentorshipRequest = MentorRequest(requester: self)
    }
    
    //===================================================================================================================//
        

    }
    
    


    
    // Dynaamic list for the job postions, the jobs listed are a sample, if the user has unlisted job postion, he/she selects other, after selecting others from the UI side, a textbox will appear for the user to enter his/her job position, if the job postion is not in the list it will be added directly.
    var jobPositions: [String] = [
        "Developer",
        "Designer",
        "Project Manager",
        "Software Developer",
        "UI/UX Designer",
        "Data Analyst",
        "Doctor",
        "Teacher",
        "Nurse",
        "Website Designer",
        "Other"
    ]
