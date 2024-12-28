//
//  Notification.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 27/11/2024.
//

import Foundation

struct CustomNotification{
    static var notificationIdCounter: Int = 0
    var notificationId: Int
    //notifications are sent either from admin or the system itself when an update occur
    var notificationSender: String
    var notificationReceiver: String
    var notificationTitle: String
    var notificationBody: String
    var notificationDate: Date
    var notificationTime: String
    var notificationIsRead: Bool?
    
 
    init(notificationSender: String, notificationReceiver: String, notificationTitle: String, notificationBody: String, notificationDate: Date, notificationTime: String, notificationIsRead: Bool?){
        CustomNotification.notificationIdCounter += 1
        notificationId = CustomNotification.notificationIdCounter
        self.notificationSender = notificationSender
        self.notificationReceiver = notificationReceiver
        self.notificationTitle = notificationTitle
        self.notificationBody = notificationBody
        self.notificationDate = notificationDate
        self.notificationTime = notificationTime
        self.notificationIsRead = notificationIsRead
        
    }
    
}
