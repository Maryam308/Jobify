//import UIKit
//import FirebaseFirestore
//
//class CareerResourcesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    // Property to hold the fetched career paths
//    var careerPaths: [CareerPath] = []
//
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == careerPathCollectionView {
//            return careerPaths.count
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: careerPathCollectionViewCellId, for: indexPath)
//
//        if let careerCell = cell as? CareerPathCollectionViewCell {
//            // Call the setup function with the CareerPath model
//            careerCell.setUp(careerPath: careerPaths[indexPath.item])
//        }
//        return cell
//    }
//    
//
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var popupView: UIView!
//    @IBOutlet weak var popupLabel: UITextView!
//    
//    let db = Firestore.firestore()
//
//    
//    @IBOutlet weak var careerPathCollectionView: UICollectionView!
//    let careerPathCollectionViewCellId = "CareerPathCollectionViewCell"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configurePopupView() // Hide popup initially
////        fetchCareerPaths()
//        
//        let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .horizontal
//            
//        careerPathCollectionView.collectionViewLayout = layout
//                //horizontal career path
//        careerPathCollectionView.delegate = self
//        careerPathCollectionView.dataSource = self
//
//        careerPathCollectionView.delegate = self
//        careerPathCollectionView.dataSource = self
//        
//        // register cell for career path
//           let careerPathNib = UINib(nibName: careerPathCollectionViewCellId, bundle: nil)
//        careerPathCollectionView.register(careerPathNib, forCellWithReuseIdentifier: careerPathCollectionViewCellId)
//        careerPathCollectionView.reloadData()
//    }
//    
//    // Adjust the size of collection view cells dynamically
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == careerPathCollectionView {
//            // Size for career path cells
//            let padding: CGFloat = 10
//                    let totalSpacing = padding * 2
//                    let width = (collectionView.bounds.width - totalSpacing) / 2
//            let height: CGFloat = 140
//            
//                    return CGSize(width: width, height: height)
//                    
//        }
//        
//        return CGSize(width: 0, height: 0)
//    }
//
//    // Configure the popup to start hidden
//    private func configurePopupView() {
//        popupView.isHidden = true
//        popupView.layer.cornerRadius = 12
//        popupView.layer.masksToBounds = true
//        
//        // Dismiss popup when tapping outside
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
//        view.addGestureRecognizer(tapGesture)
//        
//        // Dismiss popup when tapping inside
//        let popupTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
//        popupView.addGestureRecognizer(popupTapGesture)
//    }
//
//    private func fetchCareerPaths() {
//        db.collection("careerPaths")
//            .limit(to: 5) // Limit to 5 documents
//            .getDocuments { [weak self] (querySnapshot, error) in
//                guard let self = self else { return }
//
//                if let error = error {
//                    print("Error fetching documents: \(error)")
//                    return
//                }
//
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents found")
//                    return
//                }
//
//                // Clear previous data
//                self.careerPaths.removeAll()
//
//                // Loop through the documents and create CareerPath instances
//                for document in documents {
//                    let data = document.data()
//                    if let title = data["title"] as? String,
//                       let demandString = data["demand"] as? String, // Retrieve demand as a string
//                       let roadmap = data["roadmap"] as? String,
//                       let demand = Demand(rawValue: demandString.lowercased()) { // Convert string to Demand enum
//                        let careerPath = CareerPath(careerName: title, demand: demand, roadmap: roadmap)
//                        self.careerPaths.append(careerPath)
//                    } else {
//                        print("Error parsing document: \(document.data())")
//                    }
//                }
//                
//                // Reload collection view with new data
//                self.careerPathCollectionView.reloadData()
//            }
//    }
//
////    // Add a career button to the stack view
////    private func addCareerButton(withTitle title: String) {
////        let button = UIButton(type: .system)
////        button.setTitle(title, for: .normal)
////        button.addTarget(self, action: #selector(careerButtonTapped(_:)), for: .touchUpInside)
////
////        // Styling the button
////        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
////        button.setTitleColor(.systemBlue, for: .normal)
////        button.backgroundColor = UIColor.systemGray6
////        button.layer.cornerRadius = 8
////        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
////        button.translatesAutoresizingMaskIntoConstraints = false
////
////        stackView.addArrangedSubview(button)
////    }
//
//    // Handle career button tap
//    @objc private func careerButtonTapped(_ sender: UIButton) {
//        guard let title = sender.currentTitle else { return }
//        fetchCareerDetails(for: title) { [weak self] details in
//            guard let self = self else { return }
//            print("Details fetched: \(String(describing: details))") // Debugging line
//            self.updatePopup(with: details ?? [:])
//            self.showPopup()
//        }
//    }
//
//    // Fetch career details from Firestore
//    private func fetchCareerDetails(for title: String, completion: @escaping ([String: Any]?) -> Void) {
//        db.collection("careerPaths")
//            .whereField("title", isEqualTo: title)
//            .getDocuments { querySnapshot, error in
//                if let error = error {
//                    print("Error fetching career details: \(error)")
//                    completion(nil)
//                    return
//                }
//
//                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
//                    print("No documents found for title: \(title)")
//                    completion(nil)
//                    return
//                }
//
//                let details = documents.first?.data()
//                print("Fetched details: \(String(describing: details))") // Debugging line
//                completion(details)
//            }
//    }
//
//    // Update popup content with career details
//    private func updatePopup(with details: [String: Any]) {
//        var popupContent = ""
//        
//        // Ensure details are not empty
//        if details.isEmpty {
//            popupLabel.text = "No details available."
//            return
//        }
//
//        // Add title first
//        if let title = details["title"] as? String {
//            popupContent += "Title: \(title)\n\n"
//        }
//        
//        // Add description
//        if let description = details["description"] as? String {
//            popupContent += "Description: \(description)\n\n"
//        }
//        
//        // Add demand
//        if let demand = details["demand"] as? String {
//            popupContent += "Demand: \(demand)\n\n"
//        }
//        
//        // Add roadmap
//        if let roadmap = details["roadmap"] as? String {
//            popupContent += "Roadmap: \(roadmap)\n\n"
//        }
//        
//        if let label = popupLabel {
//            label.text = popupContent
//        } else {
//            print("popupLabel is nil!")
//        }
//    }
//
//    // Show the popup
//    private func showPopup() {
//        popupView.alpha = 0
//        popupView.isHidden = false
//        UIView.animate(withDuration: 0.3) {
//            self.popupView.alpha = 1 // Fade in the popup
//        }
//    }
//
//    // Hide the popup when the user taps outside
//    @objc private func dismissPopup() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.popupView.alpha = 0 // Fade out the popup
//        }) { _ in
//            self.popupView.isHidden = true
//        }
//    }
//    
//    override func viewDidLayoutSubviews() {
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//    }
//    
//    
//    
//}
