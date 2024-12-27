//
//  CareerResources.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//
import Foundation
import FirebaseFirestore



struct CareerPath: Equatable {
    
    static func == (lhs: CareerPath, rhs: CareerPath) -> Bool {
        return lhs.careerId == rhs.careerId
    }
    
    static var careerIdCounter: Int  = 200// 200 is the default value of the last career ID cannot be found
    var careerId: Int
    var description: String? = ""
    var title: String
    var demand: String? = ""
    var roadmap: String? = ""
    
    init(careerName: String, demand: String?, roadmap: String, description: String) {
            self.careerId = CareerPath.careerIdCounter + 1 // Use the updated careerIdCounter
            CareerPath.careerIdCounter += 1 // Increment for the next instance
            self.title = careerName
            self.demand = demand
            self.roadmap = roadmap
            self.description = description
    }
    
    //init for fetching and constructing
    init(careerId: Int , title: String){
        self.title = title
        self.careerId = careerId
    }
    
    

    // Fetch the highest careerPathId (call this before creating any CareerPath)
    static func fetchAndID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("careerPaths")
                .order(by: "careerPathId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        careerIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["careerPathId"] as? Int {
                            careerIdCounter = highestId
                        } else {
                            careerIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        careerIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
        }
    
}

enum Demand: String {
    case high
    case medium
    case low
}


struct LearningResource: Equatable, Codable {
    
    static func == (lhs: LearningResource, rhs: LearningResource) -> Bool {
        return lhs.learningResourceId == rhs.learningResourceId
    }
    
    static var resourceIdCounter: Int = 200
    var learningResourceId: Int = 0
    var type: String? = ""
    var summary: String? = ""
    var link: String? = ""
    var title: String? = ""
    var datePublished: Date = Date()
    var skillRef: DocumentReference? // Firestore DocumentReference for the skill
    var skillToDevelop: String = ""
    // Default initializer
    init() {
        //will generate an id in the learning resources counter for the request to be resource
        LearningResource.resourceIdCounter += 1
        self.learningResourceId = LearningResource.resourceIdCounter
        
    }
    
    init(type: String, summary: String, link: String, title: String, skillRef: DocumentReference) {
        LearningResource.resourceIdCounter += 1
        self.learningResourceId = LearningResource.resourceIdCounter
        self.type = type
        self.summary = summary
        self.link = link
        self.title = title // Set the title
        self.skillRef = skillRef
    }
    

    init(id: Int,type: String, summary: String, link: String, title: String, skillRef: DocumentReference){
        self.learningResourceId = id
        self.type = type
        self.summary = summary
        self.link = link
        self.title = title // Set the title
        self.skillRef = skillRef
    }

    init( id: Int , type: String, summary: String, link: String, title: String, skillToDevelop: String) {
         
        self.learningResourceId = id
        self.title = title
         self.learningResourceId = LearningResource.resourceIdCounter
         self.type = type
         self.summary = summary
         self.link = link
         self.skillToDevelop = skillToDevelop
         
     }
    
    static func fetchAndSetID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("LearningResources")
                .order(by: "learningResourceId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        resourceIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["learningResourceId"] as? Int {
                            resourceIdCounter = highestId
                        } else {
                            resourceIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        resourceIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
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
    
    static var skillIdCounter: Int = 30
    var skillId: Int
    var title: String
    var description: String
    var documentReference: DocumentReference? // Firestore DocumentReference for the skill

    init(title: String, description: String, documentReference: DocumentReference) {
        Skill.skillIdCounter += 1
        self.skillId = Skill.skillIdCounter
        self.title = title
        self.description = description
        self.documentReference = documentReference // Initialize the DocumentReference
    }
    
    init(title: String, description: String) {
        Skill.skillIdCounter += 1
        self.skillId = Skill.skillIdCounter
        self.title = title
        self.description = description
    }
    
    //for fetching skills
    init(skillId: Int, title: String, description: String, documentReference: DocumentReference) {

        self.skillId = skillId
        self.title = title
        self.description = description
        self.documentReference = documentReference // Initialize the DocumentReference
    }
    static func fetchAndSetID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("skills")
                .order(by: "skillId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        skillIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["skillId"] as? Int {
                            skillIdCounter = highestId
                        } else {
                            skillIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        skillIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
        }
    
}
struct LearningRequest: Equatable {
    
    static func == (lhs: LearningRequest, rhs: LearningRequest) -> Bool {
        return lhs.requestId == rhs.requestId
    }
    
    static var requestIdCounter: Int = 30
    var requestId: Int
    var title: String = ""
    var isApproved: Bool?
    var type: String = ""
    var summary: String = ""
    var link: String = ""
    var requester: User?
    var skillToDevelop: String? //since the skill will be displayed in a drop down list there wont be a problem to use its title
    
    init( type: String, summary: String, link: String, requester: User?, skillToDevelop: String) {
        
        LearningRequest.requestIdCounter += 1
        requestId = LearningRequest.requestIdCounter
        self.type = type
        self.summary = summary
        self.link = link
        self.requester = requester
        self.skillToDevelop = skillToDevelop
        
    }
    
    init(title: String){
        LearningRequest.requestIdCounter += 1
        requestId = LearningRequest.requestIdCounter
        self.title = title
        isApproved = nil
    }
    
