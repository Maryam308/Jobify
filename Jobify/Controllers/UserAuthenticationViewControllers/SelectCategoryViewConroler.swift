//
//  SelectCategoryViewConroller.swift
//  Jobify
//
//  Created by Zainab Alawi on 23/12/2024.
//

import UIKit
import Firebase


class SelectCategoryViewConroller: UITableViewController {
    
    
    let db = Firestore.firestore()
    let currentUserId = UserSession.shared.loggedInUser?.userID
    private var selectedCategories: [String] = []
    var docRef: DocumentReference!
    
    @IBOutlet weak var btnInformationTechnology: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnHealthcare: UIButton!
    @IBOutlet weak var btnEducation: UIButton!
    @IBOutlet weak var btnEngineering: UIButton!
    @IBOutlet weak var btnMarketing: UIButton!
    @IBOutlet weak var btnArchitectre: UIButton!
    @IBOutlet weak var btnFinance: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func btnInformationTechnologyTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Information Technology", isSelected: sender.isSelected)
        
    }
    
    @IBAction func btnBusinessTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Business", isSelected: sender.isSelected)
    }
    
    @IBAction func btnHealthcareTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Healthcare", isSelected: sender.isSelected)
    }
    
    @IBAction func btnEducationTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Education", isSelected: sender.isSelected)
    }
    
    @IBAction func btnEngineeringTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Engineering", isSelected: sender.isSelected)
    }
    
    @IBAction func btnMarketingTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Marketing", isSelected: sender.isSelected)
    }
    
    @IBAction func btnArchitectureTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Architecture", isSelected: sender.isSelected)
    }
    
    @IBAction func btnFinanceTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Finance", isSelected: sender.isSelected)
    }
    
    @IBAction func btnOthersTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // Toggle selection state
        updateButtonAppearance(sender) // Update appearance
        handleCategorySelection(for: "Others", isSelected: sender.isSelected)
    }
    
    
    private func updateButtonAppearance(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor(hex: "#1D2D44")
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(.black, for: .normal) // Use your app's default style
        }
    }
    
    private func handleCategorySelection(for category: String, isSelected: Bool) {
        if isSelected {
            // Add to selected categories
            selectedCategories.append(category)
        } else {
            // Remove from selected categories
            if let index = selectedCategories.firstIndex(of: category) {
                selectedCategories.remove(at: index)
            }
        }
        
    }
    
    func fetchUserReference(by userId: Int, completion: @escaping (DocumentReference?) -> Void) {
        db.collection("users")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error)")
                    completion(nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No user document found for userId: \(userId)")
                    completion(nil)
                    return
                }
                
                // Return the reference to the found user document
                completion(document.reference)
            }
    }
    
    
    @IBAction func btnFinishSignup(_ sender: Any) {
        
        guard let userRef = docRef else {
               print("DocumentReference not passed correctly!")
               return
           }

           let selectedJobCategoriesData: [String: Any] = [
               "selectedJobCategories": selectedCategories,
               "userRef": userRef
           ]

           db.collection("selectedJobCategories").addDocument(data: selectedJobCategoriesData) { error in
               if let error = error {
                   print("Failed to save selected job categories: \(error.localizedDescription)")
               } else {
                   print("Selected job categories successfully saved!")
                   // Perform any further navigation or actions
                   if let logIn = self.storyboard?.instantiateViewController(withIdentifier: "loginScreenViewControler") {
                       if let navigationController = self.navigationController {
                           navigationController.pushViewController(logIn, animated: true)
                       } else {
                           print("NavigationController is nil. Unable to navigate to selectCategory.")
                       }
                   }
               }
           }
    }
    
    
    
    
    
}
