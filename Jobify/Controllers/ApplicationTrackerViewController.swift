//
//  ApplicationTrackerViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit

class ApplicationTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
            
            let nib = UINib(nibName: "TrackerCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "TrackerCell")
            tableView.delegate = self
            tableView.dataSource = self
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
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
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        cell.companyLabel.text = "Bahrain Polytechnic"
        cell.typeLabel.text = "Full Time"
        cell.positionLabel.text = "Senior Software Engineer"
        cell.locationLabel.text = "Manama"
        cell.statusButton.setTitle("Not Reviewed", for: .normal)
        
        
        return cell
    }
    

}
