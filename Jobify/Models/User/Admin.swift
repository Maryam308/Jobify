//
//  Admin.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
struct AdminDetails{
    
    
    var adminMessageList: [Message] = []
    var myLearningResources: [LearningResource] = []
    var savedLearningResources: [LearningResource] = []
    var allLearningResources: [LearningResource] = []
    var allCareerPaths: [CareerPath] = []
    var allSkills: [Skill] = []
    var myJobPosts: [Job] = []
    var mentorRequestList: [MentorRequest] = []
    var applicationMentors: [User] = []
    var sentNotifications: [Notification] = []
    var allJobPosts: [Job] = []

    
    //admin Id is uniqe and there is only one admin
//    init(adminName: String, email: String, password: String) {
//        self.adminName = adminName
//        self.email = email
//        self.password = password
//    }
    
    //login check email and password
//    func login(email: String, password: String) -> Bool {
//        guard email == self.email && password == self.password else {
//            print("Invalid credentials")
//            return false
//        }
//        return true
//    }
//    
//    //pass the new password and change to it
//    mutating func resitPassword(newPassword: String){
//        self.password = newPassword
//    }
    
    //add the admin as the message sender
    mutating func sendMessage(messageBody:String, reciever: Any){
        
        let messageFromAdmin = Message(messageSender: self, messageReceiver: reciever, messageBody: messageBody)  // sender reciever are added also
        
        adminMessageList.append(messageFromAdmin)
        
        
        
    }
    
    //combined with adding a job post
//    mutating func createJobPostA(
//        titleA: String,
//        companyA: inout Employer,
//        levelA: String,
//        locationA: String,
//        descA: String,
//        requirementA: String,
//        extraAttachmentsA: Data?,
//        employmentTypeA: Job.EmploymentType,
//        deadlineA: Date){
//                           
//            var newJobPost = Job(title: titleA, company: &companyA, level: levelA, location: locationA, desc: descA, requirement: requirementA, extraAttachments: extraAttachmentsA, employmentType: employmentTypeA, deadline: deadlineA)
//                           
//        //add the job post to the adminlist
//        myJobPosts.append(newJobPost)
//        
//        //add the job to all job posts
//        allJobPosts.append(newJobPost)
//            
//            
//    }
    
    
    
    mutating func removeJobPost(jobPosttoRemove: Job ){
        
        //remove from admin arraylist
        if let index = myJobPosts.firstIndex(of: jobPosttoRemove){
            myJobPosts.remove(at: index)
        }
        
        //remove from all jobs
        if let index = allJobPosts.firstIndex(of: jobPosttoRemove){
            allJobPosts.remove(at: index)
        }
        
    }
    
//    mutating func reviewLearningResourceRequest(learningResourceRequest: inout LearningRequest , reply: Bool){
//        
//        //depending on the reply change the status
//        if reply {
//            learningResourceRequest.status = .Approved
//        
//            //create the learning resource
//            var newLearningResource = LearningResource(
//                type: learningResourceRequest.type,
//                summary: learningResourceRequest.summary,
//                link: learningResourceRequest.link,
//                skillToDevelop: learningResourceRequest.skillToDevelop
//            )
//            
//            //add to the requester learning resource list
//                learningResourceRequest.requester.myLearningResourcesList.append(newLearningResource)
//         
//            //add to the application list of learning resource
//                allLearningResources.append(newLearningResource)
//
//         }else{
//             
//             learningResourceRequest.status = .Rejected
//             //keep it in the request lists
//             
//        }
//         
//        //remove the request from the requester list of request
//        if let theRequestIndx = learningResourceRequest.requester.learningRequestsList.firstIndex(of: learningResourceRequest) {
//            learningResourceRequest.requester.learningRequestsList.remove(at: theRequestIndx)
//        } else {
//            print("Request not found in the list.")
//        }
//        
//    }
    
    mutating func reviewMentorshipRequest(request: inout MentorRequest, reply: Bool){
        
        if reply {
            
            //change the request status to approved
            request.status = .Accepted
            //add the seeker as a mentor in the mentor array
            applicationMentors.append(request.requester)
            
        }else{
            
            //change the request status to approved
            request.status = .Rejected
            
        }
        
        //remove the request
        if let index = mentorRequestList.firstIndex(of: request) {
            mentorRequestList.remove(at: index)
        } else {
            print("Request not found in the list.")
        }
        
    }
    
