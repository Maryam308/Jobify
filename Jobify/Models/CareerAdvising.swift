//
//  CareerAdvising.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

struct CareerPath {
    let careerId: Int
    let careerName: String
    let demand: Demand
    let roadmap: String
}

enum Demand: String {
    case high
    case medium
    case low
}

struct LearningResource {
    let learningResourceId: Int
    let type: LearningResourceType
    let summary: String
    let link: String
}

enum LearningResourceType: String {
    case course
    case article
    case certification
}

struct Skill {
    let skillId: Int
    let title: String
    let description: String
    let learningResources: [LearningResource]
}

struct LearningRequest {
    let requestId: Int
    let status: LearningRequestStatus
    let resource: LearningResource
}

enum LearningRequestStatus: String {
    case pending
    case approved
    case rejected
}
