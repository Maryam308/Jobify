//
//  Admin.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
struct Admin{
    
    let adminId: Int = 0000 //There is only one admin
    var adminName: String
    var email: String
    var password: String
    var adminMessageList: [Message] = []
    var seekerList: [Seeker] = []
    var employerList: [Employer] = []
    var myLearningResources: [LearningResource] = []
    var allLearningResources: [LearningResource] = []
    var allCareerPaths: [CareerPath] = []
    var allSkills: [Skill] = []
    var myJobPosts: [Job] = []
    var mentorRequestList: [MentorRequest] = []
    var applicationMentors: [Seeker] = []
    var sentNotifications: [Notification] = []

    
    //admin Id is uniqe and there is only one admin
    init(adminName: String, email: String, password: String) {
        self.adminName = adminName
        self.email = email
        self.password = password
    }
    
    //login check email and password
    func login(email: String, password: String) -> Bool {
        guard email == self.email && password == self.password else {
            print("Invalid credentials")
            return false
        }
        return true
    }
    
    //pass the new password and change to it
    mutating func resitPassword(newPassword: String){
        self.password = newPassword
    }
    
    //add the admin as the message sender
    mutating func sendMessage(messageBody:String, reciever: Any){
        
        let messageFromAdmin = Message(messageSender: self, messageReceiver: reciever, messageBody: messageBody)  // sender reciever are added also
        
        adminMessageList.append(messageFromAdmin)
        
        
        
    }
    
    //combined with adding a job post
    func createJobPost(/*newJobPost: JobPost*/){
        //add the job post to the adminlist
        //myJobPosts.Add(newJobPost)
        
        //check jobCategory and add it to its list
        
        //might need an all job post array
        
    }
    
    
    
    func removeJobPost(/*jobPosttoRemove: JobPost*/){
        //remove from admin arraylist
        //myJobPosts.Remove(jobPosttoRemove)
        
        //remove from other arraylist
    }
    
    mutating func reviewLearningResourceRequest(learningResourceRequest: inout LearningRequest , reply: Bool){
        
        //depending on the reply change the status
        if reply {
            learningResourceRequest.status = .Approved
        
            //create the learning resource
            var newLearningResource = LearningResource(
                type: learningResourceRequest.type,
                summary: learningResourceRequest.summary,
                link: learningResourceRequest.link,
                skillToDevelop: learningResourceRequest.skillToDevelop
            )
            
            //add to the requester learning resource list
                //learningResourceRequest.requester.myLearningResourcesList.append()
         
            //add to the application list of learning resource
                allLearningResources.append(newLearningResource)

         }else{
             
             learningResourceRequest.status = .Rejected
             //keep it in the request lists
             
        }
         
        //remove the request from the requester list of request
        //learningResourceRequest.requester.learningRequestsList.remove()
//        if let theRequest = learningResourceRequest.requester.learningRequestsList.firstIndex(of: learningResourceRequest) {
//            learningResourceRequest.requester.learningRequestsList.remove(at: index)
//        } else {
//            print("Request not found in the list.")
//        }
        
    }
    
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
    
    mutating func addNewLearningResource(type: LearningResourceType, summary: String, link: String, skillToDevelop: String){
        
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
    
    func addSkill(){}
    
    func removeSkill(){
        
        //remove
    }
    
    
    
    
    
}


struct MentorRequest: Equatable {
    
    static func == (lhs: MentorRequest, rhs: MentorRequest) -> Bool {
        lhs.requestId == rhs.requestId
    }
    
   
    static var requestIdCounter: Int = 0
    var requestId: Int
    var requester: Seeker
    var status: MentorRequestStatus
    
    init(requester: Seeker) {
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

