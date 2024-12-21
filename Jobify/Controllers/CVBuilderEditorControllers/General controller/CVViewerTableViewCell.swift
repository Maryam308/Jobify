//
//  CVViewerTableViewCell.swift
//  Jobify
//
//  Created by Maryam Yousif on 20/12/2024.
//

import UIKit

class CVViewerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cvImage: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var txtEducation: UITextView!
    
    
    @IBOutlet weak var txtSkills: UITextView!
    
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var txtExperience: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(cv: CV) {
           // Set personal details
           lblName.text = cv.personalDetails.name
           lblTitle.text = cv.preferredTitle
           lblEmail.text = cv.personalDetails.email
           lblPhone.text = cv.personalDetails.phoneNumber
           
           // Load and display the image from Cloudinary
           if let imageUrl = URL(string: cv.personalDetails.profilePicture) {
               loadImage(from: imageUrl)
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
          
       private func loadImage(from url: URL) {
           // Using URLSession to load the image
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

       private func formatDate(_ date: Date?, isEndDate: Bool = false) -> String {
           guard let date = date else { return "N/A" }
           
           // Format the date to show only month and year
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM yyyy"
           return formatter.string(from: date)
       }
       
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)


       }
   }
