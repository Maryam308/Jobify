//
//  Untitled.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//
import UIKit
import FirebaseFirestore
import Alamofire

class SeekerProfileViewController: UIViewController {
    // Define the imageView property
    
    @IBOutlet var nameTextField: UILabel!
    @IBOutlet var positionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var locationTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the circular image
        setupImageUploadCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDetails()
    }
    
    
    @IBAction func btnMyCVs(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
               if let myCVsVC = storyboard.instantiateViewController(identifier: "myCVs") as? CVBuilderEditorViewController {
                        navigationController?.pushViewController(myCVsVC, animated: true)
                    }
    }
    
    
    @IBAction func btnChat(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EmployerJobPostingAndEmployerApplicantInteraction_MaryamAhmed", bundle: nil)
        if let chatsAllVC = storyboard.instantiateViewController(identifier: "ChatsAll") as? chatsScreenViewController {
            navigationController?.pushViewController(chatsAllVC, animated: true)
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
    
    private func fetchDetails() {
        let db = Firestore.firestore()
        let user = (UserSession.shared.loggedInUser)!
        
        Task {
            //            print("before")
            let data = try await db.collection("seekerDetails").whereField("userID", isEqualTo: LoginViewController.userDocRef!).getDocuments().documents.first!.data()
            //            print(data)
            self.positionTextField.text = data["currentJobPosition"] as?  String
            //            print("after")
        }
        
        nameTextField.text = user.name
        locationTextField.text = user.city ?? "city not set"
        
        Cloudinary.downloadImage(from: user.imageURL ?? "") { result in
            switch result {
            case .success(let image):
                print("Image downloaded successfully!")
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Failed to download image: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seekerProfileToEdit" {
            let vc = segue.destination as! SeekerProfileNoCVEditViewController
            _ = vc.view
            
            vc.imageView.image = imageView.image
            vc.txtLocation.text
            = locationTextField.text
            vc.txtName.text = nameTextField.text
            vc.txtPosition.text = positionTextField.text
        }
    }
}

class SeekerProfileViewControllerWithCV: UIViewController {
    
    // Define the imageView property
    @IBOutlet weak var imageView: UIImageView!
    
    // Define the EducationtextView property
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    @IBOutlet weak var btnMyCVS: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()
        
    }
    
    
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0

    }
    
    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    @IBAction func btnMyCVs(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CVBuilderAndEditor_MaryamMohsen", bundle: nil)
        if let myCVsVC = storyboard.instantiateViewController(identifier: "myCVs") as? CVBuilderEditorViewController {
            navigationController?.pushViewController(myCVsVC, animated: true)
        }
    }
    
    
}


class SeekerProfileViewControllerWithCV_EditViewController: UIViewController {
    
    // Define the imageView property
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()
    }
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0

    }
    
    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    
    
}







class SeekerProfilePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var educationTextView: UITextView!
    
    @IBOutlet weak var experinceTextView: UITextView!
    
    @IBOutlet weak var skillsTextView: UITextView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var txtPosition: UITextField!
    @IBOutlet var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
        
        // Add border and corner radius to the Education text view
        setupEducationTextView()
        
        // Add border and corner radius to the Experince text view
        setupExperinceTextView()
        
        // Add border and corner radius to the Skills text view
        setupSkillsTextView()
        
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
            
            data = try await db.collection("seekerDetails").whereField("userID", isEqualTo: LoginViewController.userDocRef!).getDocuments().documents.first!.data()
            txtPosition.text = data["currentJobPosition"] as? String
            let eduArary = data["education"] as? [String] ?? []
            let expArary = data["experience"] as? [String] ?? []
            let skillsArary = data["skills"] as? [String] ?? []

            educationTextView.text = eduArary.joined(separator: "\n")
            experinceTextView.text = expArary.joined(separator: "\n")
            skillsTextView.text = skillsArary.joined(separator: "\n")
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
    
    // Define the setupEducationTextView method
    private func setupEducationTextView() {
        educationTextView.layer.borderWidth = 1.0
        educationTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        educationTextView.layer.cornerRadius = 15.0
        educationTextView.clipsToBounds = true // Ensures content respects the corner radius
        educationTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupExperinceTextView() {
        experinceTextView.layer.borderWidth = 1.0
        experinceTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        experinceTextView.layer.cornerRadius = 15.0
        experinceTextView.clipsToBounds = true // Ensures content respects the corner radius
        experinceTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // Define the setupEducationTextView method
    private func setupSkillsTextView() {
        skillsTextView.layer.borderWidth = 1.0
        skillsTextView.layer.borderColor = UIColor.black.cgColor // Black border color
        skillsTextView.layer.cornerRadius = 15.0
        skillsTextView.clipsToBounds = true // Ensures content respects the corner radius
        skillsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}




class SeekerProfileNoCVEditViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var txtPosition: UITextField!
    @IBOutlet var txtName: UITextField!
    
    var imageUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circular image
        setupImageUploadCircle()
    }
    
    
    // Define the setupImageUploadCircle method
    private func setupImageUploadCircle() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0

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
                
                let dec2 = ["currentJobPosition" : txtPosition.text!]
                
                try await db.collection("seekerDetails")
                    .whereField("userID", isEqualTo: LoginViewController.userDocRef!)
                    .getDocuments()
                    .documents
                    .first!
                    .reference
                    .updateData(dec2)
                
                imageUpdated = false
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("Error saving to the database: \(error)")
                return
            }
        }
        
    }
    
    private func validateInput() -> Bool {
        // Validate name field
        if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Name field connot be empty.")
            return false
        }
        
        // Check if Current Job Position is filled
        if txtPosition.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Job Position field connot be empty.")
            return false
        }
        
        if txtLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            showAlert(message: "Location field connot be empty.")
            return false
        }
        
        return true
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
    
}






class seekerProfilePreviewViewController: UIViewController {
    
    
    
}

struct Cloudinary {
    static func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "DownloadImageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                let error = NSError(domain: "DownloadImageError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
                completion(.failure(error))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
    
    static func uploadImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "CloudinaryUploadError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to JPEG data"])
        }
        
        let cloudinaryURL = "https://api.cloudinary.com/v1_1/dvxwcsscw/image/upload"
        let uploadPreset = "JobifyImages"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(
                    imageData, withName: "file",
                    fileName: "profile.jpg",
                    mimeType: "image/jpeg"
                )
                
                multipartFormData.append(
                    uploadPreset.data(using: .utf8)!,
                    withName: "upload_preset"
                )
            }, to: cloudinaryURL)
            .responseDecodable(of: CloudinaryResponse.self) { response in
                switch response.result {
                case .success(let cloudinaryResponse):
                    print("Cloudinary response: \(cloudinaryResponse)")
                    continuation.resume(returning: cloudinaryResponse.secure_url)
                    
                case .failure(let error):
                    print("Error uploading to Cloudinary: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
