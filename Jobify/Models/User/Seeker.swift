//
//  Seeker.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct Seeker {
    var seekerId: Int
    var seekerName: String
    var email: String
    var password: String
    var country: String
    var city: String
    var messageList: [Messages]
    var isMentor: Bool
    var savedLearningResourcesList: [LearningResource]
    var jobAppliedToArrayList: [Job]
    var notificationList: [Notification]
    var selectedJobPosition: String
    
    
    // Initializer metod
    init(
            seekerId: Int,
            seekerName: String,
            email: String,
            password: String,
            country: String,
            city: String,
            messageList: [Messages] = [],
            isMentor: Bool = false,
            savedLearningResourcesList: [LearningResource] = [],
            jobAppliedToArrayList: [Job] = [],
            notificationList: [Notification] = [],
            selectedJobPosition: String = ""
        ) {
            self.seekerId = seekerId
            self.seekerName = seekerName
            self.email = email
            self.password = password
            self.country = country
            self.city = city
            self.messageList = messageList
            self.isMentor = isMentor
            self.savedLearningResourcesList = savedLearningResourcesList
            self.jobAppliedToArrayList = jobAppliedToArrayList
            self.notificationList = notificationList
            self.selectedJobPosition = selectedJobPosition
        }
    
    
    //Validating user's credentials for login
    func login(email: String, password: String) -> Bool {
        guard self.email == email && self.password == password else {
            print("Invalid email or password.")
            return false
        }
        print("Login successful for \(self.seekerName)")
        return true
    }
    
    //Chnaging user's passwords, key-word mutating is used to make the function follow Swift's value type safety principles
    mutating func resetPassword(newPassword: String) {
        self.password = newPassword
        print("Password reset successful for \(self.seekerName).")
    }
    
    //Everytime the seeker applies for a new job, his application  will be added directly
    mutating func addApplication(appliedJob: Job) {
        self.jobAppliedToArrayList.append(appliedJob)
    }
    
    //
    mutating func sendMessage(messageBody: String, messageSender: Self, messageReceiver: Any) {
        
        //let message = Messages(messageSender: "s")
    }


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













/* --> make it on the UI side
 // Function to handle job selection
 func handleJobSelection(for seeker: inout Seeker, selectedJob: String, customInput: String? = nil) {
     if selectedJob == "Other" {
         // Handle custom job position input
         if let customJob = customInput, !customJob.isEmpty {
             // Check if the custom job is already in the list
             if !jobPositions.contains(customJob) {
                 jobPositions.append(customJob) // Add the custom job to the list
             }
             seeker.selectedJobPosition = customJob // Update the seeker's job position
         } else {
             seeker.selectedJobPosition = "Unspecified Job" // Fallback for empty input
         }
     } else {
         // Set the selected predefined job position
         seeker.selectedJobPosition = selectedJob
     }
 }
 */


