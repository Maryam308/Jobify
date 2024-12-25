//
//  chatsScreenViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 08/12/2024.
//


import UIKit
import Firebase

class chatsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //user messages variable
    //chack the current user messages
    
    @IBOutlet weak var chatsTableView: UITableView!
    var messages: [(otherUserName: String, unreadCount: Int, messageBody: String)] = []

    let db = Firestore.firestore()
    let currentUserId = UserSession.shared.loggedInUser?.userID ?? 2
    var currentUserReference: DocumentReference?

    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
    let lightColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    
    //outlets of buttons
    @IBOutlet weak var btnAllMessages: UIButton!
    @IBOutlet weak var btnUnread: UIButton!
    
    //buttons action
    
    @IBAction func btnAllMessages_Click(_ sender: Any) {
        
        // Filter to show all messages
                setButtonColors(selectedButton: btnAllMessages, deselectedButton: btnUnread)

        
    }
    
    
    @IBAction func btnUnread_Click(_ sender: Any) {
    
        // Filter to show only unread messages
            setButtonColors(selectedButton: btnUnread, deselectedButton: btnAllMessages)

            // Filter messages to show only unread ones
            messages = messages.filter { $0.unreadCount > 0 }
            chatsTableView.reloadData() // Refresh the table view to display the unread messages
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If using a custom UITableViewCell class
        chatsTableView.register(usersChatCell.self, forCellReuseIdentifier: "ChatCell")

        
        // Setup buttons
                setupButtonStyles()
        
        
        //give the table view a data source and data delegate
        chatsTableView.delegate = self
        chatsTableView.dataSource = self

        //when the screen load it will display all the messages
        fetchCurrentUserReference()
        
        
        

        
        
    }
    
    func setupButtonStyles() {
        btnAllMessages.layer.cornerRadius = 15
        btnAllMessages.layer.borderWidth = 0.5
        btnAllMessages.backgroundColor = darkColor
        btnAllMessages.layer.borderColor = lightColor.cgColor
        btnAllMessages.setTitleColor(lightColor, for: .normal)

        btnUnread.layer.cornerRadius = 15
        btnUnread.layer.borderWidth = 0.5
        btnUnread.backgroundColor = lightColor
        btnUnread.layer.borderColor = darkColor.cgColor
        btnUnread.setTitleColor(darkColor, for: .normal)
    }
    
    func setButtonColors(selectedButton: UIButton, deselectedButton: UIButton) {
        selectedButton.backgroundColor = darkColor
        selectedButton.setTitleColor(lightColor, for: .normal)
        selectedButton.layer.borderColor = lightColor.cgColor

        deselectedButton.backgroundColor = lightColor
        deselectedButton.setTitleColor(darkColor, for: .normal)
        deselectedButton.layer.borderColor = darkColor.cgColor
    }
   
    
    func fetchMessages() {
        guard let userReference = currentUserReference else {
            print("Current user reference is nil.")
            return
        }

        let messagesRef = db.collection("Messages")

        // Adjust the query to fetch messages where the current user is either the sender or the recipient
        messagesRef.whereField("recipient", isEqualTo: userReference)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No messages found.")
                    return
                }

                var fetchedMessages: [(String, Int, String)] = []
                let dispatchGroup = DispatchGroup()

                for document in documents {
                    let data = document.data()

                    guard
                        let senderRef = data["sender"] as? DocumentReference,
                        let isRead = data["isRead"] as? Bool,
                        let messageBody = data["messageBody"] as? String else {
                            print("Invalid message data.")
                            continue
                    }

                    let unreadCount = isRead ? 0 : 1
                    dispatchGroup.enter()

                    senderRef.getDocument { userSnapshot, error in
                        if let error = error {
                            print("Error fetching sender data: \(error)")
                            dispatchGroup.leave()
                            return
                        }

                        guard let userData = userSnapshot?.data(),
                              let otherUserName = userData["name"] as? String else {
                            print("No username found for sender.")
                            dispatchGroup.leave()
                            return
                        }

                        fetchedMessages.append((otherUserName, unreadCount, messageBody))
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.messages = fetchedMessages
                    self.chatsTableView.reloadData()
                }
            }

        // Adding a second query to fetch messages where the current user is the sender:
        messagesRef.whereField("sender", isEqualTo: userReference)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No messages found.")
                    return
                }

                var fetchedMessages: [(String, Int, String)] = []
                let dispatchGroup = DispatchGroup()

                for document in documents {
                    let data = document.data()

                    guard
                        let recipientRef = data["recipient"] as? DocumentReference,
                        let isRead = data["isRead"] as? Bool,
                        let messageBody = data["messageBody"] as? String else {
                            print("Invalid message data.")
                            continue
                    }

                    let unreadCount = isRead ? 0 : 1
                    dispatchGroup.enter()

                    recipientRef.getDocument { userSnapshot, error in
                        if let error = error {
                            print("Error fetching recipient data: \(error)")
                            dispatchGroup.leave()
                            return
                        }

                        guard let userData = userSnapshot?.data(),
                              let otherUserName = userData["name"] as? String else {
                            print("No username found for recipient.")
                            dispatchGroup.leave()
                            return
                        }

                        fetchedMessages.append((otherUserName, unreadCount, messageBody))
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.messages = fetchedMessages
                    self.chatsTableView.reloadData()
                }
            }
    }





    
    
    
    
    // MARK: - Table View Data Source

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return messages.count
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! usersChatCell
        
        // Retrieve the message at the given index
        let message = messages[indexPath.row]
        
        // Set the other user's name in the cell's textLabel
        cell.textLabel?.text = message.otherUserName
        
        // Add an accessory view for the unread messages count
        if message.unreadCount > 0 {
            let unreadLabel = UILabel()
            unreadLabel.text = "\(message.unreadCount)"
            unreadLabel.font = UIFont.systemFont(ofSize: 14)
            unreadLabel.textColor = .white
            unreadLabel.backgroundColor = darkColor
            unreadLabel.textAlignment = .center
            unreadLabel.layer.cornerRadius = 12 // Circular shape
            unreadLabel.layer.masksToBounds = true
            unreadLabel.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            cell.accessoryView = unreadLabel
        } else {
            cell.accessoryView = nil // Clear the accessory if no unread messages
        }
        
        return cell
    }
    
    // MARK: fetch the current user

    func fetchCurrentUserReference() {
        db.collection("users")
            .whereField("userId", isEqualTo: currentUserId) // Assuming "userId" is the field in Firestore
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching current user reference: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No user found with ID: \(self?.currentUserId ?? 1)")
                    return
                }
                
                self?.currentUserReference = document.reference
                
                // Fetch messages after finding the current user's reference
                self?.fetchMessages()
            }
        
    }
    
}


