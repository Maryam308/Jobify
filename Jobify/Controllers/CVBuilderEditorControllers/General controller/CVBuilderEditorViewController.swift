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
    var cvs: [CV] = []
    var currentFavoriteCV: CV? // the current favorite CV
    
    @IBOutlet weak var myCVsTableView: UITableView!
    @IBOutlet weak var pageHeader: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageHeader.font = pageHeader.font?.withSize(24)
        }
        fetchCVs()
        myCVsTableView.dataSource = self
        myCVsTableView.delegate = self
        myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCVsTableView.reloadData()
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.isEmpty ? setEmptyMessage("You don't have CVs") : restoreTableView()
    }
    
    func setEmptyMessage(_ message: String) -> Int {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        myCVsTableView.backgroundView = messageLabel
        myCVsTableView.separatorStyle = .none
        return 0
    }
    
    func restoreTableView() -> Int {
        myCVsTableView.backgroundView = nil
        myCVsTableView.separatorStyle = .singleLine
        return cvs.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? myCVsTableView.frame.width / 5 : myCVsTableView.frame.width / 3
    }

    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as? CVTableViewCell else {
            return UITableViewCell() // Fallback for safety
        }
        
        let cv = cvs[indexPath.row]
        cell.setup(cv)
        cell.updateFavoriteButton()
        
        cell.onDelete = { [weak self] in
            self?.deleteCV(at: indexPath)
        }
        
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
        guard indexPath.row < cvs.count else { return } // Prevent index out of range
        let cvToDelete = cvs[indexPath.row]
        
        // Check if the CV to delete is the current favorite
        if let currentFavorite = currentFavoriteCV, currentFavorite.cvID == cvToDelete.cvID {
            if cvs.count > 2 {
                // Show alert message and do not proceed with deletion
                showAlert(title: "Cannot Delete Favorite",
                          message: "You must choose a new favorite CV before you can delete the current favorite.")
                return
            } else if cvs.count == 2 {
                // Automatically assign the other CV as favorite
                if let otherCVIndex = cvs.firstIndex(where: { $0.cvID != cvToDelete.cvID }) {
                    cvs[otherCVIndex].isFavorite = true
                    currentFavoriteCV = cvs[otherCVIndex] // Update the current favorite reference
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
        var updatedCVs = cvs
        updatedCVs.remove(at: indexPath.row)

        Task {
            do {
                try await CVManager.deleteCV(cvId: cvIDToDelete)
                DispatchQueue.main.async {
                    self.cvs = updatedCVs
                    self.myCVsTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.showAlert(title: "Success", message: "CV deleted successfully.")
                    self.myCVsTableView.reloadData()
                }
            } catch {
                print("Error deleting CV: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Failed to delete CV: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    
    private func handleFavoriteAction(_ selectedCV: CV) async throws {
        if currentFavoriteCV?.cvID == selectedCV.cvID {
            return // Already favorite, do nothing
        }

        for i in 0..<cvs.count {
            cvs[i].isFavorite = false
            try await CVManager.updateExistingCV(cvID: cvs[i].cvID, updatedCV: cvs[i])
        }

        if let index = cvs.firstIndex(where: { $0.cvID == selectedCV.cvID }) {
            cvs[index].isFavorite = true
            currentFavoriteCV = cvs[index]
            try await CVManager.updateExistingCV(cvID: cvs[index].cvID, updatedCV: cvs[index])
        }

        myCVsTableView.reloadData()
    }
    
    func fetchCVs() {
        Task {
            do {
                let fetchedCVs = try await CVManager.getUserAllCVs()
                DispatchQueue.main.async {
                    self.cvs = fetchedCVs
                    // Loop through the cvs list to find the favorite CV
                    self.currentFavoriteCV = self.cvs.first { $0.isFavorite! }
                                   
                    // Reload the table view to reflect changes
                    self.myCVsTableView.reloadData()
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    }
}
