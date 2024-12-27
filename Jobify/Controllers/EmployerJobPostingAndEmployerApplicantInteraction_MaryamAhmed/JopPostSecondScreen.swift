//
//  JopPostSecondScreen.swift
//  Jobify
//
//  Created by Maryam Ahmed on 24/12/2024.
//

import UIKit
import Firebase
import Alamofire


class JopPostCreationSecondScreenViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //in this screen the id will be set from the other screen for the already added information from the first screen
    
    var jopPostId: Int?
    let db = Firestore.firestore()
    var selectedImage: UIImage?
    var imageURL: String?

    
    //all outlets
    
    @IBOutlet weak var txtDescriptioin: UITextView!
    
    
    @IBOutlet weak var txtRequirments: UITextView!
    
    
    
    @IBOutlet weak var datePickerDeadline: UIDatePicker!
    
    
    @IBOutlet weak var lblStatusImage: UILabel!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //add borders to the text views
        txtDescriptioin.layer.cornerRadius = 10
        txtDescriptioin.layer.borderWidth = 1
        txtDescriptioin.layer.borderColor = UIColor.lightGray.cgColor
        txtDescriptioin.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        txtRequirments.layer.cornerRadius = 10
        txtRequirments.layer.borderWidth = 1
        txtRequirments.layer.borderColor = UIColor.lightGray.cgColor
        txtRequirments.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        // Print the jobId to check if it has been passed correctly
        if let jobId = jopPostId {
            print("Received jobId: \(jobId)")
        }
        
    }
    
    
    
    @IBAction func btnAdd(_ sender: Any) {
        // Validate inputs
            guard let description = txtDescriptioin.text, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showAlert(message: "Please enter a job description.")
                return
            }
            
            guard let requirements = txtRequirments.text, !requirements.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                showAlert(message: "Please enter job requirements.")
                return
            }
            
            let deadline = datePickerDeadline.date
            
            // Ensure jobPostId is valid
        guard jopPostId != nil else {
                showAlert(message: "Job post ID is missing. Please go back and try again.")
                return
            }
            
            // Variable to store the image URL if an image is uploaded
            var imageUrl: String? = nil

            // Check if the image is selected and upload if needed
            if let selectedImage = selectedImage {
                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                    Task {
                        do {
                            // Upload image to Cloudinary and get URL
                            imageUrl = try await uploadImageToCloudinary(imageData: imageData)
                            print("Image uploaded successfully: \(imageUrl ?? "")")
                            
                            // After the image is uploaded, update Firestore
                            updateJobPostInFirestore(description: description, requirements: requirements, deadline: deadline, imageUrl: imageUrl)
                        } catch {
                            print("Failed to upload image: \(error)")
                            lblStatusImage.text = "Image upload failed"
                            lblStatusImage.textColor = .systemRed
                        }
                    }
                }
            } else {
                // If no image is selected, update Firestore without an image URL
                updateJobPostInFirestore(description: description, requirements: requirements, deadline: deadline, imageUrl: nil)
            }
        
    }
    
    private func updateJobPostInFirestore(description: String, requirements: String, deadline: Date, imageUrl: String?) {
        // Fetch the job post document from Firestore and update it
        db.collection("jobPost")
            .whereField("jobPostId", isEqualTo: jopPostId ?? 0)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching job post document: \(error)")
                    self?.showAlert(message: "An error occurred while fetching the job post. Please try again.")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No job post found with ID \(self?.jopPostId ?? 0)")
                    self?.showAlert(message: "Job post not found. Please go back and try again.")
                    return
                }
                
                // Prepare the data to update
                var updatedData: [String: Any] = [
                    "description": description,
                    "requirements": requirements,
                    "deadline": Timestamp(date: deadline),
                    "jobPostDate": Date()
                ]
                
                // Add the image URL if it exists
                if let imageUrl = imageUrl {
                    updatedData["imageUrl"] = imageUrl
                }
                
                // Update Firestore document with the data
                document.reference.updateData(updatedData) { error in
                    if let error = error {
                        print("Error updating job post: \(error)")
                        self?.showAlert(message: "Failed to update the job post. Please try again.")
                    } else {
                        print("Job post updated successfully!")
                        self?.showAlert(message: "Job post updated successfully!", completion: {
                            // Reset all data
                            self?.resetFields()
//                            self?.navigateToHomeScreen()
                        })
                    }
                }
            }
    }
    
    //self?.navigateToHomeScreen()
    private func resetFields() {
        txtRequirments.text = ""
        txtDescriptioin.text = ""
        selectedImage = nil
        imageURL = nil
        datePickerDeadline.date = Date()
    }

    
    // Helper function to show alerts with optional completion handler
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func navigateToHomeScreen() {
        // Step 1: Instantiate the Home storyboard
        let homeStoryboard = UIStoryboard(name: "JobBrowsingAndJobSearch_FatimaKhamis", bundle: nil)

        // Step 2: Instantiate the HomeViewController from the Home storyboard
        if let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "homePageVC") as? HomeJobPostViewController {
            // Step 3: Push the HomeViewController onto the navigation stack
            self.navigationController?.pushViewController(homeVC, animated: true)
        }

    }

    //when upload button is clicked
    
    @IBAction func btnUploadClicked(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        
    }
    
    //an indicator of image selection completion
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Store the selected image
            selectedImage = image

            // Update label to notify the user that the image was selected
            lblStatusImage.text = "Image successfully selected"
            lblStatusImage.textColor = .systemGreen  // Optional: Color change for visibility

            // Start uploading the image to Cloudinary
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                Task {
                    do {
                        let imageUrl = try await uploadImageToCloudinary(imageData: imageData)
                        print("Image uploaded successfully: \(imageUrl)")
                    } catch {
                        print("Failed to upload image: \(error)")
                        lblStatusImage.text = "Image upload failed"
                        lblStatusImage.textColor = .systemRed
                    }
                }
            }
        } else {
            lblStatusImage.text = "Failed to select image"
            lblStatusImage.textColor = .systemRed
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    //image picker cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func uploadImageToCloudinary(imageData: Data) async throws -> String {
        let cloudinaryURL = "https://api.cloudinary.com/v1_1/dvxwcsscw/image/upload"
        let uploadPreset = "JobifyImages"
        
        let parameters: [String: String] = [
            "upload_preset": uploadPreset
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "jobPost.jpg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: cloudinaryURL)
            .responseDecodable(of: CloudinaryResponse.self) { response in
                switch response.result {
                case .success(let cloudinaryResponse):
                    continuation.resume(returning: cloudinaryResponse.secure_url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }

}
