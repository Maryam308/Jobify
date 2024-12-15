//
//  User.swift
//  Jobify
//
//  Created by Maryam Ahmed on 15/12/2024.
//

import Foundation
import Firebase

struct User {
   var userID: String
   var name: String
   var email: String
   var role: UserType
   var seekerDetails: SeekerDetails?
   var employerDetails: EmployerDetails?
   var adminDetails: AdminDetails?
    init(userID: String, name: String, email: String, role: UserType) {
       self.userID = userID
       self.name = name
       self.email = email
       self.role = role
   }
}

enum UserType: String {
    case seeker
    case employer
    case admin
}



