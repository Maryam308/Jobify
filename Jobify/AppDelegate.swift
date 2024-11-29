//
//  AppDelegate.swift
//  Jobify
//
//  Created by Maryam Yousif on 18/11/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        print("Database Configured Successfully")
        let db = Firestore.firestore()

        // Perform Firestore operation in the background
        DispatchQueue.global(qos: .background).async {
            db.collection("users").document("user1").setData([
                "name": "John Doe",
                "age": 30
            ]) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error writing document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully written to Firestore!")
                    }
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

