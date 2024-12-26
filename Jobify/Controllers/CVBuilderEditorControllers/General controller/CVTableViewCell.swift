//
//  CVTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import UIKit

// Custom UITableViewCell subclass for displaying CV information
class CVTableViewCell: UITableViewCell {
    // MARK: - Properties
    var onDelete: (() -> Void)? // Closure to handle delete action
    var cv: CV? // Reference to the CV object
    var favoriteAction: ((CV) -> Void)? // Closure to handle favorite action
    
    
    // UI Outlets
    @IBOutlet weak var CVCellView: UIView! // Container view for the cell
    @IBOutlet weak var lblCVTitle: UILabel!  // Label for CV title
    @IBOutlet weak var lblCVAddDate: UILabel! // Label for CV addition date
    @IBOutlet weak var favoriteCVBtn: UIButton! // Button for marking CV as favorite
    @IBOutlet weak var cvImage: UIImageView! // ImageView for displaying CV image
    
    func adjustFontSizeForCVLabels() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }

        lblCVTitle.font = lblCVTitle.font?.withSize(22)
        lblCVAddDate.font = lblCVAddDate.font?.withSize(20)
    }
    
    // MARK: - Button Actions
    // Action for viewing the CV details
    @IBAction func btnViewCVTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
         navigateToCVView(cv: cv)
    }
    
    //Helper function:  Navigate to the CV view controller with the selected CV
    private func navigateToCVView(cv: CV) {
          // Get the view controller from the storyboard
        if let viewController = self.parentViewController?.storyboard?.instantiateViewController(withIdentifier: "cvViewer") as? CVViewerViewController {
              viewController.cv = cv // Pass the entire CV object to the next view controller
              self.parentViewController?.navigationController?.pushViewController(viewController, animated: true)
          }
      }

    // Action for editing the CV
    @IBAction func btnEditTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
          
          // Populate CVData singleton with the data from cvToEdit
          CVData.shared.cvToEdit = cv // Set the CV to be edited
          CVData.shared.name = cv.personalDetails.name
          CVData.shared.email = cv.personalDetails.email
          CVData.shared.phone = cv.personalDetails.phoneNumber
          CVData.shared.country = cv.personalDetails.country
          CVData.shared.city = cv.personalDetails.city
          CVData.shared.profileImageURL = cv.personalDetails.profilePicture
        
          // Populate education, skills, and experience
          CVData.shared.education = cv.education
          CVData.shared.skill = cv.skills
          CVData.shared.experience = cv.workExperience
          
          CVData.shared.cvTitle = cv.cvTitle
          CVData.shared.jobTitle = cv.preferredTitle

          // Instantiate personalDetailVC from storyboard
          if let detailVC = self.parentViewController?.storyboard?.instantiateViewController(withIdentifier: "personalDetailVC") as? CVBuilderEditorTableViewController {
              self.parentViewController?.navigationController?.pushViewController(detailVC, animated: true)
          }
    }
    
    // Action for deleting the CV
    @IBAction func btnDeleteCVTapped(_ sender: UIButton) {
        onDelete?()
    }
    
    // Action for marking the CV as favorite
    @IBAction func btnFavoriteCVTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
         favoriteAction?(cv)
    }
    
    
    // MARK: - Layout Handling
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the content view fills the cell
        contentView.frame = bounds
    }
    
    // Function to Update the appearance of the favorite button based on the CV's favorite status
    func updateFavoriteButton() {
         // Update the favorite button appearance based on isFavorite
         let starImageName = cv?.isFavorite == true ? "star.fill" : "star"
         favoriteCVBtn.setImage(UIImage(systemName: starImageName), for: .normal)
     }
    
    // Setup the cell with CV data
    func setup(_ cv: CV) {
        self.cv = cv // Store the CV reference
        lblCVTitle.text = cv.cvTitle // Set CV title
        
        // Format and set the addition date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: cv.creationDate)
        lblCVAddDate.text = formattedDate
        
        // Load the CV image from the URL
        if let imageUrl = URL(string: cv.personalDetails.profilePicture) {
            loadImage(from: imageUrl) // Load image asynchronously
        } else {
            cvImage.image = UIImage(systemName: "person.circle") // Set default image if URL is invalid
        }

        
        updateFavoriteButton() // Ensure the button reflects the current favorite state
    }
    
       
    // Function to Load image asynchronously from a URL
       private func loadImage(from url: URL) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   return // Exit if there's an error
               }
               DispatchQueue.main.async {
                   self.cvImage.image = UIImage(data: data) // Update image on the main thread
               }
           }
           task.resume()
       }
    
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSizeForCVLabels()
        CVCellView.layer.cornerRadius = contentView.frame.height / 9 // Round corners of the cell view

        contentView.backgroundColor = .white // Set background color
        backgroundColor = .clear // Set cell background to clear
        
    }

  }

// MARK: - Extension to get the parent view controller
  extension UIView {
      var parentViewController: UIViewController? {
          var parentResponder: UIResponder? = self
          while let responder = parentResponder {
              if let viewController = responder as? UIViewController {
                  return viewController // Return the parent view controller if found
              }
              parentResponder = responder.next // Move up the responder chain
          }
          return nil // Return nil if no parent view controller is found
      }
  }
