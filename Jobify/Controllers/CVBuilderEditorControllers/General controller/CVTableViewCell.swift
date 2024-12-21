//
//  CVTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import UIKit

class CVTableViewCell: UITableViewCell {
    //creating outlets
    var onDelete: (() -> Void)?
    var cv: CV? //a reference to the CV object
    var favoriteAction: ((CV) -> Void)? // Closure to handle favorite action
    
    @IBOutlet weak var CVCellView: UIView!
    
    @IBOutlet weak var lblCVTitle: UILabel!
    
    @IBOutlet weak var lblCVAddDate: UILabel!
    
    @IBOutlet weak var favoriteCVBtn: UIButton!
    
    
    @IBOutlet weak var cvImage: UIImageView!
    //creating actions for buttons
    @IBAction func btnViewCVTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
         navigateToCVView(cv: cv)
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
          
          // Populate CVData singleton with the data from cvToEdit
          CVData.shared.cvToEdit = cv // Set the CV to be edited
          CVData.shared.name = cv.personalDetails.name
          CVData.shared.email = cv.personalDetails.email
          CVData.shared.phone = cv.personalDetails.phoneNumber
          CVData.shared.country = cv.personalDetails.country
          CVData.shared.city = cv.personalDetails.city
          CVData.shared.profileImage = UIImage(named: cv.personalDetails.profilePicture)
          
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
    
    
    @IBAction func btnDeleteCVTapped(_ sender: UIButton) {
        onDelete?()
    }
    
    
    @IBAction func btnFavoriteCVTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
         favoriteAction?(cv)
    }
    
    func updateFavoriteButton() {
         // Update the favorite button appearance based on isFavorite
         let starImageName = cv?.isFavorite == true ? "star.fill" : "star"
         favoriteCVBtn.setImage(UIImage(systemName: starImageName), for: .normal)
     }
    
    // Setup the cell
    func setup(_ cv: CV) {
        self.cv = cv // Store the CV reference
        lblCVTitle.text = cv.cvTitle
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: cv.creationDate)
        lblCVAddDate.text = formattedDate
        
        // Set the CV image
        if let imageUrl = URL(string: cv.personalDetails.profilePicture) {
            loadImage(from: imageUrl)
        } else {
            cvImage.image = nil // Set to nil if the URL is invalid
        }
        
        updateFavoriteButton() // Ensure the button reflects the current favorite state
    }
    
       
       private func loadImage(from url: URL) {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   return
               }
               DispatchQueue.main.async {
                   self.cvImage.image = UIImage(data: data)
               }
           }
           task.resume()
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CVCellView.layer.cornerRadius = contentView.frame.height / 9
        // Shadow configuration
        CVCellView.layer.shadowColor = UIColor.black.cgColor
        CVCellView.layer.shadowOpacity = 0.2
        CVCellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        CVCellView.layer.shadowRadius = 6
        CVCellView.layer.shadowPath = UIBezierPath(rect: CVCellView.bounds).cgPath
        CVCellView.layer.shouldRasterize = false
        
        //content view configuration
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }

    private func navigateToCVView(cv: CV) {
          // Get the view controller from the storyboard
        if let viewController = self.parentViewController?.storyboard?.instantiateViewController(withIdentifier: "cvViewer") as? CVViewerViewController {
              viewController.cv = cv // Pass the entire CV object to the next view controller
              self.parentViewController?.navigationController?.pushViewController(viewController, animated: true)
          }
      }
  }

  // Extension to get the parent view controller
  extension UIView {
      var parentViewController: UIViewController? {
          var parentResponder: UIResponder? = self
          while let responder = parentResponder {
              if let viewController = responder as? UIViewController {
                  return viewController
              }
              parentResponder = responder.next
          }
          return nil
      }
  }
