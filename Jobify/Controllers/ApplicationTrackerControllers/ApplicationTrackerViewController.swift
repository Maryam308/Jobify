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
        return filteredApplications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MonitorCell", for: indexPath) as! MonitorCell
        //let application = applications[indexPath.row]
        //cell.seekerLabel.text = application.seeker
        //cell.positionLabel.text = application.position
        //cell.currentStatusLabel.text = application.status
        //return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        let application = filteredApplications[indexPath.row]
        cell.companyLabel.text = application.company
        cell.typeLabel.text = application.type
        cell.positionLabel.text = application.position
        cell.locationLabel.text = application.location
        cell.statusButton.setTitle(application.status.rawValue, for: .normal)
        // Set the button background color based on status
            switch application.status {
            case .notReviewed:
                cell.statusButton.backgroundColor = UIColor.orange
            case .reviewed:
                cell.statusButton.backgroundColor = UIColor.blue
            case .approved:
                cell.statusButton.backgroundColor = UIColor.green
            case .rejected:
                cell.statusButton.backgroundColor = UIColor.red
            }
        
        
            cell.statusButton.setTitleColor(.white, for: .normal) // Set text color to white
            cell.statusButton.layer.cornerRadius = 20            // Make the button rounded
            cell.statusButton.clipsToBounds = true
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let application = self.filteredApplications[indexPath.row]
            let currentStatus = application.status // Get current status
            
            let alert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let options = UIAlertController(title: "Change Status", message: nil, preferredStyle: .actionSheet)
            
            // Helper function to add an action
            func addAction(title: String, newStatus: Application.ApplicationStatus) {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    self.db.collection("jobApplication")
                        .document("\(application.id)")
                        .updateData(["status": newStatus.rawValue]) // Update Firebase
                    // Update local data source
                    self.applications[indexPath.row].status = newStatus
                    // Reload the table view
                    DispatchQueue.main.async {
                        self.filterApplications(by: self.currentFilter)
                        //self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                options.addAction(action)
            }
            
            // Add options based on the current status
            switch currentStatus {
            case .notReviewed:
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Rejected", newStatus: .rejected)
                addAction(title: "Approved", newStatus: .approved)
            case .reviewed:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Rejected", newStatus: .rejected)
                addAction(title: "Approved", newStatus: .approved)
            case .approved:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Rejected", newStatus: .rejected)
            case .rejected:
                addAction(title: "Not Reviewed", newStatus: .notReviewed)
                addAction(title: "Reviewed", newStatus: .reviewed)
                addAction(title: "Approved", newStatus: .approved)
            }
            
            options.addAction(alert)
            
            // Configure popoverPresentationController for iPad
            if let popoverController = options.popoverPresentationController {
                popoverController.sourceView = tableView // Set the source view
                popoverController.sourceRect = tableView.rectForRow(at: indexPath) // Set the source rect (cell's frame)
                popoverController.permittedArrowDirections = .any // Optional: set arrow direction
            }
            
            present(options, animated: true, completion: nil)
        
        //self.tableView.reloadData()
        DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    
    
    let db = Firestore.firestore()
    
    struct Application {
            let company: String
            let type: String
            let position: String
            let location: String
            //var status: String
            let id: String
            //let seeker: String
        var status: ApplicationStatus
        
        enum ApplicationStatus: String, Codable{
            case notReviewed = "Not Reviewed"
            case reviewed = "Reviewed"
            case approved = "Approved"
            case rejected = "Rejected"
        }
        }
    
    var currentFilter: String? = nil
    
    var applications: [Application] = []
    
    var filteredApplications: [Application] = []
    
   func filterApplications(by status: String?) {
       currentFilter = status
       // If a status is provided, filter applications based on the status
        if let status = status {
            filteredApplications = applications.filter { $0.status.rawValue == status }
                } else {
                    filteredApplications = applications
                }
       DispatchQueue.main.async {
           if self.filteredApplications.isEmpty {
                       self.tableView.isHidden = true
                       self.placeholderView.isHidden = false
                   } else {
                       self.tableView.isHidden = false
                       self.placeholderView.isHidden = true
                   }
                   self.tableView.reloadData()
           
           }
       print("Filtered Applications: \(filteredApplications)")
    }
    
    
    //declaring colors object of type ui color - would add .cgColor when needed
    let darkColor = UIColor(hex: "#1D2D44")
    let lightColor = UIColor(hex: "#EEEEEE")
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var notReviewedButton: UIButton!
    @IBOutlet weak var reviewedButton: UIButton!
    @IBOutlet weak var approvedButton: UIButton!
    @IBOutlet weak var rejectedButton: UIButton!
    
    func styleButton(_ button: UIButton, backgroundColor: UIColor, titleColor: UIColor) {
        var buttonConfig = UIButton.Configuration.filled()
            
            buttonConfig.baseBackgroundColor = backgroundColor
            buttonConfig.baseForegroundColor = titleColor
            buttonConfig.cornerStyle = .capsule
    }
    
     @IBAction func allButtonTapped(_ sender: Any) {
         //set the colors as needed
         print("all button clicked")
         
         // Style each button
             styleButton(allButton, backgroundColor: darkColor, titleColor: lightColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
         
         filterApplications(by: nil) // Show all
         
     }

     @IBAction func notReviewedButtonTapped(_ sender: UIButton) {
         print("not reviewed button clicked")
          
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: darkColor, titleColor: lightColor)
             styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
         filterApplications(by: "Not Reviewed")
     }
   
    @IBAction func reviewedButtonTapped(_ sender: UIButton) {
        filterApplications(by: "Reviewed")
        print("reviewed button clicked")
        
        // Style each button
        styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
        styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
            styleButton(reviewedButton, backgroundColor: darkColor, titleColor: lightColor)
            styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
            styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
    }

     @IBAction func approvedButtonTapped(_ sender: UIButton) {
         filterApplications(by: "Approved")
         print("approved button clicked")
         
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: darkColor, titleColor: lightColor)
             styleButton(rejectedButton, backgroundColor: lightColor, titleColor: darkColor)
     }
   
    
     @IBAction func rejectedButtonTapped(_ sender: UIButton) {
         filterApplications(by: "Rejected")
         print("rejected button clicked")
         
         // Style each button
         styleButton(allButton, backgroundColor: lightColor, titleColor: darkColor)
         styleButton(notReviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(reviewedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(approvedButton, backgroundColor: lightColor, titleColor: darkColor)
             styleButton(rejectedButton, backgroundColor: darkColor, titleColor: lightColor)
     }
    
    let placeholderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "No applications found."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(placeholderView)
            NSLayoutConstraint.activate([
                placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                        placeholderView.widthAnchor.constraint(equalToConstant: 200), // Adjust width as needed
                        placeholderView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
            placeholderView.isHidden = true
        
        fetchData()
        
        let nib = UINib(nibName: "TrackerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        filterApplications(by: nil) // Show all
        
    }
    
    
    
    
    @IBOutlet var tableView: UITableView!
   
    func fetchData() {
        db.collection("jobApplication").addSnapshotListener //to listen to any updates happening in firebase
            { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                self.applications.removeAll()
                
                // Loop through the documents and add buttons
                for document in documents {
                    let data = document.data()
                    let docID = document.documentID
                    if let company = data["company"] as? String {
                        let type = data["type"] as? String ?? "Unknown"
                        let position = data["position"] as? String ?? "Unknown"
                        let location = data["location"] as? String ?? "Unknown"
                        let applicationStatusRaw = data["status"] as? String ?? "Unknown"
                        let applicationStatus = Application.ApplicationStatus(rawValue: applicationStatusRaw)
                                        
                                        // Safely unwrap applicationStatus
                                        guard let status = applicationStatus else {
                                            print("Invalid application status: \(applicationStatusRaw) for document ID: \(document.documentID)")
                                            continue // Skip this document if application status is invalid
                                        }
                        //let status = data["status"] as? String ?? "Not Reviewed"
                        //let id = data["id"] as? Int ?? 0
                        //let seeker = data["status"] as? String ?? "Unknown"
                        
                        let application = Application(
                            company: company,
                            type: type,
                            position: position,
                            location: location,
                            //status: status,
                            id: docID,
                            //seeker: seeker
                            status: status
                        )
                        applications.append(application)
                    }
                }
                
                DispatchQueue.main.async {
                    self.filterApplications(by: nil)
                    self.tableView.reloadData()
                }
            }
        
   
      
    }
    
}
