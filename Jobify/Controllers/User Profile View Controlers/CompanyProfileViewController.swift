//
//  CompanyProfileViewController.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

import UIKit
import FirebaseFirestore
class CompanyProfilePreviewViewController: UIViewController {
    
    // Connect your view from the storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    @IBOutlet weak var employabilityGoalsTextView: UITextView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet weak var ourVisionTextView: UITextView!
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the About Us text view
        setupAboutUsTextView()
        
        // Add border and corner radius to the Our Employability Goals text view
        setupEmployabilityGoalsTextView()
        
        // Add border and corner radius to the Our Vision text view
        setupOurVisionextView()
        
        fetchData()
    }
    
    func fetchData() {
        let user = UserSession.shared.loggedInUser!
        let db = Firestore.firestore()
        
        Cloudinary.downloadImage(from: user.imageURL ?? "") { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
        
        Task {
            var data =  try await db.collection("users").whereField("email", isEqualTo: user.email).getDocuments().documents.first!.data()
            lblName.text = data["name"] as? String
            lblLocation.text = data["city"] as? String
            
            data =  try await db.collection("employerDetails").whereField("userID", isEqualTo: LoginViewController.userDocRef!).getDocuments().documents.first!.data()
            ourVisionTextView.text = data["ourVision"] as? String
            employabilityGoalsTextView.text = data["ourEmployiblityGoals"] as? String
            aboutUsTextView.text = data["aboutUs"] as? String
            txtCategory.text = data["companyMainCategory"] as? String
        }
        
        
    }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
    }
    
    // Define the setupAboutUsTextView method
    private func setupAboutUsTextView() {
        aboutUsTextView.layer.borderWidth = 1.0
        aboutUsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        aboutUsTextView.layer.cornerRadius = 15.0
        aboutUsTextView.clipsToBounds = true // Ensures content respects the corner radius
        aboutUsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupmployabilityGoalsTextView method
    private func setupEmployabilityGoalsTextView() {
        employabilityGoalsTextView.layer.borderWidth = 1.0
        employabilityGoalsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        employabilityGoalsTextView.layer.cornerRadius = 15.0
        employabilityGoalsTextView.clipsToBounds = true // Ensures content respects the corner radius
        employabilityGoalsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupOurVisionextView method Our Vision
    private func setupOurVisionextView() {
        ourVisionTextView.layer.borderWidth = 1.0
        ourVisionTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        ourVisionTextView.layer.cornerRadius = 15.0
        ourVisionTextView.clipsToBounds = true // Ensures content respects the corner radius
        ourVisionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}


class CompanyProfileDetailsFormViewController: UIViewController {
    
    //////
}


class CompanyProfileEditViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    // Connect your view from the storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var aboutUsTextView: UITextView!
    
    @IBOutlet weak var employabilityGoalsTextView: UITextView!
    
    @IBOutlet weak var ourVisionTextView: UITextView!
    
    let db = Firestore.firestore()
    
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var txtName: UITextField!
    
    var imageUpdated = false
    var companyDetailsRef: DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the About Us text view
        setupAboutUsTextView()
        
        // Add border and corner radius to the Our Employability Goals text view
        setupEmployabilityGoalsTextView()
        
        // Add border and corner radius to the Our Vision text view
        setupOurVisionextView()
    }
    
    func loadDetails() {
        Task {
            let data = try await companyDetailsRef?.getDocument().data()
            
            if let data {
                aboutUsTextView.text = data["aboutUs"] as? String
                employabilityGoalsTextView.text = data["ourEmployiblityGoals"] as? String
                ourVisionTextView.text = data["ourVision"] as? String
            }
        }
    }
    
    private func validateInput() -> Bool {
        // Validate name field
        if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Name field cannot be empty.")
            return false
        }
        
        // Validate About Us text view
        if aboutUsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "About Us field cannot be empty.")
            return false
        }
        
        // Validate Goals text view
        if employabilityGoalsTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Goals field cannot be empty.")
            return false
        }
        
        // Validate Vision text view
        if ourVisionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Vision field cannot be empty.")
            return false
        }
        
        if txtLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Location field cannot be empty.")
            return false
        }
        
        return true
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        guard validateInput() else { return }
        
        Task {
            do {
                var dec = [
                    "city" : txtLocation.text!,
                    "name" : txtName.text!,
                ]
                
                
                if imageUpdated {
                    UserSession.shared.loggedInUser!.imageURL = try await Cloudinary.uploadImage(image: imageView.image!)
                    dec["profileImageURL"] = UserSession.shared.loggedInUser!.imageURL
                }
                
                try await LoginViewController.userDocRef!.updateData(dec)
                
                UserSession.shared.loggedInUser!.city = txtLocation.text!
                UserSession.shared.loggedInUser!.name = txtName.text!
                
                dec = [
                    "companyMainCategory" : txtCategory.text!,
                    "aboutUs" : aboutUsTextView.text!,
                    "ourEmployiblityGoals" : employabilityGoalsTextView.text!,
                    "ourVision" : ourVisionTextView.text!,
                ]
                
                try await db.collection("employerDetails")
                    .whereField("userID", isEqualTo: LoginViewController.userDocRef!)
                    .getDocuments()
                    .documents
                    .first!
                    .reference
                    .updateData(dec)
                
                imageUpdated = false
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("Error saving to the database: \(error)")
                return
            }
        }
        
    }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
    }
    
    // Define the setupAboutUsTextView method
    private func setupAboutUsTextView() {
        if let text = aboutUsTextView.text {
            aboutUsTextView.layer.borderWidth = 1.0
            aboutUsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
            aboutUsTextView.layer.cornerRadius = 15.0
            aboutUsTextView.clipsToBounds = true // Ensures content respects the corner radius
            aboutUsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    // Define the setupmployabilityGoalsTextView method
    private func setupEmployabilityGoalsTextView() {
        employabilityGoalsTextView.layer.borderWidth = 1.0
        employabilityGoalsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        employabilityGoalsTextView.layer.cornerRadius = 15.0
        employabilityGoalsTextView.clipsToBounds = true // Ensures content respects the corner radius
        employabilityGoalsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupOurVisionextView method Our Vision
    private func setupOurVisionextView() {
        ourVisionTextView.layer.borderWidth = 1.0
        ourVisionTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        ourVisionTextView.layer.cornerRadius = 15.0
        ourVisionTextView.clipsToBounds = true // Ensures content respects the corner radius
        ourVisionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage // Preview the selected image
            imageUpdated = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage // Preview the selected image
            imageUpdated = true
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func btnEditPhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

