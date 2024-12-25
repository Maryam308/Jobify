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
    
    let db = Firestore.firestore()
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
    }
    
    //reset data when new cv button is tapped
    @IBAction func btnNewCVTapped(_ sender: UIButton) {
        CVData.shared.name = ""
        CVData.shared.email = ""
        CVData.shared.phone = ""
        CVData.shared.country = ""
        CVData.shared.city = ""
        CVData.shared.profileImage = UIImage(systemName: "person.circle") //reset the image to the default
        CVData.shared.profileImageURL = ""
        CVData.shared.education = []
        CVData.shared.experience = []
        CVData.shared.skill = []
        CVData.shared.cvTitle = ""
        CVData.shared.jobTitle = ""
    }
    
    
    // Fetch user CVs logic
    func fetchCVs() {
        Task {
            do {
                let fetchedCVs = try await CVManager.getUserAllCVs()
                DispatchQueue.main.async {
                    self.cvs = fetchedCVs
                    self.myCVsTableView.reloadData()
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    }
    
    
    //my CVs table view configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cvs.isEmpty {
                 setEmptyMessage("You don't have CVs")
                 return 0
             } else {
                 restoreTableView()
                 return cvs.count
             }
    }
    
    // MARK: - Helper Methods
       func setEmptyMessage(_ message: String) {
           let messageLabel = UILabel()
           messageLabel.text = message
           messageLabel.textColor = .gray
           messageLabel.textAlignment = .center
           messageLabel.font = UIFont.systemFont(ofSize: 17)
           messageLabel.numberOfLines = 0
           messageLabel.sizeToFit()
           myCVsTableView.backgroundView = messageLabel
           myCVsTableView.separatorStyle = .none
       }

       func restoreTableView() {
           myCVsTableView.backgroundView = nil
           myCVsTableView.separatorStyle = .singleLine
       }
    
    
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return myCVsTableView.frame.width 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as! CVTableViewCell
        let cv = cvs[indexPath.row]
        
        // Update the favorite button appearance based on isFavorite
        cell.updateFavoriteButton()
        cell.setup(cv)
        
        // Handle delete
        cell.onDelete = { [weak self] in
            self?.deleteCV(at: indexPath)
        }
        
        // Handle favorite action
        cell.favoriteAction = { [weak self] selectedCV in
            guard let self = self else { return }
            Task {
                do {
                    try await self.handleFavoriteAction(selectedCV)
                } catch {
                    print("Error handling favorite action: \(error)")
                }
            }
        }
        
        return cell
    }
    
    private func deleteCV(at indexPath: IndexPath) {
        let cvToDelete = cvs[indexPath.row]

        if let currentFavorite = currentFavoriteCV, currentFavorite.cvID == cvToDelete.cvID {
            if cvs.count > 2 {
                // Prompt user to choose a new favorite
                promptUserToChooseFavorite(cvToDelete: cvToDelete, indexPath: indexPath)
                return
            } else if cvs.count == 2 {
                // Automatically assign the other CV as favorite
                if let otherCVIndex = cvs.firstIndex(where: { $0.cvID != cvToDelete.cvID }) {
                    cvs[otherCVIndex].isFavorite = true
                    currentFavoriteCV = cvs[otherCVIndex]
                    Task {
                        do {
                            try await CVManager.updateExistingCV(cvID: cvs[otherCVIndex].cvID, updatedCV: cvs[otherCVIndex])
                        } catch {
                            print("Error updating favorite CV: \(error)")
                        }
                    }
                }
            }
        }

        // Proceed with deletion
        performCVDeletion(cvToDelete: cvToDelete, indexPath: indexPath)
    }
    
    private func performCVDeletion(cvToDelete: CV, indexPath: IndexPath) {
        let cvIDToDelete = cvToDelete.cvID

        // Prepare the updated CVs array
        var updatedCVs = cvs
        updatedCVs.remove(at: indexPath.row)

        // Call the delete function asynchronously
        Task {
            do {
                try await CVManager.deleteCV(cvId: cvIDToDelete)
                DispatchQueue.main.async {
                    self.cvs = updatedCVs
                    self.myCVsTableView.deleteRows(at: [indexPath], with: .automatic)

                }
            } catch {
                print("Error deleting CV: \(error.localizedDescription)")
                // Handle the error (e.g., show an alert)
            }
        }
            self.myCVsTableView.reloadData()
    }
    
    private func promptUserToChooseFavorite(cvToDelete: CV, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Choose a New Favorite",
                                      message: "Please select a new favorite CV before deleting the current favorite.",
                                      preferredStyle: .alert)

        for cv in cvs where cv.cvID != cvToDelete.cvID {
            alert.addAction(UIAlertAction(title: cv.cvTitle, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }

                Task {
                    do {
                        // Mark the selected CV as favorite
                        if let index = self.cvs.firstIndex(where: { $0.cvID == cv.cvID }) {
                            self.cvs[index].isFavorite = true
                            self.currentFavoriteCV = self.cvs[index]
                            try await CVManager.updateExistingCV(cvID: cv.cvID, updatedCV: self.cvs[index])
                        }

                        // Proceed with deleting the original CV
                        self.performCVDeletion(cvToDelete: cvToDelete, indexPath: indexPath)
                    } catch {
                        print("Error handling favorite selection: \(error)")
                    }
                }
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
  
    private func handleFavoriteAction(_ selectedCV: CV) async throws {
        //  check if the selected CV is already the current favorite
        if currentFavoriteCV?.cvID == selectedCV.cvID {
            // If it is, do nothing
            return
        }

        // Unmark all CVs as favorite
        for i in 0..<cvs.count {
            cvs[i].isFavorite = false
            // Call the async function to update existing CVs
            try await CVManager.updateExistingCV(cvID: cvs[i].cvID, updatedCV: cvs[i])
        }

        // Mark the selected CV as favorite
        if let index = cvs.firstIndex(where: { $0.cvID == selectedCV.cvID }) {
            cvs[index].isFavorite = true
            currentFavoriteCV = cvs[index] // Update the current favorite reference
            // Update the selected CV in Firestore
            try await CVManager.updateExistingCV(cvID: cvs[index].cvID, updatedCV: cvs[index])
        }

        // Refresh the table view to reflect the changes
        myCVsTableView.reloadData()
    }
    
    
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return myCVsTableView.frame.width / 3
      }
  }
