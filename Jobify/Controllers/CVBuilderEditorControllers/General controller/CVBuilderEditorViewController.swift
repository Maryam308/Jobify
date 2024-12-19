//
//  CVBuilderEditorViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 17/12/2024.
//

import UIKit
import FirebaseFirestore
import Firebase

class CVBuilderEditorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore() //creating a refrenece for the firestore database
    //array of user's CVs
    var cvs: [CV] = []
    @IBOutlet weak var myCVsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch user CVs
        fetchCVs()
        
        myCVsTableView.dataSource = self
        myCVsTableView.delegate = self
        
        // Register CVTableViewCell with myCVsTableView
        myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")
        
    }
    
    
    @IBAction func btnNewCVTapped(_ sender: UIButton) {
        //reset data
        CVData.shared.name = ""
        CVData.shared.email = ""
        CVData.shared.phone = ""
        CVData.shared.country = ""
        CVData.shared.city = ""
        CVData.shared.education = []
        CVData.shared.experience = []
        CVData.shared.skill = []
        CVData.shared.cvTitle = ""
    }
    
    // Fetch user CVs logic
    func fetchCVs() {
        // Create a test CV asynchronously
        Task {
            do {
                let fetchedCVs = try await CVManager.getAllCVs()
                DispatchQueue.main.async {
                    self.cvs = fetchedCVs
                    self.myCVsTableView.reloadData()
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as! CVTableViewCell
        let cv = cvs[indexPath.row]
        cell.setup(cv)
        
        cell.onDelete = { [weak self] in
            self?.deleteCV(at: indexPath)
        }
        return cell
    }
    
    private func deleteCV(at indexPath: IndexPath) {
        // Create an alert controller
        let alert = UIAlertController(title: "Confirm Deletion",
                                      message: "Are you sure you want to delete? You won't get access to this CV after deletion.",
                                      preferredStyle: .alert)

        // Add a "Delete" action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }

            // Check if the index is valid
            guard indexPath.row < self.cvs.count else {
                print("Invalid index. Unable to delete CV.")
                return
            }

            // Remove the CV from the array
            let cvToDelete = self.cvs[indexPath.row]
            self.cvs.remove(at: indexPath.row)

            // Update Firestore
            let cvID = cvToDelete.cvID
            print(cvID)
            self.db.collection("CVs").document(cvID).delete { error in
                if let error = error {
                    print("Error deleting CV: \(error.localizedDescription)")
                } else {
                    // Reload the table view
                    self.myCVsTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }))

        // "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return myCVsTableView.frame.width / 2 
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
}
