import Foundation
import Firebase
import FirebaseFirestore

struct CV: Codable {
    var cvID: String
    var personalDetails: PersonalDetails
    var education: [Education]
    var skills: [String]
    var workExperience: [WorkExperience]
    var cvTitle: String
    var creationDate: Date
    
    init(personalDetails: PersonalDetails, skills: [String], education: [Education], workExperience: [WorkExperience],cvTitle: String,creationDate: Date = Date()) {
        self.cvID = UUID().uuidString
        self.personalDetails = personalDetails
        self.skills = skills
        self.education = education
        self.workExperience = workExperience
        self.cvTitle = cvTitle
        self.creationDate = creationDate
    }
}

struct PersonalDetails: Codable {
    var name: String
    var email: String
    var phoneNumber: String
    var country: String
    var city: String
    var profilePicture: String?

    init(name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: String? = nil) {
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

struct WorkExperience: Codable {
    var workExperienceID: String
    var company: String
    var role: String
    var startDate: Date
    var endDate: Date?
    var keyResponsibilities: String

    init(company: String, role: String, startDate: Date, endDate: Date? = nil, keyResponsibilities: String) {
        self.workExperienceID = UUID().uuidString
        self.company = company
        self.role = role
        self.startDate = startDate
        self.endDate = endDate
        self.keyResponsibilities = keyResponsibilities
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
    
    private init(){} //singleton
        private static let CVCollection = Firestore.firestore().collection(DB.FStore.CV.collectionName)
        //get documents
        private static func CVDocment(documentId: String) -> DocumentReference{
            CVCollection.document(documentId)
        }
    static func createNewCV(cv: CV) async throws {
        let docRef = try await CVCollection.addDocument(data: Firestore.Encoder().encode(cv))

        try await CVDocment(documentId: docRef.documentID).updateData([
            DB.FStore.CV.cvID: docRef.documentID
        ])
    }
    
    // Function to fetch all CVs
    static func getAllCVs() async throws -> [CV] {
        let snapshot = try await CVCollection.getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: CV.self)
        }
    }
}
