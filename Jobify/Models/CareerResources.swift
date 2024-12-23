//
//  CareerResources.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//
import Foundation
import FirebaseFirestore

//Maryam Ahmed : I know this will need fixing but i am not using enums since i am working with the database so either i am going to do a collection and a refrence or keep them since they wont change if i kept them here and there the same.
//currently i am using popup buttons to write them so they wont be altered from user side

//Maybe for ids we should start with the number after data added to firebase


struct CareerPath: Equatable {
    
    static func == (lhs: CareerPath, rhs: CareerPath) -> Bool {
        return lhs.careerId == rhs.careerId
    }
    
    static var careerIdCounter: Int = 20 // to avoid conflict with any sample data
    var careerId: Int
    var description: String? = ""
    var title: String
    var demand: String? = ""
    var roadmap: String? = ""
    
    init(careerName: String, demand: String?, roadmap: String, description: String) {
        careerId = CareerPath.careerIdCounter + 1
        self.title = careerName
        self.demand = demand
        self.roadmap = roadmap
        self.description = description
    }
    
    //init for fetching and constructing
    init(careerId: Int , title: String){
        self.title = title
        self.careerId = careerId
    }
    
}

enum Demand: String {
    case high
    case medium
    case low
}


struct LearningResource: Equatable {
    
    static func == (lhs: LearningResource, rhs: LearningResource) -> Bool {
        return lhs.learningResourceId == rhs.learningResourceId
    }
    
    static var resourceIdCounter: Int = 0
    var learningResourceId: Int = 0
    var type: String? = ""
    var summary: String? = ""
    var link: String? = ""
    var title: String? = ""
    var datePublished: Date = Date()
    var skillRef: DocumentReference? // Firestore DocumentReference for the skill
    var skillToDevelop: String = ""
    // Default initializer
    init() {}
    
    init(type: String, summary: String, link: String, title: String, skillRef: DocumentReference) {
        LearningResource.resourceIdCounter += 1
        self.learningResourceId = LearningResource.resourceIdCounter
        self.type = type
        self.summary = summary
        self.link = link
        self.title = title // Set the title
        self.skillRef = skillRef
    }
    
    init(type: String, summary: String, link: String, title: String, skillToDevelop: String) {
         
         LearningResource.resourceIdCounter += 1
        self.title = title
         self.learningResourceId = LearningResource.resourceIdCounter
         self.type = type
         self.summary = summary
         self.link = link
         self.skillToDevelop = skillToDevelop
         
     }
}

enum LearningResourceType: String {
    case Course
    case Article
    case Certification
}

struct Skill: Equatable {
    
    static func == (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.skillId == rhs.skillId
    }
    
    static var skillIdCounter: Int = 0
    var skillId: Int
    var title: String
    var description: String
    var documentReference: DocumentReference? // Firestore DocumentReference for the skill

    init(title: String, description: String, documentReference: DocumentReference) {
        Skill.skillIdCounter += 1
        self.skillId = Skill.skillIdCounter
        self.title = title
        self.description = description
        self.documentReference = documentReference // Initialize the DocumentReference
    }
    
    init(title: String, description: String) {
        Skill.skillIdCounter += 1
        self.skillId = Skill.skillIdCounter
        self.title = title
        self.description = description
    }
    
}
struct LearningRequest: Equatable {
    
    static func == (lhs: LearningRequest, rhs: LearningRequest) -> Bool {
        return lhs.requestId == rhs.requestId
    }
    
    static var requestIdCounter: Int = 0
    var requestId: Int
    var title: String = ""
    var isApproved: Bool?
    var type: String = ""
    var summary: String = ""
    var link: String = ""
    var requester: User?
    var skillToDevelop: String? //since the skill will be displayed in a drop down list there wont be a problem to use its title
    
    init(isApproved: Bool?, type: String, summary: String, link: String, requester: User?, skillToDevelop: String) {
        
        LearningRequest.requestIdCounter += 1
        requestId = LearningRequest.requestIdCounter
        self.isApproved = isApproved
        self.type = type
        self.summary = summary
        self.link = link
        self.requester = requester
        self.skillToDevelop = skillToDevelop
        
    }
    
    init(title: String, isApproved: Bool?){
        
        LearningRequest.requestIdCounter += 1
        requestId = LearningRequest.requestIdCounter
        self.title = title
        self.isApproved = isApproved
        
    }
    
    
}

//enum LearningRequestStatus: String {
//    case Pending
//    case Approved
//    case Rejected
//}
