//
//  CareerResources.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//
import Foundation

struct CareerPath: Equatable {
    
    static func == (lhs: CareerPath, rhs: CareerPath) -> Bool {
        return lhs.careerId == rhs.careerId
    }
    
    static var careerIdCounter: Int = 0
    var careerId: Int
    var careerName: String
    var demand: Demand
    var roadmap: String
    
    init(careerName: String, demand: Demand, roadmap: String) {
        careerId = CareerPath.careerIdCounter
        self.careerName = careerName
        self.demand = demand
        self.roadmap = roadmap
    }
    
}

enum Demand: String {
    case high
    case medium
    case low
}

struct LearningResource: Equatable{
    
    static func == (lhs: LearningResource, rhs: LearningResource) -> Bool {
        return lhs.learningResourceId == rhs.learningResourceId
    }
    
    static var resourceIdCounter: Int = 0
    var learningResourceId: Int
    var type: LearningResourceType
    var summary: String
    var link: String
    var skillToDevelop: String //since the skill will be displayed in a drop down list there wont be a problem to use its title
    
    init(type: LearningResourceType, summary: String, link: String, skillToDevelop: String) {
        
        LearningResource.resourceIdCounter += 1
        
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
    var learningResources: [LearningResource] = []
    
    init(title: String, description: String) {
        Skill.skillIdCounter += 1
        self.skillId = Skill.skillIdCounter
        self.title = title
        self.description = description
    }
    
}

struct LearningRequest {
    static var requestIdCounter: Int = 0
    var requestId: Int
    var status: LearningRequestStatus
    var type: LearningResourceType
    var summary: String
    var link: String
    var requester: Employer
    var skillToDevelop: String //since the skill will be displayed in a drop down list there wont be a problem to use its title
    
    init(status: LearningRequestStatus, type: LearningResourceType, summary: String, link: String, requester: Employer, skillToDevelop: String) {
        
        LearningRequest.requestIdCounter += 1
        requestId = LearningRequest.requestIdCounter
        self.status = status
        self.type = type
        self.summary = summary
        self.link = link
        self.requester = requester
        self.skillToDevelop = skillToDevelop
    }
    
}

enum LearningRequestStatus: String {
    case Pending
    case Approved
    case Rejected
}
