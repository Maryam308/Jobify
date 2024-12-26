//
//  PopupViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 22/12/2024.
//

import UIKit

class PopupViewController: UIViewController {

    // MARK: - Properties
    var theParentView: UIView!
    var sizeOfPopUpViewContainer: Int!
    var popUpViewIsOpen: Bool = false
    var backgroundColor: UIColor = UIColor(red: 29/255, green: 45/255, blue: 68/255, alpha: 1.0)

    var careerPath: CareerPath1? // Property to hold the selected career path

    // UI Elements
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0 // Wrap text to fit within the pop-up width
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0 // Allow multi-line text wrapping
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roadmapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18) // Bold header
        label.numberOfLines = 0 // Wrap long text
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let demandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18) // Bold header
        label.numberOfLines = 0 // Wrap long text
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        adjustFontSizeForDevice()
        setupCloseButton()
        setupScrollViewAndContent()
        
    }

    // MARK: - UI Setup
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(closePopUpDialog), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupScrollViewAndContent() {
        // Add ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10), // Reduced space between close button and title
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Add Labels
        [titleLabel, descriptionLabel, roadmapLabel, demandLabel].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Reduced space between title and close button
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            roadmapLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            roadmapLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            roadmapLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            demandLabel.topAnchor.constraint(equalTo: roadmapLabel.bottomAnchor, constant: 20),
            demandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            demandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            demandLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Popup Methods
    func createInstanceOfPopUp(senderView: UIView, theViewController: UIViewController, sizeOfPopUpViewContainer: Int, backgroundColor: UIColor = UIColor(red: 29/255, green: 45/255, blue: 68/255, alpha: 1.0)) {
        self.theParentView = senderView
        self.sizeOfPopUpViewContainer = sizeOfPopUpViewContainer
        self.backgroundColor = backgroundColor

        theViewController.addChild(self)
        self.view.frame = CGRect(x: 0, y: theParentView.frame.maxY, width: senderView.frame.width, height: CGFloat(sizeOfPopUpViewContainer))
        theParentView.addSubview(self.view)
    }

    func openPopUpView() {
        popUpViewIsOpen = true
        animatePopUpIn()
    }

    private func animatePopUpIn() {
        self.view.alpha = 0
        self.view.frame.origin.y = UIScreen.main.bounds.height // Initially off-screen at the bottom

        UIView.animate(
            withDuration: 0.4, // Slightly slower for a smoother experience
            delay: 0,
            options: [.curveEaseOut], // Use ease-out for a smooth end to the animation
            animations: {
                self.view.alpha = 1
                self.view.frame.origin.y = UIScreen.main.bounds.height - CGFloat(self.sizeOfPopUpViewContainer) // Slide up from the bottom
            }
        ) { _ in
            self.displayCareerPathData()
        }
    }

    func displayCareerPathData() {
        guard let careerPath = careerPath else { return }
        titleLabel.text = careerPath.title
        descriptionLabel.text = careerPath.description
        roadmapLabel.text = "Roadmap:\n\(careerPath.roadmap)"
        demandLabel.text = "Demand:\n\(careerPath.demand)"
    }

    @objc func closePopUpDialog() {
        UIView.animate(withDuration: 0.55, animations: {
            self.view.alpha = 0
            self.view.frame.origin.y = UIScreen.main.bounds.height // Slide down out of view
        }) { _ in
            self.view.removeFromSuperview()
            self.popUpViewIsOpen = false
            self.removeFromParent()
        }
    }
    
    func adjustFontSizeForDevice(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = titleLabel.font?.withSize(26)
            descriptionLabel.font = descriptionLabel.font?.withSize(24)
            roadmapLabel.font = roadmapLabel.font?.withSize(24)
            demandLabel.font = demandLabel.font?.withSize(24)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        }
    }
}
