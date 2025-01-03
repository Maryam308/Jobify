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

            // Hex color code: 1D2D44
            let hexCode: Int = 0x1D2D44

            // Extract RGB components
            let red = CGFloat((hexCode >> 16) & 0xFF) / 255.0   // Extract red component
            let green = CGFloat((hexCode >> 8) & 0xFF) / 255.0  // Extract green component
            let blue = CGFloat(hexCode & 0xFF) / 255.0          // Extract blue component

            // Create the UIColor
            let customColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

            // Apply the color to the tab bar items
            UITabBar.appearance().tintColor = customColor
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        print("Database Configured Successfully")
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

