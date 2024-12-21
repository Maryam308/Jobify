//
//  CVViewerViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 20/12/2024.
//

import UIKit
import FirebaseFirestore
import Firebase

class CVViewerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cv: CV? // Property to hold the CV object

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    
             if let cv = cv {
                 // Use cv to display its details
                 print("CV Title: \(cv.cvTitle)")
                 // Display other details as needed
             }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register tableView with cv viewer cell
        tableView.register(UINib(nibName: "CVViewerTableViewCell", bundle: .main), forCellReuseIdentifier: "CVViewerTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CVViewerTableViewCell", for: indexPath) as! CVViewerTableViewCell
        cell.setup(cv: cv!)
        cell.frame.size.width = tableView.bounds.width
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height 
    }

    
    @IBAction func btnExportPdfTapped(_ sender: UIButton) {
        guard let cv = cv else { return }
              createPDF(cv: cv)
    }
    
   // reference: https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GeneratingPDF/GeneratingPDF.html
   // https://stackoverflow.com/questions/70337689/create-pdf-with-wkwebview-pdfconfiguration
    
    func createPDF(cv: CV) {
        let pdfFilename = getDocumentsDirectory().appendingPathComponent("CV_\(cv.cvTitle).pdf")
        
        if let imageUrl = URL(string: cv.personalDetails.profilePicture) {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(String(describing: error))")
                    return
                }
                
                if let profileImage = UIImage(data: data) {
                    UIGraphicsBeginPDFContextToFile(pdfFilename.path, .zero, nil)
                    UIGraphicsBeginPDFPage()

                    let pdfWidth = 595.2
                    let pdfHeight = 842.0
                    guard let context = UIGraphicsGetCurrentContext() else { return } // Capture context

                    var yPosition = 20.0

                    // Draw Profile Picture
                    let imageRect = CGRect(x: 20, y: yPosition, width: 100, height: 100)
                    profileImage.draw(in: imageRect)

                    // Draw Name
                    let nameRect = CGRect(x: 140, y: yPosition, width: pdfWidth - 160, height: 30)
                    cv.personalDetails.name.draw(in: nameRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 24)])

                    // Draw Title
                    let titleRect = CGRect(x: 140, y: yPosition + 30, width: pdfWidth - 160, height: 30)
                    cv.preferredTitle.draw(in: titleRect, withAttributes: [.font: UIFont.systemFont(ofSize: 20)])

                    // Draw Email and Location
                    let emailRect = CGRect(x: 140, y: yPosition + 60, width: pdfWidth - 160, height: 20)
                    cv.personalDetails.email.draw(in: emailRect, withAttributes: [.font: UIFont.systemFont(ofSize: 16)])

                    let locationRect = CGRect(x: 140, y: yPosition + 80, width: pdfWidth - 160, height: 20)
                    "\(cv.personalDetails.city), \(cv.personalDetails.country)".draw(in: locationRect, withAttributes: [.font: UIFont.systemFont(ofSize: 16)])

                    yPosition += 120

                    // Draw Education Section
                    let educationTitleRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 30)
                    "Education".draw(in: educationTitleRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
                    
                    yPosition += 40
                    for edu in cv.education {
                        if let degree = edu.degree, let institution = edu.institution {
                            let educationText = "\(degree) at \(institution)"
                            let educationRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 20)
                            educationText.draw(in: educationRect, withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
                            
                            let datesText = "\(self.formatDate(edu.startDate)) - \(self.formatDate(edu.endDate, isEndDate: true))"
                            let datesRect = CGRect(x: 20, y: CGFloat(yPosition + 20), width: pdfWidth - 40, height: 20)
                            datesText.draw(in: datesRect, withAttributes: [.font: UIFont.italicSystemFont(ofSize: 14)])
                            
                            yPosition += 60
                            
                            // Draw line separator
                            context.setStrokeColor(UIColor.lightGray.cgColor)
                            context.setLineWidth(1)
                            context.move(to: CGPoint(x: 20, y: yPosition))
                            context.addLine(to: CGPoint(x: pdfWidth - 20, y: yPosition))
                            context.strokePath()
                            
                            yPosition += 20
                        }
                    }

                    // Draw Skills Section
                    let skillsTitleRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 30)
                    "Skills".draw(in: skillsTitleRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
                    
                    yPosition += 40
                    let skillsText = cv.skills.compactMap { $0.skillTitle }.joined(separator: ", ")
                    let skillsRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 20)
                    skillsText.draw(in: skillsRect, withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
                    
                    // Draw line separator
                    yPosition += 40
                    context.setStrokeColor(UIColor.lightGray.cgColor)
                    context.setLineWidth(1)
                    context.move(to: CGPoint(x: 20, y: yPosition))
                    context.addLine(to: CGPoint(x: pdfWidth - 20, y: yPosition))
                    context.strokePath()
                    
                    yPosition += 20

                    // Draw Work Experience Section
                    let experienceTitleRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 30)
                    "Work Experience".draw(in: experienceTitleRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
                    
                    yPosition += 40
                    for experience in cv.workExperience {
                        if let role = experience.role, let company = experience.company {
                            let experienceText = "\(role) at \(company)"
                            let experienceRect = CGRect(x: 20, y: CGFloat(yPosition), width: pdfWidth - 40, height: 20)
                            experienceText.draw(in: experienceRect, withAttributes: [.font: UIFont.systemFont(ofSize: 16)])
                            
                            let experienceDatesText = "\(self.formatDate(experience.startDate)) - \(self.formatDate(experience.endDate, isEndDate: true))"
                            let experienceDatesRect = CGRect(x: 20, y: CGFloat(yPosition + 20), width: pdfWidth - 40, height: 20)
                            experienceDatesText.draw(in: experienceDatesRect, withAttributes: [.font: UIFont.italicSystemFont(ofSize: 14)])
                            
                            yPosition += 60
                            
                            // Draw line separator
                            context.setStrokeColor(UIColor.lightGray.cgColor)
                            context.setLineWidth(1)
                            context.move(to: CGPoint(x: 20, y: yPosition))
                            context.addLine(to: CGPoint(x: pdfWidth - 20, y: yPosition))
                            context.strokePath()
                            
                            yPosition += 20
                        }
                    }

                    UIGraphicsEndPDFContext()

                    // Share the PDF
                    DispatchQueue.main.async {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = scene.windows.first(where: { $0.isKeyWindow }) {
                            let activityVC = UIActivityViewController(activityItems: [pdfFilename], applicationActivities: nil)
                            window.rootViewController?.present(activityVC, animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    // Helper function to format dates
    func formatDate(_ date: Date?, isEndDate: Bool = false) -> String {
        guard let date = date else { return "N/A" }
        
        // Get the current date
        let currentDate = Date()
        
        // Check if the date is in the future (for the end date)
        if isEndDate && date > currentDate {
            return "Present"
        }
        
        // Format the date to show only month and year
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
      func getDocumentsDirectory() -> URL {
          return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      }
}
