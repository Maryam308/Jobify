//
//  ChatCell.swift
//  tryingProject
//
//  Created by Maryam Ahmed on 08/12/2024.
//

import UIKit

class MessageCell: UITableViewCell{
    
    //outlets
    
    @IBOutlet weak var SentMessageCell: UIView!

    @IBOutlet weak var ReceivedMessageContainer: UIView!
    
    @IBOutlet weak var lblRecievedMessageContent: UILabel!
    
    @IBOutlet weak var lblSentMessageContent: UILabel!
    
    //dummy data
    
//    //an array of names
//    let userNames: [String] = ["maryam","zainab","zahra", "fatima"]
//
//    //an array of messages
//    let messagesOne: [String] = ["hello","hi","who","me"]
//
//    //second array
//    let messagesTwo: [String] = ["hello","hi","who","me"]
//
//    //third array
//    let messageThree: [String] = ["hello","hi","who","me"]
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Set corner radius for the cell's content view
        
        if let firstContainer = self.viewWithTag(1) {
                firstContainer.layer.cornerRadius = 10
                firstContainer.clipsToBounds = true
            }

            if let secondContainer = self.viewWithTag(2) {
                secondContainer.layer.cornerRadius = 20
                secondContainer.clipsToBounds = true
            }
        

        
        
        }
    
    
    
}
