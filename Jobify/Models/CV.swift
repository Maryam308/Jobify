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

final class CVManager {
    
    private init() {} // Singleton
    private static let CVCollection = Firestore.firestore().collection(DB.FStore.CV.collectionName)

    // Get documents
    private static func CVDocument(documentId: String) -> DocumentReference {
        CVCollection.document(documentId)
    }

    static func createNewCV(cv: CV) async throws {
          do {
              // Fetch all existing CVs
              let existingCVs = try await getAllCVs()
              let isFavorite = existingCVs.isEmpty // If there are no existing CVs, set isFavorite to true

              // Create new CV with updated isFavorite
              var newCV = cv
              newCV.isFavorite = isFavorite // Set the isFavorite based on existing CVs
              
              let data = try DB.encoder.encode(newCV) // Use the DB encoder
              let docRef = try await CVCollection.addDocument(data: data)

              // Update the CV ID in Firestore
              try await CVDocument(documentId: docRef.documentID).updateData([
                  DB.FStore.CV.cvID: docRef.documentID
              ])
          } catch {
              print("Error creating CV: \(error.localizedDescription)")
              throw error // Re-throw the error for further handling
          }
      }

    
    // Function to fetch all CVs
    static func getAllCVs() async throws -> [CV] {
        let snapshot = try await CVCollection.getDocuments()
        print("Fetched \(snapshot.documents.count) CVs.")
        return snapshot.documents.compactMap { document in
            do {
                let cv = try document.data(as: CV.self)
                print("Successfully decoded CV: \(cv)")
                return cv
            } catch {
                print("Error decoding CV for document ID \(document.documentID): \(error)")
                return nil
            }
        }
    }
    
    //function to update cvs
    static func updateExistingCV(cvID: String, cv: CV) async throws {
        do {
            // Use the DB encoder to prepare the data
            let data = try DB.encoder.encode(cv)

            // Update the document in Firestore, merge true to keep existing fields
            try await CVDocument(documentId: cvID).setData(data, merge: true)
            
            print("CV updated successfully.")
        } catch {
            print("Error updating CV: \(error.localizedDescription)")
            throw error // Re-throw the error for further handling
        }
    }
}
