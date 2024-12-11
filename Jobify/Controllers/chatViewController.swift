//
//  chatViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 11/12/2024.
//


//
//  chatViewController.swift
//  tryingProject
//
//  Created by Maryam Ahmed on 08/12/2024.
//
import UIKit
class chatViewController: UIViewController,
                          UITableViewDataSource, UITableViewDelegate{
    
    
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //the number of the messages - currentUser.Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ensure all paths return a UITableViewCell
        if indexPath.row == 0 {
            // Dequeue the sent message cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as! MessageCell
            cell.lblSentMessageContent.text = "Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message Sent Message" // Set text for testing
            return cell
        } else if indexPath.row == 1 {
            // Dequeue the received message cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as? MessageCell {
                cell.lblRecievedMessageContent.text = "Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message Received Message" // Set text for testing
                return cell
            } else {
                // Handle the error gracefully
                return UITableViewCell() // Return a default cell or handle the error as needed
            }
        }
        
        // Fallback return (this should not happen if numberOfRowsInSection is correct)
        return UITableViewCell() // This line ensures a cell is always returned
        
    }
    
    override func viewDidLoad() {
        
        chatsTableView.rowHeight = UITableView.automaticDimension
        chatsTableView.estimatedRowHeight = 100
        
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        
        chatsTableView.reloadData()
        
        
    }
    
    
    
    
    
}
