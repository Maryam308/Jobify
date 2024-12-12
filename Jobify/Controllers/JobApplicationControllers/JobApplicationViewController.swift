//
//  JobApplicationViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore






    class JobApplicationViewController: UIViewController {
        @IBOutlet var tableView: UITableView!
     /*
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cvs.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCVCell", for: indexPath) as! ChooseCVCell
            let cv = cv[indexPath.row]
            cell.cvTitleLabel.text = cv.title
            cell.cvDateLabel.text = cv.date
            return cell
        }
        
        
        
        let db = Firestore.firestore()
        
        struct cv {
            let title: String
            let date: String
            
        }
        var cvs: [cv] = []
        
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //creates action on the choose cv button
            //chooseCvButton.addTarget(self, action: #selector(chooseCvButtonTapped), for: .touchUpInside)
            
            fetchData()
            
            let nib = UINib(nibName: "ChooseCVCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "ChooseCVCell")
            tableView.delegate = self
            tableView.dataSource = self
            
        }
        
        @IBOutlet var tableView: UITableView!
       
        func fetchData() {
            db.collection("Ziv")
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
                        if let title = data["cvtitle"] as? String {
                            let date = data["cvdate"] as? String ?? "Unknown"
                            
                            let cv = cv(
                                title: title,
                                date: date
                            )
                            cvs.append(cv)
                        }
                    }
                    tableView.reloadData()
                }
        
        
        //
        
        */
        
        
        
        
        
        /* private func configureSheet()) {
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
    
     
    
    
