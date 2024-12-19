//
//  ApplicationTrackerViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore


let db = Firestore.firestore()



class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorCell
        //let application = applications[indexPath.row]
        //cell.seekerLabel.text = application.seeker
        //cell.positionLabel.text = application.position
        //cell.currentStatusLabel.text = application.status
        //return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        let application = applications[indexPath.row]
        cell.companyLabel.text = application.company
        cell.typeLabel.text = application.type
        cell.positionLabel.text = application.position
        cell.locationLabel.text = application.location
        cell.statusButton.setTitle(application.status, for: .normal)
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let alert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let options = UIAlertController(title: "Change Status", message: nil, preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: "Accepted", style: .default) { _ in
            self.db.collection("jobApplication").document("\(self.applications[indexPath.row].id)").updateData(["status": "Accepted"])
            // Update local data source
            self.applications[indexPath.row].status = "Accepted"
                                
            // Reload the table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let option2 = UIAlertAction(title: "Rejected", style: .default) { _ in
            self.db.collection("jobApplication").document("\(self.applications[indexPath.row].id)").updateData(["status": "Rejected"])
            // Update local data source
            self.applications[indexPath.row].status = "Rejected"
                                
            // Reload the table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let option3 = UIAlertAction(title: "Reviewed", style: .default) { _ in
            self.db.collection("jobApplication").document("\(self.applications[indexPath.row].id)").updateData(["status": "Reviewed"])
            // Update local data source
            self.applications[indexPath.row].status = "Reviewed"
                                
            // Reload the table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        options.addAction(alert)
        options.addAction(option1)
        options.addAction(option2)
        options.addAction(option3)
        
        // Configure popoverPresentationController for iPad
            if let popoverController = options.popoverPresentationController {
                popoverController.sourceView = tableView // Set the source view
                popoverController.sourceRect = tableView.rectForRow(at: indexPath) // Set the source rect (cell's frame)
                popoverController.permittedArrowDirections = .any // Optional: set arrow direction
            }
        
        present(options, animated: true, completion: nil)
        
        self.tableView.reloadData()
    }
    
    
    let db = Firestore.firestore()
    
    struct Application {
        let company: String
        let type: String
        let position: String
        let location: String
        var status: String
        let id: String
        //let seeker: String
    }
    var applications: [Application] = []
    
    var filteredApplications: [Application] = []
    
    func filterApplications(by status: String?) {
        // If a status is provided, filter applications based on the status
        if let status = status {
                    filteredApplications = applications.filter { $0.status == status }
                } else {
                    filteredApplications = applications
                }
                tableView.reloadData()
    }
    
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(hex: "#1D2D44")
    let lightColor = UIColor(hex: "#EEEEEE")
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var notReviewedButton: UIButton!
    @IBOutlet weak var reviewedButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    @IBOutlet weak var rejectedButton: UIButton!
    
    func styleButton(_ button: UIButton, backgroundColor: UIColor, borderColor: UIColor, titleColor: UIColor) {
        button.layer.cornerRadius = 25
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(titleColor, for: .normal)
    }
    
     @IBAction func allButtonTapped(_ sender: Any) {
         //set the colors as needed
         print("all button clicked")
         /*
         //all button dark blue
                 allButton.layer.cornerRadius = 25
                 allButton.backgroundColor = darkColor
                 allButton.layer.borderColor = darkColor.cgColor
         allButton.layer.borderWidth = 0.5

                 allButton.setTitleColor(lightColor, for: .normal)
         
             //not reviewed button to white with dark text
                 notReviewedButton.layer.cornerRadius = 25
                 notReviewedButton.backgroundColor = lightColor
                 notReviewedButton.layer.borderColor = lightColor.cgColor
         notReviewedButton.layer.borderWidth = 0.5

                 notReviewedButton.setTitleColor(darkColor, for: .normal)
         
         //reviewed button to white with dark text
             reviewedButton.layer.cornerRadius = 25
             reviewedButton.backgroundColor = lightColor
             reviewedButton.layer.borderColor = lightColor.cgColor
         reviewedButton.layer.borderWidth = 0.5

             reviewedButton.setTitleColor(darkColor, for: .normal)
         
         //approved button to white with dark text
             approvedButton.layer.cornerRadius = 25
             approvedButton.backgroundColor = lightColor
             approvedButton.layer.borderColor = lightColor.cgColor
         approvedButton.layer.borderWidth = 0.5

             approvedButton.setTitleColor(darkColor, for: .normal)
         
         //rejected button to white with dark text
             rejectedButton.layer.cornerRadius = 25
             rejectedButton.backgroundColor = lightColor
             rejectedButton.layer.borderColor = lightColor.cgColor
         rejectedButton.layer.borderWidth = 0.5

             rejectedButton.setTitleColor(darkColor, for: .normal)
          */
         
         // Style each button
             styleButton(allButton, backgroundColor: darkColor, borderColor: lightColor, titleColor: lightColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
         
         //filterApplications(by: nil) // Show all
         
     }

     @IBAction func notReviewedButtonTapped(_ sender: UIButton) {
         print("not reviewed button clicked")
             //all button dark blue
         /*
         notReviewedButton.layer.cornerRadius = 25
         notReviewedButton.backgroundColor = darkColor
         notReviewedButton.layer.borderColor = darkColor.cgColor
         notReviewedButton.layer.borderWidth = 0.5
         notReviewedButton.setTitleColor(lightColor, for: .normal)
         
             //not reviewed button to white with dark text
                 allButton.layer.cornerRadius = 25
                 allButton.backgroundColor = lightColor
                 allButton.layer.borderColor = lightColor.cgColor
                 allButton.layer.borderWidth = 0.5
                 allButton.setTitleColor(darkColor, for: .normal)
         
         //reviewed button to white with dark text
             reviewedButton.layer.cornerRadius = 25
             reviewedButton.backgroundColor = lightColor
             reviewedButton.layer.borderColor = lightColor.cgColor
             reviewedButton.layer.borderWidth = 0.5
             reviewedButton.setTitleColor(darkColor, for: .normal)
         
         //approved button to white with dark text
             approvedButton.layer.cornerRadius = 25
             approvedButton.backgroundColor = lightColor
             approvedButton.layer.borderColor = lightColor.cgColor
             approvedButton.layer.borderWidth = 0.5
             approvedButton.setTitleColor(darkColor, for: .normal)
         
         //rejected button to white with dark text
             rejectedButton.layer.cornerRadius = 25
             rejectedButton.backgroundColor = lightColor
             rejectedButton.layer.borderColor = lightColor.cgColor
             rejectedButton.layer.borderWidth = 0.5
             rejectedButton.setTitleColor(darkColor, for: .normal)
         */
         
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: darkColor, borderColor: darkColor, titleColor: lightColor)
             styleButton(reviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
         //filterApplications(by: "not reviewed")
     }
   
    @IBAction func reviewedButtonTapped(_ sender: UIButton) {
        //filterApplications(by: "reviewed")
        print("reviewed button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
            styleButton(reviewedButton, backgroundColor: darkColor, borderColor: darkColor, titleColor: lightColor)
            styleButton(approvedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
            styleButton(rejectedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
    }

     @IBAction func approvedButtonTapped(_ sender: UIButton) {
         //filterApplications(by: "approved")
         print("approved button clicked")
         
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: darkColor, borderColor: darkColor, titleColor: lightColor)
             styleButton(rejectedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
     }
   
    
     @IBAction func rejectedButtonTapped(_ sender: UIButton) {
         //filterApplications(by: "rejected")
         print("rejected button clicked")
         
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, borderColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: darkColor, borderColor: darkColor, titleColor: lightColor)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        let nib = UINib(nibName: "TrackerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //add the borders to the filtering buttons
        notReviewedButton.layer.cornerRadius = 25
        notReviewedButton.layer.borderWidth = 0.5
        notReviewedButton.layer.borderColor = lightColor.cgColor
        
        //all messages button dark blue
        allButton.layer.cornerRadius = 25
        allButton.layer.borderWidth = 0.5
        allButton.backgroundColor = darkColor
        allButton.layer.borderColor = lightColor.cgColor
        allButton.setTitleColor(lightColor, for: .normal)
    
        //unread button to white with dark text
        notReviewedButton.layer.cornerRadius = 25 //make it circular
        notReviewedButton.layer.borderWidth = 0.5
        notReviewedButton.backgroundColor = lightColor
        notReviewedButton.layer.borderColor = lightColor.cgColor
        notReviewedButton.setTitleColor(darkColor, for: .normal)
    }
    
    
    
    
    @IBOutlet var tableView: UITableView!
   
    func fetchData() {
        db.collection("jobApplication")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                // Loop through the documents and add buttons
                for document in documents {
                    let data = document.data()
                    let docID = document.documentID
                    if let company = data["company"] as? String {
                        let type = data["type"] as? String ?? "Unknown"
                        let position = data["position"] as? String ?? "Unknown"
                        let location = data["location"] as? String ?? "Unknown"
                        let status = data["status"] as? String ?? "Not Reviewed"
                        //let id = data["id"] as? Int ?? 0
                        //let seeker = data["status"] as? String ?? "Unknown"
                        
                        let application = Application(
                            company: company,
                            type: type,
                            position: position,
                            location: location,
                            status: status,
                            id: docID
                            //seeker: seeker
                        )
                        applications.append(application)
                    }
                }
                tableView.reloadData()
            }
        
        
        


        
        
        
      
    }
    
}
