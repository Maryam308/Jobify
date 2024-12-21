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
    var currentFavoriteCV: CV?
    @IBOutlet weak var myCVsTableView: UITableView!
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        // Fetch user CVs
        fetchCVs()
        
        myCVsTableView.dataSource = self
        myCVsTableView.delegate = self
        
        // Register CVTableViewCell with myCVsTableView
        myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCVs() // Fetch CVs every time the view appears
    }
    
    @IBAction func btnNewCVTapped(_ sender: UIButton) {
        //reset data
        CVData.shared.name = ""
        CVData.shared.email = ""
        CVData.shared.phone = ""
        CVData.shared.country = ""
        CVData.shared.city = ""
        CVData.shared.profileImage = nil
        CVData.shared.education = []
        CVData.shared.experience = []
        CVData.shared.skill = []
        CVData.shared.cvTitle = ""
        CVData.shared.jobTitle = ""
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
        // Update the favorite button appearance based on isFavorite
        cell.updateFavoriteButton()
        cell.setup(cv)
        
        //handle delete
        cell.onDelete = { [weak self] in
            self?.deleteCV(at: indexPath)
        }
        
        // Handle favorite action
        cell.favoriteAction = { [weak self] selectedCV in
            self?.handleFavoriteAction(selectedCV)
        }
        return cell
    }
    
    private func deleteCV(at indexPath: IndexPath) {
         let alert = UIAlertController(title: "Confirm Deletion",
                                       message: "Are you sure you want to delete? You won't get access to this CV after deletion.",
                                       preferredStyle: .alert)

         alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
             guard let self = self else { return }
             guard indexPath.row < self.cvs.count else { return }

             let cvToDelete = self.cvs[indexPath.row]

             // Check if the CV being deleted is the current favorite
             if let currentFavorite = self.currentFavoriteCV, currentFavorite.cvID == cvToDelete.cvID {
                 if self.cvs.count > 2 {
                     // Alert user to choose another favorite
                     let alert = UIAlertController(title: "Cannot Delete Favorite",
                                                   message: "Please choose another favorite before deleting this one.",
                                                   preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                     return
                 } else {
                     // If there are only two CVs, assign the other as favorite
                     if let otherCVIndex = self.cvs.firstIndex(where: { $0.cvID != cvToDelete.cvID }) {
                         self.cvs[otherCVIndex].isFavorite = true
                         self.currentFavoriteCV = self.cvs[otherCVIndex]
                         self.updateCVInFirestore(cv: self.cvs[otherCVIndex]) // Update Firestore for new favorite
                     }
                 }
             }

             // Remove the CV from the array
             self.cvs.remove(at: indexPath.row)

             // Delete from Firestore
             self.db.collection("CVs").document(cvToDelete.cvID).delete { error in
                 if let error = error {
                     print("Error deleting CV: \(error.localizedDescription)")
                 } else {
                     // Successfully deleted, reload the table view
                     self.myCVsTableView.deleteRows(at: [indexPath], with: .automatic)
                     self.myCVsTableView.reloadData() // Reload to reflect changes
                 }
             }
         }))

         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         present(alert, animated: true, completion: nil)
     }

    // Function to update the CV in Firestore with the new favorite status
       private func updateCVInFirestore(cv: CV) {
           let cvID = cv.cvID
           let data: [String: Any] = ["isFavorite": cv.isFavorite!]
           db.collection("CVs").document(cvID).updateData(data) { error in
               if let error = error {
                   print("Error updating CV: \(error.localizedDescription)")
               } else {
                   print("CV updated successfully.")
               }
           }
       }

    
    private func handleFavoriteAction(_ selectedCV: CV) {
           if cvs.count == 1 {
               // Always keep the only CV as favorite
               if let index = cvs.firstIndex(where: { $0.cvID == selectedCV.cvID }) {
                   cvs[index].isFavorite = true
                   currentFavoriteCV = cvs[index]
                   updateCVInFirestore(cv: cvs[index]) // Update Firestore
               }
           } else {
               // Manage favorites when there are multiple CVs
               if let currentFavorite = currentFavoriteCV, currentFavorite.cvID != selectedCV.cvID {
                   if let index = cvs.firstIndex(where: { $0.cvID == currentFavorite.cvID }) {
                       cvs[index].isFavorite = false
                       updateCVInFirestore(cv: cvs[index]) // Update Firestore
                   }
               }

               if let index = cvs.firstIndex(where: { $0.cvID == selectedCV.cvID }) {
                   cvs[index].isFavorite = true // Set the new favorite
                   currentFavoriteCV = cvs[index] // Update the current favorite
                   updateCVInFirestore(cv: cvs[index]) // Update Firestore
               }
           }

           myCVsTableView.reloadData() // Reload table view to reflect changes
       }

    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return myCVsTableView.frame.width / 2 
        }
        
    
}
