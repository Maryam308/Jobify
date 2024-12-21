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
        myCVsTableView.reloadData()
        fetchCVs()
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

              if let currentFavorite = self.currentFavoriteCV, currentFavorite.cvID == cvToDelete.cvID {
                  if self.cvs.count > 2 {
                      self.promptUserToChooseFavorite(cvToDelete: cvToDelete)
                      return
                  } else if self.cvs.count == 2 {
                      if let otherCVIndex = self.cvs.firstIndex(where: { $0.cvID != cvToDelete.cvID }) {
                          self.cvs[otherCVIndex].isFavorite = true
                          self.currentFavoriteCV = self.cvs[otherCVIndex]
                          self.updateCVInFirestore(cv: self.cvs[otherCVIndex])
                      }
                  }
              }

              self.cvs.remove(at: indexPath.row)
              self.db.collection("CVs").document(cvToDelete.cvID).delete { error in
                  if let error = error {
                      print("Error deleting CV: \(error.localizedDescription)")
                  } else {
                      self.myCVsTableView.deleteRows(at: [indexPath], with: .automatic)
                  }
              }
          }))

          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          present(alert, animated: true, completion: nil)
      }

      private func promptUserToChooseFavorite(cvToDelete: CV) {
          let alert = UIAlertController(title: "Choose a New Favorite",
                                        message: "Please select a new favorite CV before deleting the current favorite.",
                                        preferredStyle: .alert)

          for cv in cvs where cv.cvID != cvToDelete.cvID {
              alert.addAction(UIAlertAction(title: cv.cvTitle, style: .default, handler: { [weak self] _ in
                  self?.setFavorite(cv: cv)
                  self?.deleteCVFromFirestore(cvToDelete: cvToDelete)
              }))
          }
          
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
          present(alert, animated: true, completion: nil)
      }
      
      private func setFavorite(cv: CV) {
          if let currentFavorite = currentFavoriteCV {
              if let index = cvs.firstIndex(where: { $0.cvID == currentFavorite.cvID }) {
                  cvs[index].isFavorite = false
                  updateCVInFirestore(cv: cvs[index])
              }
          }

          if let index = cvs.firstIndex(where: { $0.cvID == cv.cvID }) {
              cvs[index].isFavorite = true
              currentFavoriteCV = cvs[index]
              updateCVInFirestore(cv: cvs[index])
          }

          myCVsTableView.reloadData()
      }

      private func deleteCVFromFirestore(cvToDelete: CV) {
          db.collection("CVs").document(cvToDelete.cvID).delete { error in
              if let error = error {
                  print("Error deleting CV: \(error.localizedDescription)")
              } else {
                  print("\(cvToDelete.cvTitle) deleted successfully.")
              }
          }
      }

      private func updateCVInFirestore(cv: CV) {
          let cvID = cv.cvID
          let data: [String: Any] = ["isFavorite": cv.isFavorite ?? false]
          db.collection("CVs").document(cvID).updateData(data) { error in
              if let error = error {
                  print("Error updating CV: \(error.localizedDescription)")
              } else {
                  print("CV updated successfully.")
              }
          }
      }

    private func handleFavoriteAction(_ selectedCV: CV) {
        // First, check if the selected CV is already the current favorite
        if currentFavoriteCV?.cvID == selectedCV.cvID {
            // If it is, do nothing
            return
        }

        // Unmark all CVs as favorite
        for i in 0..<cvs.count {
            cvs[i].isFavorite = false
            updateCVInFirestore(cv: cvs[i]) // Update Firestore for each CV
        }

        // Mark the selected CV as favorite
        if let index = cvs.firstIndex(where: { $0.cvID == selectedCV.cvID }) {
            cvs[index].isFavorite = true
            currentFavoriteCV = cvs[index] // Update the current favorite reference
            updateCVInFirestore(cv: cvs[index]) // Update Firestore
        }

        // Refresh the table view to reflect the changes
        myCVsTableView.reloadData()
    }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return myCVsTableView.frame.width / 2
      }
  }
