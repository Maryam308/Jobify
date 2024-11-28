//
//  Messages.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import Foundation

struct Message{
    static var messageIdCounter = 0
    var messageId: Int
    //will be the sender name and then there will be a search throught the users since we dont have polymorphism (to have admin - employer - seeker) the same for reciever
    var messageSender: Any
    var messageReceiver: Any
    var messageBody: String
    var messageDate: String
    var messageTime: String
    //the constructed for first time message will be the sent message
    //the 
    var messageIsRead: Bool? = nil
    // Create a Calendar instance to format the date and time
    var calendar = Calendar.current
    
    
    init(messageSender: Any, messageReceiver: Any, messageBody: String) {
        Message.messageIdCounter += 1
        messageId = Message.messageIdCounter
        self.messageSender = messageSender
        self.messageReceiver = messageReceiver
        self.messageBody = messageBody
        
        // Get the current date and time
        var currentDate = Date()

        
        // Extract the date components for the date
        var dateComponents = calendar.dateComponents([.day, .month], from: currentDate)

        // Extract the time components for the time
        var timeComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        
        // Create date and time variables and convert date and time components to string
        var date = String(format: "%02d-%02d", dateComponents.day!, dateComponents.month!)
        var time = String(format: "%02d:%02d", timeComponents.hour!, timeComponents.minute!)
        
        self.messageDate = date
        self.messageTime = time
        
    }
    
    
}









