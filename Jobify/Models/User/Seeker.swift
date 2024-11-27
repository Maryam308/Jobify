//
//  Seeker.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct Seeker {
    var username: String
    var fullName: String
    var email: String
    var password: String
    var reEnterPassword: String
    var currentJobPosition: String
    var country: String
    var city: String
}

enum JobPosition: String {
    case developer = "Developer"
    case designer = "Designer"
    case manager = "Project Manager"
    case softwareDeveloper = "Software Developer"
    case uiUxDesigner = "UI/UX Designer"
    case dataAnalyst = "Data Analyst"
    case productManager = "Product Manager"
    case marketingSpecialist = "Marketing Specialist"
    case nurse = "Nurse"
    case teacher = "Teacher"
    case customerServiceRepresentative = "Customer Service Representative"
    case other = "Other" // Optional for categories not listed
}
