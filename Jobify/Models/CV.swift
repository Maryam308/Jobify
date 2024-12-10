import Foundation
import Firebase
import FirebaseFirestore
//for testing only
struct CVTest : Codable {
    var id: String
    var name: String
    var city: String
}


// CV model containing all the user information needed for the CV
struct CV {
    
    //Auto-generated variabels
    static var cvIDCounter = 0 // Static counter for generating unique CV ID
    var cvID: Int
    
    //Passed variables
    var personalDetails: PersonalDetails
    var education: [Education] = []
    var skills: [String] = []
    var workExperience: [WorkExperience] = []
    var name : String
    var email : String
    var phoneNumber : String
    var country : String
    var city : String
    var profilePicture : Data?
    
    

    
    init(personalDetails: PersonalDetails, skills: [String], education: [Education], workExperience: [WorkExperience], name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: Data? = nil) {
        
        //Auto-gnerated variabels
        CV.cvIDCounter = 0 // Static counter for generating unique education ID
        cvID = CV.cvIDCounter
        
        
        self.personalDetails = personalDetails
        self.skills = skills
        self.education = education
        self.workExperience = workExperience
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.country = country
        self.city = city
        self.profilePicture = profilePicture
    }
    
    
}


// Personal details struct containing basic info about the user
struct PersonalDetails {
    var name : String
    var email : String
    var phoneNumber : String
    var country : String
    var city : String
    var profilePicture : Data?
    
    init(name: String, email: String, phoneNumber: String, country: String, city: String, profilePicture: Data? = nil) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.country = country
        self.city = city
        self.profilePicture = profilePicture
    }

}

// Education struct to store educational background info
struct Education {
   
    //Auto-gnerated variabels
    static var educationIdCounter = 0 // Static counter for generating unique education ID
    var educationID: Int
    
    //Passed variables
    var degree: String
    var institution: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
    
    // Custom initializer
    init(
        degree: String,
        institution: String,
        startDate: Date,
        endDate: Date? = nil)
        {
            Education.educationIdCounter+=1
            self.educationID = Education.educationIdCounter
            
            self.degree = degree
            self.institution = institution
            self.startDate = startDate
            self.endDate = endDate
    }
}

// Skill struct to store seeker's skill info
struct CVSkill{
    
    //Auto-gnerated variabels
    static var skillIDCounter = 0 // Static counter for generating unique education ID
    var skillID: Int
    
    //Passed variables
    var skillDescription: String

    
    // Custom initializer
    init(skillDescription: String) {
        
        CVSkill.skillIDCounter+=1
        skillID=CVSkill.skillIDCounter
        
        self.skillDescription = skillDescription
    }

}

// Work experience struct to store job-related experience
struct WorkExperience {
   
    static var workExperienceIDCounter = 0 // Static counter for generating unique working experince ID
    var workExperienceID: Int
    
    var company: String
    var role: String
    var startDate: Date
    var endDate: Date?  // Optional (could be ongoing)
    var keyResponsibilities: String
    
    // Custom initializer
    init(company: String, role: String, startDate: Date, endDate: Date? = nil, keyResponsibilities: String) {
        
        WorkExperience.workExperienceIDCounter+=1
        workExperienceID=WorkExperience.workExperienceIDCounter
        
        self.company = company
        self.role = role
        self.startDate = startDate
        self.endDate = endDate
        self.keyResponsibilities = keyResponsibilities
    }
    
}

final class CVManager{
    private init(){} //singleton
    private static let CVCollection = Firestore.firestore().collection(DB.FStore.CVTest.collectionName)
    //get documents
    private static func CVDocment(documentId: String) -> DocumentReference{
        CVCollection.document(documentId)
    }
    
    static func createNewCV(cv: CVTest) async throws {
        // Add document to Firestore and get the document ID
        let docRef = try await CVCollection.addDocument(data: Firestore.Encoder().encode(cv))

        // Update the document with the auto-generated document ID
        try await CVDocment(documentId: docRef.documentID).updateData([
            DB.FStore.CVTest.id: docRef.documentID
        ])
    }
    
    static func getAllCVs() async throws  -> [CVTest]{
        try await CVCollection.getDocuments().documents.compactMap { doc in
            try doc.data(as: CVTest.self)
        }
    }
    
    static func updateCV(cv: CVTest) async throws {
        try await CVDocment(documentId: cv.id).updateData(Firestore.Encoder().encode(cv))
    }
    
    static func updateCV(docID: String, fields: [String: Any]) async throws {
        try await CVDocment(documentId: docID).updateData(fields)
    }

}
