//
//  chatViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 11/12/2024.
//


import UIKit
import Firebase

class chatViewController: UIViewController,
                          UITableViewDataSource, UITableViewDelegate{
    
    
    var localMessageIDs: Set<Int> = []
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    //these variables will be set from the user chats screeen cause it has fetched both refrences already
    var otherUserName: String?
    var currentUserReference: DocumentReference? // To store the current user's reference
    var otherUserReference: DocumentReference? // To store the other user's reference

    
    
    
    @IBOutlet weak var txtMessagToSent: UITextView!
    
    @IBOutlet weak var lblOtherUserName: UILabel!
    
    
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let isSent = message.isSent // Determine if the message was sent by the current user

        // Format the timestamp to display as time (e.g., "3:45 PM")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
        let formattedTime = dateFormatter.string(from: message.messageDate ?? Date())
            
            if isSent {
                // Use the prototype cell for sent messages
                let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! MessageCell
                cell.lblSentMessageContent.text = message.messageBody
                cell.lblSentTime.text = formattedTime // Assuming you have an outlet for time in the sent cell
                return cell
            } else {
                // Use the prototype cell for received messages
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as! MessageCell
                cell.lblRecievedMessageContent.text = message.messageBody
                cell.lblRecieveTime.text = formattedTime // Assuming you have an outlet for time in the received cell
                return cell
            }
        
        
   }
    
    override func viewDidLoad() {
        
        guard let otherUserReference = otherUserReference else { return }
        
        txtMessagToSent.layer.cornerRadius = 10
        txtMessagToSent.layer.borderWidth = 1
        txtMessagToSent.layer.borderColor = UIColor.lightGray.cgColor
        txtMessagToSent.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        chatsTableView.rowHeight = UITableView.automaticDimension
        chatsTableView.estimatedRowHeight = 100
        
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        
        chatsTableView.reloadData()
        
        
        //for testing purposes to make sure that the user refrences are being past
        otherUserReference.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching other user data: \(error)")
                return
            }
            
            guard let data = snapshot?.data(), let _ = data["name"] as? String else {
                print("Username not found.")
                return
            }
        }
        
        //add the name passed to the other user name lablel
        lblOtherUserName.text = otherUserName
        
        //start fetching the messages
        fetchMessages()
        
    }
    
    //the function will fetch two snapshot one is where the user is recipient and the other is where the user is recipient and the other is sender
    func fetchMessages() {
        guard let userReference = currentUserReference,
              let otherUserReference = otherUserReference else { return }
        
        localMessageIDs.removeAll() // Clear the set before fetching
        
        let messagesRef = db.collection("Messages")
        
        // Query 1: Current user is the sender, and the other user is the recipient
        messagesRef.whereField("sender", isEqualTo: userReference)
            .whereField("recipient", isEqualTo: otherUserReference)
            .addSnapshotListener { [weak self] senderSnapshot, error in
                guard let self = self else { return }
                if let error = error { print("Error fetching messages: \(error)"); return }
                //will pass the snapshot to the other function
                self.handleMessageSnapshot(senderSnapshot, isSent: true)
            }
        
        // Query 2: Current user is the recipient, and the other user is the sender
        messagesRef.whereField("sender", isEqualTo: otherUserReference)
            .whereField("recipient", isEqualTo: userReference)
            .addSnapshotListener { [weak self] recipientSnapshot, error in
                guard let self = self else { return }
                if let error = error { print("Error fetching messages: \(error)"); return }
                //will pass the snapshot to the other function
                self.handleMessageSnapshot(recipientSnapshot, isSent: false)
            }
    }


    private func handleMessageSnapshot(_ snapshot: QuerySnapshot?, isSent: Bool) {
        guard let documents = snapshot?.documents else { return }
        
        for document in documents {
            let data = document.data()
            guard let messageBody = data["messageBody"] as? String,
                  let messageId = data["messageId"] as? Int,  // Fetch the messageId
                  let timestamp = (data["messageDate"] as? Timestamp)?.dateValue() else { continue }
            
            // Check if the message is already in localMessageIDs or messages
            if !localMessageIDs.contains(messageId) &&
               !messages.contains(where: { $0.messageBody == messageBody && $0.messageDate == timestamp }) {
                let theMessage = Message(isSent: isSent, messageBody: messageBody, timeStamp: timestamp)
                messages.append(theMessage)
                localMessageIDs.insert(messageId)  // Add to localMessageIDs to prevent re-adding
            }
        }
        
        // Sort and reload table view
        sortMessagesByTimestamp()
        DispatchQueue.main.async {
            self.chatsTableView.reloadData()
            
            // Ensure there is at least one message to scroll to
            if self.messages.count > 0 {
                let lastRow = self.messages.count - 1
                let lastIndexPath = IndexPath(row: lastRow, section: 0)
                self.chatsTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
        }
    }

    
    @IBAction func btnSendMessageTapped(_ sender: Any) {
        
        // Get the message from the text view
            let messageBody = txtMessagToSent.text ?? ""
            
            // Ensure the message isn't empty
            guard !messageBody.isEmpty else { return }

            // Use the current date and time as timestamp
            let timestamp = Date()

        Message.fetchAndSetID {
            let message = Message(isSent: true, messageBody: messageBody, timeStamp: timestamp)
            
                // Add the message to Firestore (do not add to local array yet)
            self.addMessageToDB(messageBody: messageBody, timestamp: timestamp, messageId: message.messageId!)
                
                // Clear the text view after sending the message
            self.txtMessagToSent.text = ""
        }
        
                
    }
    
    func sortMessagesByTimestamp() {
        // Sorting the messages array based on the messageDate
        messages.sort { (message1, message2) -> Bool in
            guard let timestamp1 = message1.messageDate, let timestamp2 = message2.messageDate else {
                return false // Handle nil messageDate, e.g., keep them as is or define another rule
            }
            return timestamp1 < timestamp2
        }
    }
    
    
    func addMessageToDB(messageBody: String, timestamp: Date, messageId: Int ) {
        guard let currentUserReference = currentUserReference,
              let otherUserReference = otherUserReference else { return }
        
        

        let messageData: [String: Any] = [
            "sender": currentUserReference,
            "recipient": otherUserReference,
            "messageBody": messageBody,
            "messageDate": timestamp,
            "messageId": messageId,
            "isRead": false
        ]
        
        
        
        db.collection("Messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding message: \(error)")
            }
        }
    }

    
    func generateUniqueMessageId() -> Int {
        let newMessageId = Message.messageIdCounter
        Message.messageIdCounter += 1
        return newMessageId
    }
    
    
    
    
    func markMessagesAsRead() {
        guard let userReference = currentUserReference,
              let otherUserReference = otherUserReference else { return }
        
        let messagesRef = db.collection("Messages")
        messagesRef
            .whereField("recipient", isEqualTo: userReference)
            .whereField("sender", isEqualTo: otherUserReference)
            .whereField("isRead", isEqualTo: false)
            .getDocuments {  (querySnapshot, error) in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                
                let dispatchGroup = DispatchGroup()
                
                for document in documents {
                    dispatchGroup.enter()
                    document.reference.updateData(["isRead": true]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    // Post notification after all updates are done
                    NotificationCenter.default.post(name: NSNotification.Name("MessagesRead"), object: nil)
                }
            }
    }

    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        markMessagesAsRead()
    }

    
    
}
