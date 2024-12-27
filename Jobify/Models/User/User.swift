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
   static var userIdCounter: Int = 200
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
       self.userID =  User.userIdCounter
       self.name = name
       self.email = email
       self.role = role
   }
    
    static func fetchAndSetID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("users")
                .order(by: "userId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        userIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["userId"] as? Int {
                            userIdCounter = highestId
                        } else {
                            userIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        userIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
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


