//
//  Employer.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
struct Employer {
    static var employerIdCounter = 0 // Static counter for generating unique employer IDs
    
    var employerId: Int
    var employerName: String
    var email: String
    var password: String
    var country: String
    var city: String
    var EmployermessageList: [Message] = []
    var companyMainCategory: String
    var aboutUs: String
    var employabilityGoals: String
    var vision: String
    var myJobPostsList: [Job] = []
    var learningRequestsList: [LearningRequest] = []
    var myLearningResourcesList: [LearningResource] = []
    var notificationList: [Notification] = []
    
    // Custom initializer
    init(
           employerName: String,
           email: String,
           password: String,
           country: String,
           city: String,
           companyMainCategory: String = "",
           aboutUs: String = "",
           employabilityGoals: String = "",
           vision: String = ""
       ) {
           // Increment the counter and assign it as employerId
           Employer.employerIdCounter += 1
           self.employerId = Employer.employerIdCounter

           // Assign other properties
           self.employerName = employerName
           self.email = email
           self.password = password
           self.country = country
           self.city = city
           self.companyMainCategory = companyMainCategory
           self.aboutUs = aboutUs
           self.employabilityGoals = employabilityGoals
           self.vision = vision
       }
    
    
    //===================================================================================================================//
    
    
    // Validating user's credentials for login
    func login(email: String, password: String) -> Bool {
        guard self.email == email && self.password == password else {
            //print("Invalid email or password.")
            return false
        }
        //print("Login successful for \(self.seekerName)")
        return true
    }
    
    
    //===================================================================================================================//
    
    
    // Chnaging user's passwords, key-word mutating is used to make the function follow Swift's value type safety principles
    mutating func resetPassword(newPassword: String) {
        self.password = newPassword
        //print("Password reset successful for \(self.seekerName).")
    }
    
    
    //===================================================================================================================//
    
    
    // Creating the message object, then adding it for bothe the sender's messages list.
    mutating func sendMessage(messageBody: String, messageReceiver: Any) {
        let message = Message(messageSender: self, messageReceiver:messageReceiver, messageBody: messageBody)
        
        // Add to sender list
        EmployermessageList.append(<#T##newElement: Message##Message#>)
    }
    
    //===================================================================================================================//
    
    
    //Creating a new job post
    mutating func createJobPost(
        title: String,
        company: inout Employer,
        level: String,
        location: String,
        desc: String,
        requirement: String,
        extraAttachments: Data?,
        employmentType: Job.EmploymentType,
        deadline: Date) {
        
            let newJobPost = Job(
                title: title,
                company: &company,
                level: level,
                location: location,
                desc: desc,
                requirement: requirement,
                extraAttachments:  extraAttachments,
                employmentType: employmentType,
                deadline: deadline)
        
        //Adding the new job post to the company's job posts list
        self.myJobPostsList.append(newJobPost)
    }
}


//===================================================================================================================//


// Dynaamic list for the company categories.
var mainCompanyCategory: [String] = [
    "Information Technology",
    "business",
    "Healthcare",
    "Education",
    "Engineering",
    "Marketing",
    "Architecture and Construction",
    "Interior Design",
    "Other"
]
