//
//  CVBuilderEditorViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 10/12/2024.
//

import UIKit
import FirebaseFirestore
import Firebase

class CVBuilderEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore() //creating a refrenece for the firestore database
    
    //creating outlet as required\
    
    
    @IBOutlet weak var myCVsTableView: UITableView!
    
 
//    @IBOutlet weak var imageView: UIImageView!
    
//    @IBOutlet weak var btnAddPhoto: UIButton!
    
    
    //array of user's CVs
    var cvs: [CVTest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCVsTableView.dataSource = self
        myCVsTableView.delegate = self
        
        // Register CVTableViewCell with myCVsTableView
        myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")
        
        fetchCVs()
    }
    
    // Fetch user CVs logic
    func fetchCVs() {
        // Create a test CV asynchronously
        Task {
        do {
            let fetchedCVs = try await CVManager.getAllCVs()
                DispatchQueue.main.async {
        self.cvs = fetchedCVs
        self.myCVsTableView.reloadData()
    }
    } catch {
        // Handle errors gracefully
        print("Error fetching CVs: \(error.localizedDescription)")
    }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.count //the number of the table rows = number of user's CVs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as! CVTableViewCell

        // Access the CVTest object
        let cv = cvs[indexPath.row]
        cell.setup(CV: cv)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myCVsTableView.frame.width / 2
    }
    
    //action that will happen if the user clicks on "add a photo" button in the personal details screen
//    @IBAction func btnAddPhotoPressed(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)
//    }
    
    // This function is called when the user finishes choosing image
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        guard let image = info[.editedImage] as? UIImage else {
//            return
//        }
//        imageView.image = image
//        dismiss(animated: true)
//    }
    
    //display the photo as a circle
//    private func setupImageUploadCircle() {
//        imageView.layer.cornerRadius = imageView.frame.size.width / 2
//        imageView.clipsToBounds = true
//    }
//    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
