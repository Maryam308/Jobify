//
//  Messages.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation


struct Messages{
    static var messageIdCounter = 0
    var messageId: Int
    //var messageSender: User
    //var messageReceiver: User
    var messageBody: String
    var messageDate: Date
    var messageTime: String
    var messageIsRead: Bool?
    
   /* init(){
        
    }
    
    init(messageSender: User, messageReceiver: User, messageBody: String, messageDate: Date, messageTime: String, messageIsRead: Bool? = nil) {
        Messages.messageIdCounter += 1
        messageId = Messages.messageIdCounter
        self.messageSender = messageSender
        self.messageReceiver = messageReceiver
        self.messageBody = messageBody
        self.messageDate = messageDate
        self.messageTime = messageTime
        self.messageIsRead = messageIsRead
    }*/
    
    

}