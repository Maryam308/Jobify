//
//  ApplicationDetailTableViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 27/12/2024.
//

import UIKit

class ApplicationDetailTableViewController: UITableViewController {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var showProfileLabel: UILabel!
    
    @IBOutlet weak var currentStatusLabel: UILabel!
    
    var application: JobApplication?
    var currentUserId: Int?
    var currentUserRole: String?
    
    @IBOutlet weak var introductionTextView: UITextView!
    
    @IBOutlet weak var motivationTextView: UITextView!
    
    @IBOutlet weak var contributionTextView: UITextView!
    
    @IBOutlet weak var viewCVButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func ViewCVButtonClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserId = currentLoggedInUserID
        //currentUserRole = UserSession.shared.loggedInUser?.role.rawValue
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*
        // Set the underlined text
                let text = "Underlined Text"
                let attributedString = NSMutableAttributedString(string: text)
                
                // Set the underline style
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
                
                // Set the attributed text to the label
        showProfileLabel.attributedText = attributedString
        currentStatusLabel.attributedText = attributedString
        */
        guard let application = application else {
                print("Error: Application is nil!")
                return
            }
        //if currentUserRole == "seeker" {
            // Populate labels and text fields with the application's data
            companyNameLabel.text = application.jobApplied?.companyDetails?.name
            positionLabel.text = application.jobApplied?.title
            currentStatusLabel.text = application.status.rawValue
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
            showProfileLabel.text = "Show seeker profile"
      /*  } else if currentUserRole == "employer" || currentUserRole == "admin" {
            companyNameLabel.text = application.jobApplicant?.seekerCVs.first?.personalDetails.name
            positionLabel.text = application.jobApplied?.title
            currentStatusLabel.text = application.status.rawValue
            introductionTextView.text = application.briefIntroduction
            motivationTextView.text = application.motivation
            contributionTextView.text = application.contributionToCompany
        }*/
            
        
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
