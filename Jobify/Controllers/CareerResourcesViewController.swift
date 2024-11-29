//
//  CareerResourcesViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 27/11/2024.
//

import UIKit
import FirebaseFirestore


class CareerResourcesViewController:
    UIViewController {

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func savedLearningResourcesTapped(_ sender: UIButton) {
        // Get a reference to Firestore

    }

    
    @IBAction func buttonTapped(_ sender: Any) {
        // Reference to your Firebase Firestore collection and document
        let docRef = db.collection("careerPaths").document("career1")

        // Fetch the document
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get the text from the document
                let text = document.get("careerTitle") as? String ?? "No text available"

                // Create a UIAlertController to display the text
                let alert = UIAlertController(title: "Popup Title", message: text, preferredStyle: .alert)

                // Add a button to dismiss the popup
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                // Present the alert
                self.present(alert, animated: true, completion: nil)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBOutlet weak var mentorContentView: UIView!
    @IBOutlet weak var mentorScrollView: UIScrollView!

    override func viewDidLayoutSubviews() {
        mentorScrollView.showsHorizontalScrollIndicator = false
        mentorScrollView.showsVerticalScrollIndicator = false
    }
}