    init(requestId: Int, title: String, isApproved: Bool?){

        self.requestId = requestId
        self.title = title
        self.isApproved = isApproved
        
    }
    
    static func fetchAndSetID(completion: @escaping () -> Void) {
            let db = Firestore.firestore()

            db.collection("LearningResourcesRequests")
                .order(by: "requestId", descending: true)
                .limit(to: 1)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        requestIdCounter = 200 // Default
                    } else if let snapshot = querySnapshot, let document = snapshot.documents.first {
                        if let highestId = document.data()["requestId"] as? Int {
                            requestIdCounter = highestId
                        } else {
                            requestIdCounter = 200 // Default if missing or invalid
                        }
                    } else {
                        requestIdCounter = 200 // Default if no documents
                    }
                    completion() // Notify when done
                }
        }
    
    
}




final class resourceManager {
    
    private init() {} // Singleton
    
    // Current logged in user - seeker details
    private static let UserCollection = Firestore.firestore().collection("seekerDetails")
    
    static func saveLearningResource(learningResource: LearningResource) async throws {
        do {
            // Get a reference to the Firestore collection
            let userCollectionRef = Firestore.firestore().collection("users")
            
            // Query to find the document with the specific userId
            let userQuerySnapshot = try await userCollectionRef.whereField("userId", isEqualTo: currentLoggedInUserID).getDocuments()
            
            // Check if a user document is found
            guard let userDocument = userQuerySnapshot.documents.first else {
                print("No user document found with userId = \(currentLoggedInUserID)")
                return
            }
            
            // Extract the user reference
            let userReference = userDocument.reference
            
            // Get the seekerDetails collection reference
            let testingCollectionRef = Firestore.firestore().collection("seekerDetails")
            
            // Query to find the document with the user reference
            let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
            
            // Loop through the documents to find the correct one
            for document in testingQuerySnapshot.documents {
                
                let resourceData = try DB.encoder.encode(learningResource)
                
                // Append the resource array in the found document
                try await document.reference.updateData([
                    "savedLearningResourcesList": FieldValue.arrayUnion([resourceData])
                ])
                
                print("Resource added successfully")
                return // Exit after adding the resource ID
            }
            
            print("No document found in seekerDetails with userID reference.")
            
        } catch {
            print("Error adding resource: \(error.localizedDescription)")
            throw error // Re-throw the error for further handling
        }
    }
    
    
    static func isResourceSaved(learningResource: LearningResource) async throws -> Bool {
        // Get a reference to the Firestore collections
        let userCollectionRef = Firestore.firestore().collection("users")
        
        // Get user ID from the currently logged-in user
        let userQuerySnapshot = try await userCollectionRef.whereField("userId", isEqualTo: currentLoggedInUserID).getDocuments()
        
        // Check if a user document is found
        guard let userDocument = userQuerySnapshot.documents.first else {
            print("No user document found with userId = \(currentLoggedInUserID)")
            return false
        }
        
        // Extract the user reference
        let userReference = userDocument.reference
        
        // Get the seekerDetails collection reference
        let testingCollectionRef = Firestore.firestore().collection("seekerDetails")
        
        // Query to find the document with the user reference
        let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
        
        // Loop through the documents to find the correct one
        for document in testingQuerySnapshot.documents {
            // Get saved learning resources from the document
            let savedResources = document.data()["savedLearningResourcesList"] as? [[String: Any]] ?? []
            
            // Check if the learning resource exists in the savedResources array
            for resourceData in savedResources {
                if let savedResourceId = resourceData["learningResourceId"] as? Int,
                   savedResourceId == learningResource.learningResourceId {
                    return true // Resource is saved
                }
            }
        }
        
        return false // Resource not found in saved resources
    }
    
    static func removeLearningResource(learningResource: LearningResource) async throws {
        do {
            // Get a reference to the Firestore collection
            let userCollectionRef = Firestore.firestore().collection("users")
            
            // Query to find the document with the specific userId
            let userQuerySnapshot = try await userCollectionRef.whereField("userId", isEqualTo: currentLoggedInUserID).getDocuments()
            
            // Check if a user document is found
            guard let userDocument = userQuerySnapshot.documents.first else {
                print("No user document found with userId = \(currentLoggedInUserID)")
                return
            }
            
            // Extract the user reference
            let userReference = userDocument.reference
            
            // Get the seekerDetails collection reference
            let testingCollectionRef = Firestore.firestore().collection("seekerDetails")
            
            // Query to find the document with the user reference
            let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
            
            // Loop through the documents to find the correct one
            for document in testingQuerySnapshot.documents {
                // Get saved learning resources from the document
                let savedResources = document.data()["savedLearningResourcesList"] as? [[String: Any]] ?? []
                
                // Find the resource with the same learningResourceId
                if let index = savedResources.firstIndex(where: { ($0["learningResourceId"] as? Int) == learningResource.learningResourceId }) {
                    // Remove the resource from the array
                    var updatedResources = savedResources
                    updatedResources.remove(at: index)
                    
                    // Update the Firestore document with the new array
                    try await document.reference.updateData([
                        "savedLearningResourcesList": updatedResources
                    ])
                    
                    print("Resource removed successfully")
                    return
                }
            }
            
            print("Resource not found in saved resources.")
            
        } catch {
            print("Error removing resource: \(error.localizedDescription)")
            throw error // Re-throw the error for further handling
        }
    }
    

    
    
    
}
