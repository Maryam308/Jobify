//
//  JobCategoryViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 09/12/2024.
//

import UIKit

class JobCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // UI Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // Data source for the collection view
    var categories: [JobCategory] = [] // Assuming JobCategory is a predefined model

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup collection view data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register the collection view cell nib
        let nib = UINib(nibName: "JobsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "JobsCollectionViewCell")
        
        // Setup the collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Ensure vertical scrolling
        collectionView.collectionViewLayout = layout
    }

    // MARK: - UICollectionViewDataSource Methods

    /// Return the number of items in the section
    /// - Parameter collectionView: The calling collection view
    /// - Parameter section: The section index
    /// - Returns: The number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    /// Configure and return the cell for the specified item
    /// - Parameter collectionView: The calling collection view
    /// - Parameter indexPath: The index path of the item
    /// - Returns: A configured UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobsCollectionViewCell", for: indexPath) as! JobsCollectionViewCell
        
        // Populate the cell with category information
        cell.setUp(category: categories[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout Methods

    /// Return the size for each item in the collection view
    /// - Parameter collectionView: The calling collection view
    /// - Parameter collectionViewLayout: The layout object
    /// - Parameter indexPath: The index path of the item
    /// - Returns: The size of the item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 4 // Spacing between cells and edges
        let totalSpacing = padding * 4 // Total spacing for two columns
        
        // Calculate the width for two columns
        let width = (collectionView.frame.width - totalSpacing) / 2
        let height = width * 0.9 // Adjust height for the aspect ratio
        
        return CGSize(width: width, height: height)
    }

    // MARK: - UICollectionViewDelegate Methods

    /// Handle item selection in the collection view
    /// - Parameter collectionView: The calling collection view
    /// - Parameter indexPath: The index path of the selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row].title
        
        // Instantiate and navigate to JobPostsViewController
        let storyboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)
        if let jobPostsVC = storyboard.instantiateViewController(withIdentifier: "JobPostsViewController") as? JobPostsViewController {
            jobPostsVC.source = .category(selectedCategory) // Pass the selected category
            navigationController?.pushViewController(jobPostsVC, animated: true)
        }
    }
}
