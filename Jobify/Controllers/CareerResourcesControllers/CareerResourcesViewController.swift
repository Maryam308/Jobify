import UIKit
import FirebaseFirestore

class CareerResourcesViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupLabel: UITextView!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePopupView() // Hide popup initially
        fetchCareerPaths()
    }

    // Configure the popup to start hidden
    private func configurePopupView() {
        popupView.isHidden = true
        popupView.layer.cornerRadius = 12
        popupView.layer.masksToBounds = true
        
        // Dismiss popup when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
        
        // Dismiss popup when tapping inside
        let popupTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        popupView.addGestureRecognizer(popupTapGesture)
    }

    // Fetch career paths from Firestore
    private func fetchCareerPaths() {
        db.collection("careerPaths")
            .limit(to: 4) // Limit to 4 documents
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }

                // Loop through the documents and add buttons
                for document in documents {
                    let data = document.data()
                    if let title = data["title"] as? String {
                        self.addCareerButton(withTitle: title)
                    }
                }
            }
    }

    // Add a career button to the stack view
    private func addCareerButton(withTitle title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(careerButtonTapped(_:)), for: .touchUpInside)

        // Styling the button
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(button)
    }

    // Handle career button tap
    @objc private func careerButtonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        fetchCareerDetails(for: title) { [weak self] details in
            guard let self = self else { return }
            print("Details fetched: \(String(describing: details))") // Debugging line
            self.updatePopup(with: details ?? [:])
            self.showPopup()
        }
    }

    // Fetch career details from Firestore
    private func fetchCareerDetails(for title: String, completion: @escaping ([String: Any]?) -> Void) {
        db.collection("careerPaths")
            .whereField("title", isEqualTo: title)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching career details: \(error)")
                    completion(nil)
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No documents found for title: \(title)")
                    completion(nil)
                    return
                }

                let details = documents.first?.data()
                print("Fetched details: \(String(describing: details))") // Debugging line
                completion(details)
            }
    }

    // Update popup content with career details
    private func updatePopup(with details: [String: Any]) {
        var popupContent = ""
        
        // Ensure details are not empty
        if details.isEmpty {
            popupLabel.text = "No details available."
            return
        }

        // Add title first
        if let title = details["title"] as? String {
            popupContent += "Title: \(title)\n\n"
        }
        
        // Add description
        if let description = details["description"] as? String {
            popupContent += "Description: \(description)\n\n"
        }
        
        // Add demand
        if let demand = details["demand"] as? String {
            popupContent += "Demand: \(demand)\n\n"
        }
        
        // Add roadmap
        if let roadmap = details["roadmap"] as? String {
            popupContent += "Roadmap: \(roadmap)\n\n"
        }
        
        if let label = popupLabel {
            label.text = popupContent
        } else {
            print("popupLabel is nil!")
        }
    }

    // Show the popup
    private func showPopup() {
        popupView.alpha = 0
        popupView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1 // Fade in the popup
        }
    }

    // Hide the popup when the user taps outside
    @objc private func dismissPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.alpha = 0 // Fade out the popup
        }) { _ in
            self.popupView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
}
