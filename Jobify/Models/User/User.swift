//
//  User.swift
//  Jobify
//
//  Created by Maryam Ahmed on 15/12/2024.
//

import Foundation
import Firebase

struct User {
   var userID: Int
   static var userIdCounter: Int = 150
   var name: String
   var email: String
    var imageURL: String? = nil
   var role: UserType
   var seekerDetails: SeekerDetails?
   var employerDetails: EmployerDetails?
   var adminDetails: AdminDetails?
    init(userID: Int, name: String, email: String, role: UserType, imageURL: String?) {
       self.userID = userID
       self.name = name
       self.email = email
       self.role = role
        self.imageURL = imageURL
   }
    
    init( name: String, email: String, role: UserType) {
        User.userIdCounter += 1
//        let randomMaxInteger = Int.random(in: 1...Int.max)
       self.userID =  User.userIdCounter
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

class UserSession {
    static let shared = UserSession() // make the singleton instance

    var loggedInUser: User?

    private init() {} // Private initializer to prevent creating multiple instances
}


