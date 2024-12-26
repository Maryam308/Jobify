import Foundation
import Firebase
import FirebaseFirestore

struct CV: Codable {
    var cvID: String
    var personalDetails: PersonalDetails
    var education: [Education]
    var skills: [cvSkills]
    var workExperience: [WorkExperience]
    var cvTitle: String
    var creationDate: Date
    var preferredTitle: String
    var isFavorite: Bool?

    init(cvID: String = UUID().uuidString, personalDetails: PersonalDetails, skills: [cvSkills], education: [Education], workExperience: [WorkExperience], cvTitle: String, creationDate: Date = Date(), preferredTitle: String, isFavorite: Bool? = nil) {
        self.cvID = cvID
        self.personalDetails = personalDetails
        self.skills = skills
        self.education = education
        self.workExperience = workExperience
        self.cvTitle = cvTitle
        self.creationDate = creationDate
        self.preferredTitle = preferredTitle
        self.isFavorite = isFavorite
    }
}

struct PersonalDetails: Codable {
    var name: String
    var email: String
    var phoneNumber: String
    var country: String
    var city: String
    var profilePicture: String

    init(name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: String) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.country = country
        self.city = city
        self.profilePicture = profilePicture
    }
}

struct Education: Codable {
    var degree: String?
    var institution: String?
    var startDate: Date?
    var endDate: Date?

    init(degree: String, institution: String, startDate: Date, endDate: Date?) {
        self.degree = degree
        self.institution = institution
        self.startDate = startDate
        self.endDate = endDate
    }
    init() {
        
    }
}

struct cvSkills: Codable {
    var skillTitle: String?
    init(title: String){
        self.skillTitle = title
    }
    init(){
        
    }
}

struct WorkExperience: Codable {
    var workExperienceID: String?
    var company: String?
    var role: String?
    var startDate: Date?
    var endDate: Date?
    var keyResponsibilities: String?

    init(company: String, role: String, startDate: Date, endDate: Date? = nil, keyResponsibilities: String) {
        self.workExperienceID = UUID().uuidString
        self.company = company
        self.role = role
        self.startDate = startDate
        self.endDate = endDate
        self.keyResponsibilities = keyResponsibilities
    }
    
    init(){
        
    }
}



struct DB{
    static let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }()

    static let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()

    static let appName = "Jobify"
    
    struct FStore{
        struct CV{
            static let collectionName = "CVs"
            static let cvID = "cvID"
            static let personalDetails = "personalDetails"
            static let education = "education"
            static let skills = "skills"
            static let workExperience = "workExperience"
            static let cvTitle = "cvTitle"
            static let creationDate = "creationDate"
        }
    }
}
let currentLoggedInUserID = 99
final class CVManager {
    
    private init() {} // Singleton
    private static let CVCollection = Firestore.firestore().collection(DB.FStore.CV.collectionName)
    //current logged in user - seeker details
    private static let UserCollection = Firestore.firestore().collection("MaryamForTesting")
    // Get documents
    private static func CVDocument(documentId: String) -> DocumentReference {
        CVCollection.document(documentId)
    }
    
    
    static func addNewCV(cv: CV) async throws {
        do {
            // Fetch all existing CVs
            let existingCVs = try await getUserAllCVs()
            let isFavorite = existingCVs.isEmpty // If there are no existing CVs, set isFavorite to true
            
            // Create new CV with updated isFavorite
            var newCV = cv
            newCV.isFavorite = isFavorite // Set the isFavorite based on existing CVs
            
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
            
            // Get the MaryamForTesting collection reference
            let testingCollectionRef = Firestore.firestore().collection("MaryamForTesting")
            
            // Query to find the document with the user reference
            let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
            
            // Loop through the documents to find the correct one
            for document in testingQuerySnapshot.documents {
                // Encode the CV directly
                let cvData = try DB.encoder.encode(newCV)
                
                // Append the new CV to the seekerCVs array in the found document
                try await document.reference.updateData([
                    "seekerCVs": FieldValue.arrayUnion([cvData])
                ])
                
                print("CV added successfully to seekerCVs.")
                return // Exit after adding the CV
            }
            
            print("No document found in MaryamForTesting with userID reference.")
            
        } catch {
            print("Error adding CV: \(error.localizedDescription)")
            throw error // Re-throw the error for further handling
        }
    }
    
