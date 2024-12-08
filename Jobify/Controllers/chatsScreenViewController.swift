//
//  chatsScreenViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 08/12/2024.
//


import UIKit

class chatsScreenViewController: UIViewController {
    
    //user messages variable //chack the current user messages
    //var curreenUserMessages: [Message] = []
    
    
    //sample data
    //an array of names
    let userNames: [String] = ["maryam","zainab","zahra", "fatima"]
    
    //an array of messages
    let messagesOne: [String] = ["hello","hi","who","me"]
    
    //second array
    let messagesTwo: [String] = ["hello","hi","who","me"]
    
    //third array
    let messageThree: [String] = ["hello","hi","who","me"]
    
    
    
    
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
    let lightColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    
    //outlets of buttons
    @IBOutlet weak var btnAllMessages: UIButton!
    @IBOutlet weak var btnUnread: UIButton!
    
    //buttons action
    
    @IBAction func btnAllMessages_Click(_ sender: Any) {
        
        //will show all the user messages
        //currentUserMessages
       
        
        //set the colors as needed
        
            //all messages button dark blue
                btnAllMessages.layer.cornerRadius = 15
                btnAllMessages.layer.borderWidth = 0.5
                btnAllMessages.backgroundColor = darkColor
                btnAllMessages.layer.borderColor = lightColor.cgColor
                btnAllMessages.setTitleColor(lightColor, for: .normal)
        
            //unread button to white with dark text
                btnUnread.layer.cornerRadius = 15 //make it circular
                btnUnread.layer.borderWidth = 0.5
                btnUnread.backgroundColor = lightColor
                btnUnread.layer.borderColor = darkColor.cgColor
                btnUnread.setTitleColor(darkColor, for: .normal)

        
    }
    
    
    @IBAction func btnUnread_Click(_ sender: Any) {
    
        //will show unread user messages
        //currentUserMessages
       
        
        //set the colors as needed
        
            //all messages button dark blue
                btnAllMessages.layer.cornerRadius = 15
                btnAllMessages.layer.borderWidth = 0.5
                btnAllMessages.backgroundColor = lightColor
                btnAllMessages.layer.borderColor = darkColor.cgColor
                btnAllMessages.setTitleColor(darkColor, for: .normal)
        
            //unread button to white with dark text
                btnUnread.layer.cornerRadius = 15 //make it circular
                btnUnread.layer.borderWidth = 0.5
                btnUnread.backgroundColor = darkColor
                btnUnread.layer.borderColor = lightColor.cgColor
                btnUnread.setTitleColor(lightColor, for: .normal)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the borders to the filtering buttons
        btnUnread.layer.cornerRadius = 15
        btnUnread.layer.borderWidth = 0.5
        btnUnread.layer.borderColor = darkColor.cgColor
        
        //all messages button dark blue
            btnAllMessages.layer.cornerRadius = 15
            btnAllMessages.layer.borderWidth = 0.5
            btnAllMessages.backgroundColor = darkColor
            btnAllMessages.layer.borderColor = lightColor.cgColor
            btnAllMessages.setTitleColor(lightColor, for: .normal)
    
        //unread button to white with dark text
            btnUnread.layer.cornerRadius = 15 //make it circular
            btnUnread.layer.borderWidth = 0.5
            btnUnread.backgroundColor = lightColor
            btnUnread.layer.borderColor = darkColor.cgColor
            btnUnread.setTitleColor(darkColor, for: .normal)
        
        
        //when the screen load it will display all the messages
        
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
//          let chat = chats[indexPath.row]
//
//          cell.nameLabel.text = chat.0        // User name
//          cell.messageLabel.text = chat.1     // User message
//          cell.profileImageView.image = UIImage(named: chat.2) // User profile image
//
//          return cell
//      }
//
    
    
}


