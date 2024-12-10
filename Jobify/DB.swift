//
//  DB.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import Foundation
import FirebaseFirestore
import Firebase

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
        struct Admins{
            static let collectionName = "admins"
            //all fields
            static let admin_id = "admin_id"
            
        }
        struct Seekers{
            static let collectionName = "seekers"
            
        }
        
        struct Employers{
            static let collectionName = "employers"
        }
        
        struct CVTest{
            static let collectionName = "CVs"
            static let id = "id"
            static let name = "name"
            static let city = "city"
        }
    }
}



