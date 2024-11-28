//
//  Job.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation


struct Job {
    // Auto-generated variables
    static var jobIdCounter = 0
    var jobId: Int
    var date: String
    var time: String
    // Create a Calendar instance to format the date and time
    var calendar = Calendar.current

    // Passed variables
    var title: String
    var company: Employer
    var level: String
    var location: String
    var desc: String
    var requirement: String
    var extraAttachments: Data? = nil
    var employmentType: EmploymentType
    var deadline: Date

    var applications: [JobApplication] = []

    // Custom initializer
    init(
        title: String,
        company: inout Employer,
        level: String,
        location: String,
        desc: String,
        requirement: String,
        extraAttachments: Data?,
        employmentType: EmploymentType,
        deadline: Date
    ) {
        // Auto-generated variables
        // Increment the counter and assign it as jobId
        Job.jobIdCounter += 1
        self.jobId = Job.jobIdCounter

        // Get the current date and time
        let currentDate = Date()

        // Extract the date components for the date
        let dateComponents = self.calendar.dateComponents([.day, .month], from: currentDate)
        let timeComponents = self.calendar.dateComponents([.hour, .minute], from: currentDate)

        // Create date and time variables and convert date and time components to string
        self.date = String(format: "%02d-%02d", dateComponents.day ?? 0, dateComponents.month ?? 0)
        self.time = String(format: "%02d:%02d", timeComponents.hour ?? 0, timeComponents.minute ?? 0)

        // Assign other properties
        self.title = title
        self.company = company
        self.level = level
        self.location = location
        self.desc = desc
        self.requirement = requirement
        self.employmentType = employmentType
        self.deadline = deadline

        // Handle extraAttachments
        if let attachment = extraAttachments {
            self.extraAttachments = attachment
        } else {
            self.extraAttachments = nil
        }
    }
    enum EmploymentType: String {
        case fullTime = "Full-Time"
        case partTime = "Part-Time"
        case intern = "Intern"
        case contract = "Contract"
    }
}



