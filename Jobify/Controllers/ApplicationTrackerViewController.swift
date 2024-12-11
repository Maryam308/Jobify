//
//  ApplicationTrackerViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore


let db = Firestore.firestore()
/*
func getCurrentUserRole(completion: @escaping (String?) -> Void) {
    db.collection("usertype")
        .getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
        print("No user is signed in.")
        completion(nil)
        return
    }


    // Fetch the user's role from Firestore
    db.collection("users").document(userId).getDocument { (document, error) in
        if let error = error {
            print("Error fetching user role: \(error)")
            completion(nil)
        } else if let document = document, document.exists {
            let role = document.data()?["role"] as? String
            completion(role) // Pass the role back to the caller
        } else {
            print("User document does not exist.")
            completion(nil)
        }
    }
}

*/
class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
            let career = careers[indexPath.row]
            cell.companyLabel.text = career.company
            cell.typeLabel.text = career.type
            cell.positionLabel.text = career.position
            cell.locationLabel.text = career.location
            cell.statusButton.setTitle(career.status, for: .normal)
            return cell
    }
    
    
    let db = Firestore.firestore()
    
    struct Career {
        let company: String
        let type: String
        let position: String
        let location: String
        let status: String
    }
    var careers: [Career] = []
    
    private let tabs = ["All", "Not Reviewed", "Reviewed", "Approved", "Rejected"]
    private var selectedTab: String = "All" {
        didSet {
            updateTabSelection()
        }
    }
    
    // UI Components
    private lazy var tabStackView: UIStackView = createTabStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTabSelection() // Set initial selection
        fetchData()
        
        let nib = UINib(nibName: "TrackerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
        tableView.delegate = self
        tableView.dataSource = self
       /*
        getCurrentUserRole { role in
                guard let role = role else {
                    print("Could not determine user role.")
                    return
                }

                switch role {
                case "admin":
                    self.showAdminFeatures()
                case "viewer":
                    self.showViewerFeatures()
                case "editor":
                    self.showEditorFeatures()
                default:
                    self.showDefaultFeatures()
                }
        */
        
            }
        
        
        

    
    func showAdminFeatures() {
        // Enable admin-specific UI elements
        print("Admin features enabled.")
    }

    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Create and add the scroll view
        let scrollView = createScrollView()
        view.addSubview(scrollView)
        
        // Add the tabStackView to the scrollView
        scrollView.addSubview(tabStackView)
        
        setupConstraints(scrollView: scrollView)
    }
    
    private func setupConstraints(scrollView: UIScrollView) {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 40),
            
            // TabStackView constraints (inside the scrollView)
            tabStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tabStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tabStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tabStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tabStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectedTab = sender.title(for: .normal) ?? "All"
    }
    
    private func updateTabSelection() {
        for case let button as UIButton in tabStackView.arrangedSubviews {
            let isSelected = button.title(for: .normal) == selectedTab
            button.setTitleColor(isSelected ? .white : .gray, for: .normal)
            button.backgroundColor = isSelected ? .systemBlue : .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: isSelected ? .bold : .regular)
        }
    }
    
    // Factory Functions for Reusability
    private func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false // Hide the scroll indicator
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    private func createTabStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: tabs.map { createTabButton(for: $0) })
        stackView.axis = .horizontal
        stackView.distribution = .fill // Allows buttons to use intrinsic content size
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createTabButton(for title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        
        // Set a fixed width for buttons if needed
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 120) // Customize width as needed
        ])
        
        return button
    }
    
    
    
    
    
    
    @IBOutlet var tableView: UITableView!
    //let myApplications = ["first", "second", "third", "fourth", "fifth"]
    func fetchData() {
        db.collection("jobApplication")
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
                    if let company = data["company"] as? String {
                        let type = data["type"] as? String ?? "Unknown"
                        let position = data["position"] as? String ?? "Unknown"
                        let location = data["location"] as? String ?? "Unknown"
                        let status = data["status"] as? String ?? "Not Reviewed"
                        
                        let career = Career(
                                    company: company,
                                    type: type,
                                    position: position,
                                    location: location,
                                    status: status
                                )
                                careers.append(career)
                            }
                }
                tableView.reloadData()
            }
    
      /*  @objc private func changeStatusButtonTapped() {
            configureSheet(
                title: "Choose Cover Letter",
                options: [
                    ("Choose from Files", "doc.text.fill", #selector(chooseFilesTapped))
                ]
            )
        }
        
        private func configureSheet(title: String, options: [(String, String, Selector)]) {
            //creates a popup view controller and set its background color and make the edges rounded
            let popupVC = UIViewController()
            popupVC.view.backgroundColor = UIColor(hex: "#1D2D44")
            popupVC.view.layer.cornerRadius = 15
            
            // Title Label creation and configuration
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            titleLabel.textAlignment = .center
            popupVC.view.addSubview(titleLabel)
            
            // Create buttons dynamically from options
            var previousButton: UIButton? = nil
            
            //loop through the options parameter and call the create option button with the data
            for (index, option) in options.enumerated() {
                let button = createOptionButton(
                    title: option.0,
                    iconName: option.1,
                    action: option.2,
                    target: self
                )
                popupVC.view.addSubview(button)
                //set the auto resize of the button off
                button.translatesAutoresizingMaskIntoConstraints = false
                //set button contraints
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: popupVC.view.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: popupVC.view.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 70)
                ])
                
                //if there is a previous button set it 15 points below but if this is the first button set it 30 points below
                if let previousButton = previousButton {
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 15).isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
                }
                
                previousButton = button //set the just created button as the previous button
            }
            
            // Layout Title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: popupVC.view.topAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: popupVC.view.centerXAnchor)
            ])
            
            // Configure the popup view controller as a sheet
            let navVC = UINavigationController(rootViewController: popupVC)
            if let sheet = navVC.sheetPresentationController {
                let baseHeight: CGFloat = 150 // Add space for title and margins
                let buttonHeight: CGFloat = 70
                let totalHeight = baseHeight + (buttonHeight * CGFloat(options.count))
                
                sheet.detents = [ //specifies the available size of the sheet
                    .custom(resolver: { _ in totalHeight }), // The height of the sheet based on the content
                ]
                sheet.prefersGrabberVisible = true //the small handle at the top of the sheet
            }
            present(navVC, animated: true);
        }
        
        
        //creating the buttons based on the specifications
        private func createOptionButton(
            title: String,
            iconName: String,
            action: Selector,
            target: Any
        ) -> UIButton {
            let button = UIButton(type: .system) //default button style
            button.backgroundColor = UIColor(hex: "#23395B")
            button.layer.cornerRadius = 10
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            // adding icon to button
            let icon = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate) // retrieves the icon from the system and render it tinted
            button.setImage(icon, for: .normal)
            button.tintColor = .white
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

            // attach action to the button
            button.addTarget(target, action: action, for: .touchUpInside)
            
            return button
        }
        */
        
        
        
        
        
        /*
         @objc private func chooseCvButtonTapped() {
             configureSheet(title: "Choose CV Document",
                            options: [
                             ("Choose from Jobify", "doc.text.fill", #selector(chooseJobifyTapped))
                            ])
         }
         
         
         private func configureSheet(title: String, options: [(String, String, Selector)]) {
             //creates a popup view controller and set its background color and make the edges rounded
             let popupVC = UIViewController()
             popupVC.view.backgroundColor = UIColor(hex: "#1D2D44")
             popupVC.view.layer.cornerRadius = 15
             
             // Title Label creation and configuration
             let titleLabel = UILabel()
             titleLabel.text = title
             titleLabel.textColor = .white
             titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
             titleLabel.textAlignment = .center
             popupVC.view.addSubview(titleLabel)
             
             // Create buttons dynamically from options
             var previousButton: UIButton? = nil
             
             //loop through the options parameter and call the create option button with the data
             for (index, option) in options.enumerated() {
                 let button = createOptionButton(
                     title: option.0,
                     iconName: option.1,
                     action: option.2,
                     target: self
                 )
                 popupVC.view.addSubview(button)
                 //set the auto resize of the button off
                 button.translatesAutoresizingMaskIntoConstraints = false
                 //set button contraints
                 NSLayoutConstraint.activate([
                     button.leadingAnchor.constraint(equalTo: popupVC.view.leadingAnchor, constant: 20),
                     button.trailingAnchor.constraint(equalTo: popupVC.view.trailingAnchor, constant: -20),
                     button.heightAnchor.constraint(equalToConstant: 70)
                 ])
                 
                 //if there is a previous button set it 15 points below but if this is the first button set it 30 points below
                 if let previousButton = previousButton {
                     button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 15).isActive = true
                 } else {
                     button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
                 }
                 
                 previousButton = button //set the just created button as the previous button
             }
             
             // Layout Title
             titleLabel.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 titleLabel.topAnchor.constraint(equalTo: popupVC.view.topAnchor, constant: 20),
                 titleLabel.centerXAnchor.constraint(equalTo: popupVC.view.centerXAnchor)
             ])
             
             // Configure the popup view controller as a sheet
             let navVC = UINavigationController(rootViewController: popupVC)
             if let sheet = navVC.sheetPresentationController {
                 let baseHeight: CGFloat = 150 // Add space for title and margins
                 let buttonHeight: CGFloat = 70
                 let totalHeight = baseHeight + (buttonHeight * CGFloat(options.count))
                 
                 sheet.detents = [ //specifies the available size of the sheet
                     .custom(resolver: { _ in totalHeight }), // The height of the sheet based on the content
                 ]
                 sheet.prefersGrabberVisible = true //the small handle at the top of the sheet
             }
             present(navVC, animated: true);
         }
         
         
         //creating the buttons based on the specifications
         private func createOptionButton(
             title: String,
             iconName: String,
             action: Selector,
             target: Any
         ) -> UIButton {
             let button = UIButton(type: .system) //default button style
             button.backgroundColor = UIColor(hex: "#23395B")
             button.layer.cornerRadius = 10
             button.setTitle(title, for: .normal)
             button.setTitleColor(.white, for: .normal)
             button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
             
             // adding icon to button
             let icon = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate) // retrieves the icon from the system and render it tinted
             button.setImage(icon, for: .normal)
             button.tintColor = .white
             button.contentHorizontalAlignment = .left
             button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
             button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

             // attach action to the button
             button.addTarget(target, action: action, for: .touchUpInside)
             
             return button
         }
         
         
         
         // Actions for the popup buttons
         @objc private func chooseFilesTapped() {
             print("Choose from Files tapped")
         }
         
         @objc private func chooseJobifyTapped() {
             print("Choose from Jobify tapped")
         }
         */
    }
}
