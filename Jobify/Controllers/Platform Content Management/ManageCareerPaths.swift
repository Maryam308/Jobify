//
//  Untitled.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//
import UIKit
import Firebase

class ManageCareerPathsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    var careerPaths: [CareerPath] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        careerPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //fetch the cell to reuse using the specified one from the in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manageCareerPathCell", for: indexPath) as! ManageCareerPathCollectionViewCell
        
        //set the title label to the learning resource title
        cell.lblCareerTitle.text = careerPaths[indexPath.item].title
                           
        //return the ready cell
        return cell
    }
    
    @IBOutlet weak var careerPathMngCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let title = data["title"] as? String ?? "Untitled"
                    
                    let careerPath = CareerPath(title: title)
                    
                    return careerPath
                }
                
                // Reload the collection view with the fetched data
                DispatchQueue.main.async {
                    self.careerPathMngCollection.reloadData()
                }
            }
    }
    
    
}

