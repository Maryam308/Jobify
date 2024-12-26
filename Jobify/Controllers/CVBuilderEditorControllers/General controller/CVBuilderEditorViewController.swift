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
    
    // Firestore database reference
    let db = Firestore.firestore()
    
    // Array to hold user's CVs
    var cvs: [CV] = []
    var currentFavoriteCV: CV? //the current favorite CV
    
    
    //outlets
    @IBOutlet weak var myCVsTableView: UITableView!
    @IBOutlet weak var pageHeader: UITextView!
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Adjust font size for iPads
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageHeader.font = pageHeader.font!.withSize(24)
        }
        
        // Fetch user CVs from Firestore
        fetchCVs()
        
        // Set the table view data source and delegate
        myCVsTableView.dataSource = self
        myCVsTableView.delegate = self
        
        // Register custom cell
        myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCVsTableView.reloadData()
    }
    
    
    // Reset data when new CV button is tapped
    @IBAction func btnNewCVTapped(_ sender: UIButton) {
        CVData.shared.name = ""
        CVData.shared.email = ""
        CVData.shared.phone = ""
        CVData.shared.country = ""
        CVData.shared.city = ""
        CVData.shared.profileImage = UIImage(systemName: "person.circle") // Reset the image to the default
        CVData.shared.profileImageURL = ""
        CVData.shared.education = []
        CVData.shared.experience = []
        CVData.shared.skill = []
        CVData.shared.cvTitle = ""
        CVData.shared.jobTitle = ""
    }
    
    
    
    // Table view data source method: number of rows in section
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
    
    // Set an empty message when there are no CVs
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
    
    // Restore the table view's original state
       func restoreTableView() {
           myCVsTableView.backgroundView = nil
           myCVsTableView.separatorStyle = .singleLine
       }

    // Table view data source method: height for row
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Check if the current device is an iPad
       if UIDevice.current.userInterfaceIdiom == .pad {
           // Return a smaller height for iPad
           return myCVsTableView.frame.width / 5  // Decrease height for iPad
       } else {
           // Use default height for other devices (iPhone)
           return myCVsTableView.frame.width / 3
       }
   }
    // Table view data source method: width for row
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the full width of the table view
        return tableView.frame.width
    }

    
    // Table view data source method: cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as! CVTableViewCell
        let cv = cvs[indexPath.row]
        
        // Update the favorite button appearance based on isFavorite
        cell.updateFavoriteButton()
        cell.setup(cv)
        
        // Handle delete action
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
    
    
    // Delete CV at specified index path
    private func deleteCV(at indexPath: IndexPath) {
        
        let cvToDelete = cvs[indexPath.row]
        
        // Check if the CV to delete is the current favorite
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
    
    
    // Perform the actual CV deletion
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
                    // Show success alert after deletion
                    self.showAlert(title: "Success", message: "CV deleted successfully.")
                }
            } catch {
                print("Error deleting CV: \(error.localizedDescription)")
                // Handle the error by showing an alert
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Failed to delete CV: \(error.localizedDescription)")
                }
            }
        }
            self.myCVsTableView.reloadData()
    }
    
    
    // Function to display an alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
    //A function to prompt the user to choose a new favorite CV
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
  
    
    // A function to handle favorite action for a selected CV
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
    
    // Fetch user CVs from Firestore
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

  }
