//
//  Messages.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct Message{
    static var messageIdCounter = 0
    var messageId: Int?
    var messageSender: User?
    var messageReceiver: User?
    var messageBody: String?
    var messageDate: Date? //a timestamp of the time the message is constructed
    var otheruserName: String?
    var unreadCount: Int?
    var isRead: Bool = false
        
    
    init(messageSender: User?, messageReceiver: User?, messageBody: String) {
        Message.messageIdCounter += 1
        self.messageId = Message.messageIdCounter
        self.messageSender = messageSender
        self.messageReceiver = messageReceiver
        self.messageBody = messageBody
      
        
        
    }
    
    // a constructer to fetch the messages without all details and display them in users chats
    init(otherUserName: String,unreadCount: Int, messageBody: String){
        self.messageBody = messageBody
        self.otheruserName = otherUserName
        self.unreadCount = unreadCount
        
    }
    
    
}
