//
//  CareerResources.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//
import Foundation

struct CareerPath {
    var careerId: Int
    var careerName: String
    var demand: Demand
    var roadmap: String
}

enum Demand: String {
    case high
    case medium
    case low
}

struct LearningResource {
    var learningResourceId: Int
    var type: LearningResourceType
    var summary: String
    var link: String
}

enum LearningResourceType: String {
    case Course
    case Article
    case Certification
}

struct Skill {
    var skillId: Int
    var title: String
    var description: String
    var learningResources: [LearningResource]
}

struct LearningRequest {
    var requestId: Int
    var status: LearningRequestStatus
    var type: LearningResourceType
    var summary: String
    var link: String
}

enum LearningRequestStatus: String {
    case Pending
    case Approved
    case Rejected
}
