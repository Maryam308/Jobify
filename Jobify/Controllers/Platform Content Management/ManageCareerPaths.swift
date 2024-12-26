//
//  Untitled.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//
import UIKit
import Firebase

class ManageCareerPathsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CareerPathCellDelegate {
    
    let db = Firestore.firestore()
    var careerPaths: [CareerPath] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        careerPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fetch the cell to reuse using the specified one from the in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manageCareerPathCell", for: indexPath) as! ManageCareerPathCollectionViewCell
        
        cell.configure(with: careerPaths[indexPath.item]) // Pass the data to the cell

        cell.delegate = self
        
        //set the title label to the learning resource title
        cell.lblCareerTitle.text = careerPaths[indexPath.item].title
                           
        //return the ready cell
        return cell
    }
    
    @IBOutlet weak var careerPathMngCollection: UICollectionView!
    
    //view will appeear instead of didLoad to show the result of adding a new career path
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        careerPathMngCollection.delegate = self
        careerPathMngCollection.dataSource = self
        fetchCareerPaths()
    }
    
    //fetch the titles of the careerPaths
    func fetchCareerPaths() {
        db.collection("careerPaths")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching career paths: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No career paths found.")
                    return
                }
                
                self.careerPaths = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let id = data["careerPathId"] as? Int ?? 0
                    let title = data["title"] as? String ?? "Untitled"
                    
                    let careerPath = CareerPath( careerId: id , title: title)
                    
                    return careerPath
                }
                
                // Reload the collection view with the fetched data
                DispatchQueue.main.async {
                    self.careerPathMngCollection.reloadData()
                }
            }
    }
    
    
    
    // career paths editing and removing cell delegates methods
        func didTapEditButton(id: Int) {
            print("Edit button tapped for: \(id)")
            // For editing will use the same add screen while changing the data and displaying all field values
            //so it will send the value of the title to it then there the careerpath will be fitched
            let editVC = storyboard?.instantiateViewController(withIdentifier: "AddCareerPath") as! AddNewCareerPathViewController
            editVC.editCareerPathId = id
            navigationController?.pushViewController(editVC, animated: true)
        }

    
    
    
    
    func didTapRemoveButton(id: Int) {
       
        print("Remove button tapped for id: \(id)")
            
            // Reference to Firestore
            let db = Firestore.firestore()
            
            // Query the document ID first
            db.collection("careerPaths")
                .whereField("careerPathId", isEqualTo: id)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching document: \(error)")
                        return
                    }
                    
                    guard let document = snapshot?.documents.first else {
                        print("No matching career path found.")
                        return
                    }
                    
                    // Ask the user for confirmation
                    self.showConfirmationAlert { confirmed in
                        if confirmed {
                            // Delete the document
                            document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    print("Career path removed successfully")
                                    
                                    // Update local data and reload collection view
                                    self.careerPaths.removeAll { $0.careerId == id }
                                    self.careerPathMngCollection.reloadData()
                                }
                            }
                        }
                    }
                }
        
        
    }
    
    
    // Function to display a confirmation alert
    func showConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Confirm Delete",
            message: "Are you sure you want to delete this career path?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            completion(true)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            completion(false)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }

    
    
}

