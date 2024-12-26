//
//  Messages.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation
import Firebase

struct Message{
    
    
    static var messageIdCounter: Int = 100
    var messageId: Int?
    var messageSender: User?
    var messageReceiver: User?
    var messageBody: String?
    var messageDate: Date? //a timestamp of the time the message is constructed
    var otheruserName: String?
    var unreadCount: Int?
    var isRead: Bool = false
    var otherUserRefrence: DocumentReference?
    var isSent: Bool = false
    
    init(messageSender: User?, messageReceiver: User?, messageBody: String) {
        Message.messageIdCounter += 1
        self.messageId = Message.messageIdCounter
        self.messageSender = messageSender
        self.messageReceiver = messageReceiver
        self.messageBody = messageBody
      
        
        
    }
    
    // a constructer to fetch the messages without all details and display them in users chats
    init(otherUserName: String,unreadCount: Int, messageBody: String, otherUserRefrence: DocumentReference){
        self.messageBody = messageBody
        self.otheruserName = otherUserName
        self.unreadCount = unreadCount
        self.otherUserRefrence = otherUserRefrence
        
    }
    
    //a constructor to fetch messages for a single screen
    init(isSent: Bool, messageBody: String, timeStamp: Date){

        self.isSent = isSent
        self.messageBody = messageBody
        self.messageDate = timeStamp
        
    }
    
    
}