    // Function to fetch all CVs for the current logged in user
    static func getUserAllCVs() async throws -> [CV] {
        // Get a reference to the Firestore collection for users
        let userCollectionRef = Firestore.firestore().collection("users")
        
        // Query to find the document with the specific userId
        let userQuerySnapshot = try await userCollectionRef.whereField("userId", isEqualTo: currentLoggedInUserID).getDocuments()
        
        // Check if a user document is found
        guard let userDocument = userQuerySnapshot.documents.first else {
            print("No user document found with userId = \(currentLoggedInUserID)")
            return []
        }
        
        // Extract the user reference
        let userReference = userDocument.reference
        
        // Get the MaryamForTesting collection reference
        let testingCollectionRef = Firestore.firestore().collection("MaryamForTesting")
        
        // Query to find the document with the user reference
        let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
        
        // Initialize an array to hold all CVs
        var allCVs: [CV] = []
        
        // Loop through the documents to find the correct one
        for document in testingQuerySnapshot.documents {
            // Fetch the seekerCVs array from the document
            if let seekerCVs = document.data()["seekerCVs"] as? [[String: Any]] {
                // Decode each CV in the seekerCVs array
                for cvData in seekerCVs {
                    do {
                        let cv = try DB.decoder.decode(CV.self, from: cvData)
                        print("Successfully decoded CV: \(cv)")
                        allCVs.append(cv)
                    } catch {
                        print("Error decoding CV for document ID \(document.documentID): \(error)")
                    }
                }
            }
        }
        
        print("Fetched \(allCVs.count) CVs for the user.")
        return allCVs
    }
    
    
    
    //function to update cvs
    static func updateExistingCV(cvID: String, updatedCV: CV) async throws {
        do {
            // Get a reference to the Firestore collection for users
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
            
            // Get the MaryamForTesting collection reference
            let testingCollectionRef = Firestore.firestore().collection("MaryamForTesting")
            
            // Query to find the document with the user reference
            let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
            
            // Loop through the documents to find the correct one
            for document in testingQuerySnapshot.documents {
                // Fetch the seekerCVs array from the document
                if var seekerCVs = document.data()["seekerCVs"] as? [[String: Any]] {
                    // Find the index of the CV with the matching cvID
                    if let index = seekerCVs.firstIndex(where: { $0["cvID"] as? String == cvID }) {
                        // Encode the updated CV to a dictionary
                        let updatedCVData = try DB.encoder.encode(updatedCV)
                        
                        // Replace the existing CV with the updated one
                        seekerCVs[index] = updatedCVData
                        
                        // Update the document in Firestore
                        try await document.reference.updateData([
                            "seekerCVs": seekerCVs
                        ])
                        
                        print("CV updated successfully.")
                        return
                    } else {
                        print("CV with ID \(cvID) not found in seekerCVs.")
                    }
                } else {
                    print("No seekerCVs array found in document ID \(document.documentID).")
                }
            }
            
            print("No document found in MaryamForTesting with userID reference.")
            
        } catch {
            print("Error updating CV: \(error.localizedDescription)")
            throw error // Re-throw the error for further handling
        }
    }
    
    static func deleteCV(cvId: String) async throws {
        // Get a reference to the Firestore collection for users
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
        
        // Get the MaryamForTesting collection reference
        let testingCollectionRef = Firestore.firestore().collection("MaryamForTesting")
        
        // Query to find the document with the user reference
        let testingQuerySnapshot = try await testingCollectionRef.whereField("userID", isEqualTo: userReference).getDocuments()
        
        // Check if a testing document is found
        guard let testingDocument = testingQuerySnapshot.documents.first else {
            print("No testing document found for user.")
            return
        }
        
        // Get the current seekerCVs array
        let seekerCVsField = "seekerCVs"
        let documentSnapshot = try await testingDocument.reference.getDocument()
        
        // Ensure the seekerCVs array exists
        guard var seekerCVs = documentSnapshot.data()?[seekerCVsField] as? [[String: Any]] else {
            print("No seekerCVs found.")
            return
        }
        
        // Filter out the CV to delete
        seekerCVs.removeAll { $0["cvID"] as? String == cvId }
        
        // Update the document with the new seekerCVs array
        try await testingDocument.reference.updateData([seekerCVsField: seekerCVs])
        
        print("CV with ID \(cvId) deleted successfully.")
    }
    
}
