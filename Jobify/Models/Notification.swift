//
//  Notification.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 27/11/2024.
//

import Foundation

struct Notification{
    static var notificationIdCounter: Int = 0
    var notificationId: Int
   // var notificationSender: User
   // var notificationReceiver: User
    var notificationTitle: String
    var notificationBody: String
    var notificationDate: Date
    var notificationTime: String
    var notificationIsRead: Bool?
    
   /* init(){
        
    }
    
    init(notificationSender: User, notificationReceiver: User, notificationTitle: String, notificationBody: String, notificationDate: Date, notificationTime: String, notificationIsRead: Bool?){
        Notification.notificationIdCounter += 1
        notificationId = Notification.notificationIdCounter
        self.notificationSender = notificationSender
        self.notificationReceiver = notificationReceiver
        self.notificationTitle = notificationTitle
        self.notificationBody = notificationBody
        self.notificationDate = notificationDate
        self.notificationTime = notificationTime
        self.notificationIsRead = notificationIsRead
        
    }*/
    
}
