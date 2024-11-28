//
//  Job.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct Job {
    static var jobIdCounter = 0
    var jobId: Int
    var company: String
    var date: Date
    var time: String
    var level: String
    var location: String
    var description: String
    var requirement: String
    //var applications: [Application] = []
    var deadline: Date
    
    
    // Custom initializer
    init(company: String, date: Date, time: String, level: String, location: String, description: String, requirement: String, deadline: Date) {
        // Increment the counter and assign it as jobId
        Job.jobIdCounter += 1
        self.jobId = Job.jobIdCounter
        
        // Assign other properties
        self.company = company
        self.date = date
        self.time = time
        self.level = level
        self.location = location
        self.description = description
        self.requirement = requirement
        self.deadline = deadline
    }
    
}



enum EmploymentType: String {
    case fullTime = "Full-Time"
    case partTime = "Part-Time"
    case intern = "Intern"
    case contract = "Contract"
}


