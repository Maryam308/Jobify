//
//  chatsScreenViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 08/12/2024.
//


import UIKit
import Firebase

class chatsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //will load all users for both employers and admin
    //a pop up button will hold all the coaporated employers in jobify
    
    let db = Firestore.firestore()
    let currentUserId = currentLoggedInUserID
    var currentUserReference: DocumentReference?
    var users: [(name: String, reference: DocumentReference)] = []
    var otherUserNames : [String] = []
    var sendersOfUnread: [DocumentReference] = []
    var isShowingUnread: Bool = false
    
    @IBOutlet weak var btnJobifyEmployers: UIButton!
    @IBOutlet weak var btnAllEmployers: UIButton!
        
    @IBOutlet weak var chatsTableView: UITableView!
    
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(red: 29/255.0, green: 45/255.0, blue: 68/255.0, alpha: 1.0)
    let lightColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    
    //outlets of buttons
    @IBOutlet weak var btnAllMessages: UIButton!
    @IBOutlet weak var btnUnread: UIButton!
    
   
        
    //MARK: Filtering messages
    @IBAction func btnAllMessages_Click(_ sender: Any) {
        //show all the users
        setButtonColors(selectedButton: btnAllMessages, deselectedButton: btnUnread)
        
        isShowingUnread = false
        chatsTableView.reloadData()
        
    }
        
    @IBAction func btnUnread_Click(_ sender: Any) {
    
        // Filter to show only unread messages
            setButtonColors(selectedButton: btnUnread, deselectedButton: btnAllMessages)
        
            isShowingUnread = true
            chatsTableView.reloadData()

    }
    
    //MARK: View will appear
    //faster response than view did load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //by default display all every time message will load
        btnAllMessages_Click(btnAllMessages!)
        
        fetchCurrentUserReference() { [self] _ in
            print(currentUserReference!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(refreshMessages), name: NSNotification.Name("MessagesRead"), object: nil)
            
            self.fetchAndPopulateJobifyMenu()
            self.fetchUsers()  // Ensure users are fetched before reloading the table view
            
            self.fetchUnreadMessages(){// Reload table view once users are populated
                DispatchQueue.main.async {
                    self.chatsTableView.reloadData()
                }}
            
            // Setup buttons
            setupButtonStyles()
            
            // Assign table view data source and delegate
            chatsTableView.delegate = self
            chatsTableView.dataSource = self
            
            
        }
    }

    
    @objc func refreshMessages() {
        
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
   
    //MARK: fetch users
    func fetchUsers() {
        // Clear the users array
        self.users.removeAll()

//        guard let currentUserRole = UserSession.shared.loggedInUser?.role.rawValue else {
//            print("Error: Current user role not found.")
//            return
//        }
        
       // let currentUserRole = "seeker" //testing

        let usersRef = db.collection("users")

        if currentUserRole == "seeker" {
            // Fetch users where the userType is either admin or employer
            let adminRole: DocumentReference = db.collection("usertype").document("user1")
            let employerRole: DocumentReference = db.collection("usertype").document("user2")
            
            usersRef.whereField("userType", in: [employerRole, adminRole]).getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching users for seekers: \(error)")
                    return
                }

                for document in snapshot!.documents {
                    let data = document.data()
                    if let name = data["name"] as? String {
                        let reference = document.reference
                        self.users.append((name: name, reference: reference))
                    }
                }

                DispatchQueue.main.async {
                    self.chatsTableView.reloadData()
                }
            }
        } else {
            // Fetch all other users for non-seekers
            usersRef.getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching users for non-seekers: \(error)")
                    return
                }

                for document in snapshot!.documents {
                    let data = document.data()
                    if let name = data["name"] as? String {
                        let reference = document.reference
                        self.users.append((name: name, reference: reference))
                    }
                }

                DispatchQueue.main.async {
                    self.chatsTableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: fetch unread
    //will fetch an array of users that sent to the current user messages and currently unread

    func fetchUnreadMessages(success: @escaping () -> Void) {
        guard let currentUserReference = currentUserReference else {
            print("Current user reference is not set")
            return
        }

        let db = Firestore.firestore()
        let messagesRef = db.collection("Messages")

        messagesRef
            .whereField("recipient", isEqualTo: currentUserReference) // Filter by recipient
            .whereField("isRead", isEqualTo: false) // Filter by isRead = false
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching unread messages: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No unread messages found")
                    return
                }

                // Iterate through the documents
                for document in documents {
                    if let senderReference = document.data()["sender"] as? DocumentReference {
                        self?.sendersOfUnread.append(senderReference)
                    }
                }

                print("Unread messages fetched. Senders: \(self?.sendersOfUnread ?? [])")
            }
    }


    
    // MARK: - Table View Data Source

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if isShowingUnread {
                   return users.filter { sendersOfUnread.contains($0.reference) }.count
               } else {
                   return users.count
               }
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue reusable cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! usersChatCell
        
        if !users.isEmpty {
            
            var user = users[indexPath.row]
            
            if isShowingUnread {
                user = users
                        .filter{ sendersOfUnread.contains($0.reference) }[indexPath.row]
                        
                } else {
                    user = users[indexPath.row]
                }
            
            // Set the other user's name in the cell's textLabel
            cell.lblOtherUserName.text = user.name
            
            
            // Check if the user's reference is in the sendersOfUnread array
            if sendersOfUnread.contains(user.reference) {
                // Add a badge for unread messages
                let badgeLabel = UILabel()
                badgeLabel.text = "●" // Badge symbol
                badgeLabel.font = UIFont.systemFont(ofSize: 14)
                badgeLabel.textColor = darkColor
                badgeLabel.textAlignment = .center
                badgeLabel.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                
                // Circular shape
                badgeLabel.layer.cornerRadius = 8
                badgeLabel.layer.masksToBounds = true
                
                cell.accessoryView = badgeLabel
            } else {
                // Clear the accessory if there are no unread messages
                cell.accessoryView = nil
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the selected message's details
        
        let otherUserName = users[indexPath.row].name
        let otherUserReference = users[indexPath.row].reference

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


   

    // MARK: fetch the current user

    func fetchCurrentUserReference( completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        db.collection("users")
            .whereField("userId", isEqualTo: currentUserId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching current user reference: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    if let error = error{
                        print("No user found with ID: \(self?.currentUserId ?? 7)")
                        completion(.failure(error))
                    }
                        return
                    
                }
                
                self?.currentUserReference = document.reference
                
                
                
                // Pass the user reference to the completion handler
                completion(.success(document.reference))
            }
    }

        
    
    func fetchAndPopulateJobifyMenu() {
        var menuItems: [UIAction] = []
        let usersRef = db.collection("users")
        let employerTypeRef: DocumentReference = db.collection("usertype").document("user2")
        
        // Add a placeholder item
        let placeholderItem = UIAction(title: "Message Employers in Jobify", handler: { _ in
            print("Placeholder selected")
        })
        menuItems.append(placeholderItem)
        
        // Fetch users with userType = employerTypeRef
        usersRef.whereField("userType", isEqualTo: employerTypeRef).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No users found.")
                return
            }
            
            // Add each user to the menu
            for document in documents {
                if document.reference != self.currentUserReference {
                    let userName = document.data()["name"] as? String ?? "Unknown User"
                    let userItem = UIAction(title: userName, handler: { _ in
                        print("\(userName) selected")
                        self.showChatConfirmationAlert(
                            selectedName: userName,
                            selectedUserReference: document.reference,
                            currentUserReference: self.currentUserReference!
                        )
                    })
                    menuItems.append(userItem)
                }
            }
            
            // Create a UIMenu with the populated items
            let menu = UIMenu(title: "", children: menuItems)
            
            // Assuming you have a UIButton called btnJobifyEmployers
            self.btnJobifyEmployers.menu = menu
            self.btnJobifyEmployers.showsMenuAsPrimaryAction = true
        }
    }

    
    func showChatConfirmationAlert(selectedName: String ,selectedUserReference: DocumentReference, currentUserReference: DocumentReference) {
        let alert = UIAlertController(title: "Start Chat", message: "Do you want to start a chat with this person?", preferredStyle: .alert)

        // "Yes" action to start the chat
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.navigateToChatScreen(selectedName: selectedName, selectedUserReference: selectedUserReference, currentUserReference: currentUserReference)
        }
        
        // "No" action to cancel
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        // Add actions to the alert
        alert.addAction(yesAction)
        alert.addAction(noAction)

        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    func navigateToChatScreen( selectedName: String , selectedUserReference: DocumentReference, currentUserReference: DocumentReference) {
        // Assuming you have a UIStoryboard and view controller for the chat screen
        if let chatVC = storyboard?.instantiateViewController(withIdentifier: "SingleChat") as? chatViewController {
            // Pass both user references to the chat screen
            chatVC.otherUserName = selectedName
            chatVC.currentUserReference = currentUserReference
            chatVC.otherUserReference = selectedUserReference
            
            // Navigate to the chat screen
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    
    
}


