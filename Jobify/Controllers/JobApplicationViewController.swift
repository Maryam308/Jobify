//
//  JobApplicationViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit


    class JobApplicationViewController: UIViewController {
        @IBOutlet var masterView: UIView!
        
        @IBOutlet weak var chooseCvButton: UIButton!
        @IBOutlet weak var chooseCoverLetterButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //call the choose cv button tapped method when the choose cv button is clicked
            chooseCvButton.addTarget(self, action: #selector(chooseCvButtonTapped), for: .touchUpInside)
            //call the choose cover letter button tapped method when the choose cover letter button is clicked
            chooseCoverLetterButton.addTarget(self, action: #selector(chooseCoverLetterButtonTapped), for: .touchUpInside)
            
        }
        
        @objc private func chooseCvButtonTapped() {
            configureSheet(title: "Choose CV Document",
                           options: [
                            ("Choose from Files", "doc.text.fill", #selector(chooseFilesTapped)),
                            ("Choose from Jobify", "doc.text.fill", #selector(chooseJobifyTapped))
                           ])
        }
        
        
        @objc private func chooseCoverLetterButtonTapped() {
            configureSheet(
                title: "Choose Cover Letter",
                options: [
                    ("Choose from Files", "doc.text.fill", #selector(chooseFilesTapped)),
                ]
            )
        }
        
        private func configureSheet(title: String, options: [(String, String, Selector)]) {
            let popupVC = UIViewController()
            popupVC.view.backgroundColor = UIColor(hex: "#1D2D44")
            popupVC.view.layer.cornerRadius = 15
            
            // Title Label
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            titleLabel.textAlignment = .center
            popupVC.view.addSubview(titleLabel)
            
            // Create buttons dynamically from options
            var previousButton: UIButton? = nil
            
            
            for (index, option) in options.enumerated() {
                let button = createOptionButton(
                    title: option.0,
                    iconName: option.1,
                    action: option.2,
                    target: self
                )
                popupVC.view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: popupVC.view.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: popupVC.view.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 70)
                ])
                
                if let previousButton = previousButton {
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 15).isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
                }
                
                previousButton = button
            }
            
            // Layout Title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: popupVC.view.topAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: popupVC.view.centerXAnchor)
            ])
            
            // Configure as a sheet
            let navVC = UINavigationController(rootViewController: popupVC)
            if let sheet = navVC.sheetPresentationController {
                let baseHeight: CGFloat = 150 // Add space for title and margins
                let buttonHeight: CGFloat = 70
                let totalHeight = baseHeight + (buttonHeight * CGFloat(options.count))
                
                sheet.detents = [
                    .custom(resolver: { _ in totalHeight }), // Fixed height based on the content
                    .large()
                ]
                sheet.prefersGrabberVisible = true
            }
            present(navVC, animated: true);
        }
        
        
        
        private func createOptionButton(
            title: String,
            iconName: String,
            action: Selector,
            target: Any
        ) -> UIButton {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(hex: "#23395B") // Button color
            button.layer.cornerRadius = 10
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            // Add icon to button
            let icon = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
            button.setImage(icon, for: .normal)
            button.tintColor = .white
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            
            // Attach action
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
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
