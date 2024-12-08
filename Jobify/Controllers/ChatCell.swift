//
//  ChatCell.swift
//  Jobify
//
//  Created by Maryam Ahmed on 08/12/2024.
//

import UIKit

class ChatCell: UITableViewCell{
    
    //outlets
    
    @IBOutlet weak var lblChatUserName: UILabel!
    @IBOutlet weak var imgProfileImage: UIImage!
    
    //an array of names
    let userNames: [String] = ["maryam","zainab","zahra", "fatima"]
    
    //an array of messages
    let messagesOne: [String] = ["hello","hi","who","me"]
    
    //second array
    let messagesTwo: [String] = ["hello","hi","who","me"]
    
    //third array
    let messageThree: [String] = ["hello","hi","who","me"]
    
    
    
}
