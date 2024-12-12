//
//  JobCategoryViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 09/12/2024.
//

import UIKit

class JobCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCollectionViewCell", for: indexPath) as! JobsCollectionViewCell
        
        // populate information from the cell to the collection view from the categories we created
        cell.setUp(category: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 4 // Spacing between cells and edges
        let totalSpacing = padding * 4 // Spacing for two columns (left, right, and inter-column)
        
        // Calculate the width for two columns
        let width = (collectionView.frame.width - totalSpacing) / 2
        let height = width * 0.9 // Adjust height for the aspect ratio
        
        return CGSize(width: width , height: height)
    }

    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
           collectionView.delegate = self
        
        let nib = UINib(nibName: "JobsCollectionViewCell", bundle: nil)
               collectionView.register(nib, forCellWithReuseIdentifier: "JobsCollectionViewCell")
           
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .vertical // Ensure vertical scrolling
           collectionView.collectionViewLayout = layout
        
    }
}
