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
    var messages: [(otherUserName: String, unreadCount: Int, messageBody: String, otherUserReference: DocumentReference)] = []

    let db = Firestore.firestore()
    let currentUserId = UserSession.shared.loggedInUser?.userID ?? 3
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMessages), name: NSNotification.Name("MessagesRead"), object: nil)

        
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
    
    @objc func refreshMessages() {
        fetchMessages()
        chatsTableView.reloadData()
    }
    deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("MessagesRead"), object: nil)
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
        var usersDict: [DocumentReference: (otherUserName: String, unreadCount: Int, messageBody: String)] = [:]
        let dispatchGroup = DispatchGroup()

        // Admin User Reference (Set this to the actual admin user reference in Firestore)
        let adminReference = db.collection("users").document("user1") // Replace "AdminUserID" with the actual admin document ID
        let isAdminUser = userReference == adminReference

        // Exclude admin chat for admin users
        if !isAdminUser {
            dispatchGroup.enter()
            adminReference.getDocument { [weak self] adminSnapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching admin user: \(error)")
                    dispatchGroup.leave()
                    return
                }

                guard let adminData = adminSnapshot?.data(),
                      let adminName = adminData["name"] as? String else {
                    print("Admin data is invalid.")
                    dispatchGroup.leave()
                    return
                }

                // Fetch messages with admin
                messagesRef
                    .whereField("recipient", isEqualTo: userReference)
                    .whereField("sender", isEqualTo: adminReference)
                    .addSnapshotListener { snapshot, error in
                        if let error = error {
                            print("Error fetching admin messages: \(error)")
                        } else {
                            let unreadCount = snapshot?.documents.filter { $0.data()["isRead"] as? Bool == false }.count ?? 0
                            let lastMessage = snapshot?.documents.last?.data()["messageBody"] as? String ?? "No messages yet."

                            usersDict[adminReference] = (adminName, unreadCount, lastMessage)
                        }
                        dispatchGroup.leave()
                    }
            }
        }

        // Fetch other user messages
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
                    senderRef.getDocument { senderSnapshot, error in
                        if let error = error {
                            print("Error fetching sender data: \(error)")
                            dispatchGroup.leave()
                            return
                        }

                        guard let senderData = senderSnapshot?.data(),
                              let otherUserName = senderData["name"] as? String else {
                            print("No username found for sender.")
                            dispatchGroup.leave()
                            return
                        }

                        if let existing = usersDict[senderRef] {
                            let updatedUnreadCount = existing.unreadCount + unreadCount
                            usersDict[senderRef] = (otherUserName, updatedUnreadCount, messageBody)
                        } else {
                            usersDict[senderRef] = (otherUserName, unreadCount, messageBody)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.messages = usersDict.map { (key, value) in
                        return (value.otherUserName, value.unreadCount, value.messageBody, key)
                    }

                    // Reload table with updated messages
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the selected message's details
        let selectedMessage = messages[indexPath.row]
        let otherUserName = selectedMessage.otherUserName
        let otherUserReference = selectedMessage.otherUserReference

        // Navigate to the single chat screen
        if let singleChatVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleChat") as? chatViewController {
            // Set the properties before pushing the view controller
            singleChatVC.currentUserReference = currentUserReference
            singleChatVC.otherUserName = otherUserName
            singleChatVC.otherUserReference = otherUserReference // Pass the reference
            
            // Push the view controller to the navigation stack
            self.navigationController?.pushViewController(singleChatVC, animated: true)
        }
    }


    
    
    
    // MARK: fetch the  user

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
                        print("No user found with ID: \(self?.currentUserId ?? 3)")
                        return
                    }
                    
                    self?.currentUserReference = document.reference
                    
                    // Fetch messages after finding the current user's reference
                    self?.fetchMessages()
                }
            
        }
        
    
}


