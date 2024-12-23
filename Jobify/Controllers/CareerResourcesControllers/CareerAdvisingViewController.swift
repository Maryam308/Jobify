//
//  CareerAdvisingViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 22/12/2024.
//
struct CareerPath1 {
    var title: String
    var description: String
    var roadmap: String
    var demand: String
    
    // Custom initializer
       init(careerName: String, description: String, roadmap: String, demand: String) {
           self.title = careerName
           self.description = description
           self.roadmap = roadmap
           self.demand = demand
       }
}
import UIKit
import FirebaseFirestore

import FirebaseFirestore



class CareerAdvisingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // Property to hold the fetched career paths
    var careerPaths: [CareerPath1] = []
    var mentors: [User] = []
    
    @IBOutlet weak var careerPathCollectionView: UICollectionView!
    let careerPathCollectionViewCellId = "CareerPathCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        careerPathCollectionView.collectionViewLayout = layout
        
        careerPathCollectionView.delegate = self
        careerPathCollectionView.dataSource = self
        
        let careerPathNib = UINib(nibName: "CareerPathCollectionViewCell", bundle: nil)
        careerPathCollectionView.register(careerPathNib, forCellWithReuseIdentifier: careerPathCollectionViewCellId)
        // Fetch career paths
        fetchCareerPaths()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careerPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: careerPathCollectionViewCellId, for: indexPath) as! CareerPathCollectionViewCell
        cell.setUp(careerPath: careerPaths[indexPath.item].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalSpacing = padding * 2
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height: CGFloat = 140
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCareerPath = careerPaths[indexPath.item]
        showPopup(with: selectedCareerPath)
    }
    
    private func showPopup(with careerPath: CareerPath1) {
        let popupVC = PopupViewController()
        popupVC.createInstanceOfPopUp(senderView: view, theViewController: self, sizeOfPopUpViewContainer: 400)
        popupVC.careerPath = careerPath // Pass the selected career path
        popupVC.openPopUpView()
    }
    
    private func fetchCareerPaths() {
        db.collection("careerPaths")
            .limit(to: 5)
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
                
                self.careerPaths.removeAll()
                
                for document in documents {
                    let data = document.data()
                 /*   print("Document data: \(data)")*/ // Debugging output
                    
                    guard let title = data["title"] as? String, !title.isEmpty,
                          let demandString = data["demand"] as? String, !demandString.isEmpty,
                          let roadmap = data["roadmap"] as? String, !roadmap.isEmpty else {
//                        print("Error parsing document: \(data)")
                        continue
                    }
                    
                    let careerPath = CareerPath1(careerName: title, description: "", roadmap: roadmap, demand: demandString)
                    self.careerPaths.append(careerPath)
                }
                
             /*   print("Career paths fetched: \(self.careerPaths)")*/ // Debugging output
                self.careerPathCollectionView.reloadData()
            }
    }
    
}
