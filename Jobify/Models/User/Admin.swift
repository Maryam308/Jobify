//
//  Admin.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
struct Admin{
    
    var adminId: Int = 0000 //if there is only one admin should be a constant
    var adminName: String
    var email: String
    var password: String
    var messageList: [Message] = []
    var seekerList: [Seeker] = []
    var employerList: [Employer] = []
    var myLearningResources: [LearningResource] = []
    var allLearningResources: [LearningResource] = []
    var allCareerPaths: [CareerPath] = []
    var allSkills: [Skill] = []
//    var myJobPosts: [JobPost] = []
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
    func sendMessage(messageBody:String, recieverId: Int){
//        let messageFromAdmin = Message()  // sender reciever are added also
//        messageList.append(messageFromAdmin)
    }
    
    //combined with adding a job post
    func createJobPost(/*newJobPost: JobPost*/){
        //add the job post to the adminlist
        //myJobPosts.Add(newJobPost)
        
        //check jobCategory and add it to its list
        
        //might need an all job post array
        
    }
    
    func editJobPost(/*jobPosttoEdit: JobPost*/){ //add the job post parameter
        
    }
    
    func removeJobPost(/*jobPosttoRemove: JobPost*/){
        //remove from admin arraylist
        //myJobPosts.Remove(jobPosttoRemove)
        
        //remove from other arraylist
    }
    
    func reviewLearningResourceRequest(learningResourceRequest: LearningRequest, reply: Bool){
        
        //depending on the reply change the status
        if reply {
            //learningResourceRequest.status = .Approved
            
            
            //add to the requester learning resource list
         
            //create the new learning resource
//                let newLearningResource = LearningResource(/*pass info from request object*/)
//         
//            //add to the application list of learning resource
//                allLearningResources.Add(newLearningResource)
//         
//         }else{
//            learningResourceRequest.status = "Rejected"
            //keep it in the request lists
          
         
         }
         
        
        //remove the request from the requester list of request
        
    }
    
    func reviewMentorshipRequest(/*pass in the requester, */ reply: Bool){
        
    }
    
    func addNewLearningResource(){}
    
    func editLearningResource(){}
    
    func removeLearningResource(){}
    
    func addCareerPath(){}
    
    func editCareerPath(){}
    
    func removeCareerPath(){}
    
    func addSkill(){}
    
    func removeSkill(){}
    
    func logOut(){}
    
    
    
    
}


struct MentorRequest {
    var requestId: Int
    var requester: Seeker
    var status: String
    
    
    
}
