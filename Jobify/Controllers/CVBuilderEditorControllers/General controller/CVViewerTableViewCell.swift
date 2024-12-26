//
//  CVViewerTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 20/12/2024.
//

import UIKit

// Custom UITableViewCell subclass for displaying CV details
class CVViewerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var cvImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var txtEducation: UITextView!
    @IBOutlet weak var txtSkills: UITextView!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var txtExperience: UITextView!
    @IBOutlet weak var lblEducation: UILabel!
    @IBOutlet weak var lblSkills: UILabel!
    
    func adjustFontSize() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }

        lblName.font = lblName.font?.withSize(24)
        lblTitle.font = lblTitle.font?.withSize(22)
        lblEmail.font = lblEmail.font?.withSize(20)
        lblPhone.font = lblPhone.font?.withSize(20)
        lblCountry.font = lblCountry.font?.withSize(20)
        lblEducation.font = lblEducation.font?.withSize(22)
        lblSkills.font = lblSkills.font?.withSize(22)
        lblExperience.font = lblExperience.font?.withSize(22)
        
        txtEducation.font = txtEducation.font?.withSize(18)
        txtSkills.font = txtSkills.font?.withSize(18)
        txtExperience.font = txtExperience.font?.withSize(18)
    }
    
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustFontSize()
    }
    

    // MARK: - Setup Method
    /// Configures the cell with the provided CV data.
    func setup(cv: CV) {
           // Set personal details
           lblName.text = cv.personalDetails.name
           lblTitle.text = cv.preferredTitle
           lblEmail.text = cv.personalDetails.email
           lblPhone.text = cv.personalDetails.phoneNumber
           lblCountry.text = cv.personalDetails.country
           // Load and display the image from Cloudinary
           if let imageUrl = URL(string: cv.personalDetails.profilePicture) {
               loadImage(from: imageUrl) // Load image asynchronously
           } else {
               cvImage.image = nil // Set to nil if the URL is invalid
           }
           
           // Set education details
           txtEducation.text = cv.education.map {
               "\($0.degree ?? "Degree") from \($0.institution ?? "Institution") (\(formatDate($0.startDate)) - \(formatDate($0.endDate, isEndDate: true)))"
           }.joined(separator: "\n")
           
           // Set skills details
           txtSkills.text = cv.skills.map { $0.skillTitle ?? "Skill" }.joined(separator: ", ")
           
           // Set experience details
           txtExperience.text = cv.workExperience.map { experience in
               let endDate = experience.endDate ?? Date() // Use current date if endDate is nil
               let endDateString = Calendar.current.isDateInToday(endDate) || endDate > Date() ? "Present" : formatDate(endDate)
               let startDateString = formatDate(experience.startDate)
               return "\(experience.company ?? "Company") - \(experience.role ?? "Role") (\(startDateString) - \(endDateString))"
           }.joined(separator: "\n")
       }
          
    // MARK: - Image Loading
    /// Loads an image from the given URL and sets it to the imageView.
       private func loadImage(from url: URL) {
           // Using URLSession to load the image
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

    // MARK: - Date Formatting
    /// Formats the given date to a string showing only month and year.
       private func formatDate(_ date: Date?, isEndDate: Bool = false) -> String {
           guard let date = date else { return "N/A" }
           
           // Format the date to show only month and year
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM yyyy"
           return formatter.string(from: date)
       }
       
    // MARK: - Selection Handling
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }
   }
