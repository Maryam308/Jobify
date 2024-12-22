//
//  MonitorCell.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 10/12/2024.
//

import UIKit



class MonitorCell: UITableViewCell {

    
    @IBOutlet weak var viewApplicationButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var seekerLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeStatusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ChangeStatusClicked(_ sender: UIButton) {
       
    }
    /*
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
    