    mutating func addNewLearningResource(type: String, summary: String, link: String, skillToDevelop: String){
        
        //create new learning resource
        var newLearningResource = LearningResource(type: type, summary: summary, link: link, skillToDevelop: skillToDevelop)
                
        //add to array of all learning resources
        allLearningResources.append(newLearningResource)
        
    }
    
    
    mutating func removeLearningResource(resourceToRemove: LearningResource){
        
        if let index = allLearningResources.firstIndex(of: resourceToRemove) {
            
            allLearningResources.remove(at: index)
            
        } else {
            print("Learning Resource not found in the list.")
        }
        
    }
    
    mutating func addCareerPath(careerName: String, demand: Demand, roadmap: String){
        
        //create the Career path
        var newCareerPath = CareerPath(careerName: careerName, demand: demand, roadmap: roadmap)
        
        //add to career paths array
        allCareerPaths.append(newCareerPath)
    }
    
    
    
    mutating func removeCareerPath(careerToRemove: CareerPath){
        
        if let index = allCareerPaths.firstIndex(of: careerToRemove) {
            
            allCareerPaths.remove(at: index)
            
        } else {
            print("Learning Resource not found in the list.")
        }
        
    }
    
    mutating func addSkill(skillTitle: String, skillDescription: String){
        
        //add the skill
        var newSkill = Skill(title: skillTitle , description: skillDescription )
        
        //add to all skill
        allSkills.append(newSkill)
        
    }
    
    mutating func removeSkill(skillToRemove: inout Skill){
        
        //remove the learning resources of the skill
        skillToRemove.learningResources.removeAll();
        
        
        //remove the learning resources from allLearningResources that belong to the same skill
        allLearningResources.removeAll { $0.skillToDevelop == skillToRemove.title }
        
        //remove learning resources from savedLearningResources and my learning resources in employers and seekers
            //from seekers
                // Print remaining resources for each seeker
          
//                    for seekerIndex in seekerList.indices {
//                        seekerList[seekerIndex].savedLearningResourcesList.removeAll { $0.skillToDevelop == skillToRemove.title }
//                    }
//        
//            //from employers
//                //saved by the employer
//                    for employerIndex in employerList.indices {
//                        employerList[employerIndex].savedLearningResourcesList.removeAll { $0.skillToDevelop == skillToRemove.title }
//                    }
//                    
//                //created by the employer
//                    for employerIndex in employerList.indices {
//                        employerList[employerIndex].myLearningResourcesList.removeAll { $0.skillToDevelop == skillToRemove.title }
//                    }
        
            //from admin
                //saved by the admin
                    self.savedLearningResources.removeAll { $0.skillToDevelop == skillToRemove.title }
                    
                    
                //created by the admin
                    self.myLearningResources.removeAll { $0.skillToDevelop == skillToRemove.title }
                    
            
        //remove skill from allskill
        if let skillIndex = allSkills.firstIndex(of: skillToRemove) {
            allSkills.remove(at: skillIndex)
        } else {
            print("Skill not found in the array.")
        }
        
        
        
    }
    
    
//    mutating func removeEmployerJobPost(jobPostToRemove: inout Job, employerPosted: inout Employer){
//        
//        //remove from employer
//        if let index = employerPosted.myJobPostsList.firstIndex(of: jobPostToRemove){
//            employerPosted.myJobPostsList.remove(at: index)
//        }
//        
//        //remove from all jobs
//        if let index = allJobPosts.firstIndex(of: jobPostToRemove){
//            allJobPosts.remove(at: index)
//        }
//        
//    }
 
    
}


struct MentorRequest: Equatable {
    
    static func == (lhs: MentorRequest, rhs: MentorRequest) -> Bool {
        lhs.requestId == rhs.requestId
    }
    
   
    static var requestIdCounter: Int = 0
    var requestId: Int
    var requester: User
    var status: MentorRequestStatus
    
    init(requester: User) {
        MentorRequest.requestIdCounter += 1
        requestId = MentorRequest.requestIdCounter
        self.requester = requester
        status = .Pending
    }
    
    
}

enum MentorRequestStatus: String, Codable {
    case Pending
    case Accepted
    case Rejected
}

