//
//  Employer.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
struct Employer {
    var name: String
    var email: String
    var password: String
    var reEnterPassword: String
    var mainCompanyCategory: String
    var country: String
    var city: String
}

enum MainCompanyCategory: String, CaseIterable {
    case technology = "Technology"
    case finance = "Finance"
    case healthCare = "Healthcare"
    case education = "Education"
    case retail = "Retail"
    case manufacturing = "Manufacturing"
    case hospitality = "Hospitality"
    case other = "Other"
}
