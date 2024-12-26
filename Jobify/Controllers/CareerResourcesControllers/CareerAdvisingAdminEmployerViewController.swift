//
//  CareerAdvisingAdminEmployerViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 24/12/2024.
//

import UIKit
import FirebaseFirestore

class CareerAdvisingAdminEmployerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //outlets
    @IBOutlet weak var careerPathsCollectionView: UICollectionView!
    @IBOutlet weak var onlineCoursesCollectionView: UICollectionView!
   
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    
   @IBOutlet weak var certificationCollectionView: UICollectionView!
    
    @IBOutlet weak var onlineCoursesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var articlesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var certificationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageDescription: UITextView!
    @IBOutlet weak var lblLearningResources: UILabel!
    @IBOutlet weak var lblCareerPaths: UILabel!
    
    
    //variables
    var careerPaths: [CareerPath1] = []
    var learningResources: [LearningResource] = [] // Array to hold all learning resources fetched
    var onlineCourses: [LearningResource] = [] // Separate array for online courses
    var articles: [LearningResource] = [] // Separate array for articles
    var certifications: [LearningResource] = [] // Separate array for certifications
    var selectedResource: LearningResource? // Property to hold the selected resource for details
    let careerPathCollectionViewCellId = "CareerPathCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            careerPathsCollectionView.collectionViewLayout = layout
            
            careerPathsCollectionView.delegate = self
            careerPathsCollectionView.dataSource = self
            
            let careerPathNib = UINib(nibName: "CareerPathCollectionViewCell", bundle: nil)
            careerPathsCollectionView.register(careerPathNib, forCellWithReuseIdentifier: careerPathCollectionViewCellId)
            // Fetch career paths
            fetchCareerPaths()
            adjustFontSizeForDevice()
        } else if self.restorationIdentifier == "allResourcesEmployerAdmin" {
            setupCollectionView(onlineCoursesCollectionView)
            setupCollectionView(articlesCollectionView)
            setupCollectionView(certificationCollectionView)
            fetchLearningResources()
            adjustFontSizeForDevice()
        }
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "LearningResourcesCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "LearningCollectionViewCell")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
            return careerPaths.count
        } else if self.restorationIdentifier == "allResourcesEmployerAdmin" {
            if collectionView == onlineCoursesCollectionView {
                return onlineCourses.count
            } else if collectionView == articlesCollectionView {
                return articles.count
            } else if collectionView == certificationCollectionView {
                return certifications.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: careerPathCollectionViewCellId, for: indexPath) as! CareerPathCollectionViewCell
            cell.setUp(careerPath: careerPaths[indexPath.item].title)
            return cell
        } else if self.restorationIdentifier == "allResourcesEmployerAdmin" {
            guard let resource = resourceForCollectionView(collectionView, at: indexPath),
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as? LearningResourcesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setup(learningResource: resource)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func resourceForCollectionView(_ collectionView: UICollectionView, at indexPath: IndexPath) -> LearningResource? {
        if collectionView == onlineCoursesCollectionView {
            return onlineCourses[indexPath.item]
        } else if collectionView == articlesCollectionView {
            return articles[indexPath.item]
        } else if collectionView == certificationCollectionView {
            return certifications[indexPath.item]
        }
        return nil
    }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
            let padding: CGFloat = 10
            let totalSpacing = padding * 2
            let width = (collectionView.bounds.width - totalSpacing) / 2
            let height: CGFloat = 140
            return CGSize(width: width, height: height)
        } else if self.restorationIdentifier == "allResourcesEmployerAdmin" {
            let padding: CGFloat = 10
            let totalSpacing = padding * 2
            let width = (collectionView.bounds.width - totalSpacing) / 2
            let height = collectionView.bounds.height
            return CGSize(width: width, height: height)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
            let selectedCareerPath = careerPaths[indexPath.item]
            showPopup(with: selectedCareerPath)
        } else if self.restorationIdentifier == "allResourcesEmployerAdmin" {
            let resource: LearningResource
            if collectionView == onlineCoursesCollectionView {
                resource = onlineCourses[indexPath.item]
            } else if collectionView == articlesCollectionView {
                resource = articles[indexPath.item]
            } else {
                resource = certifications[indexPath.item]
            }
            // Create an alert to confirm action
            let alertController = UIAlertController(title: "Choose an action", message: "Click view to view  \(resource.title ?? "this resource")?", preferredStyle: .alert)
            
            // View action
            let viewAction = UIAlertAction(title: "View", style: .default) { _ in
                let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
                if let detailsVC = storyboard.instantiateViewController(withIdentifier: "resourceDetails") as? ResourceDetailsViewController {
                    detailsVC.selectedResource = resource
                    self.navigationController?.pushViewController(detailsVC, animated: true)
                } else {
                    print("Error: Could not instantiate ResourceDetailsViewController with ID resourceDetails")
                }
            }
            
            // Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(viewAction)
            alertController.addAction(cancelAction)
            
            // Add the alert to the view
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func showPopup(with careerPath: CareerPath1) {
        let popupVC = PopupViewController()
        popupVC.createInstanceOfPopUp(senderView: view, theViewController: self, sizeOfPopUpViewContainer: 400)
        popupVC.careerPath = careerPath // Pass the selected career path
        popupVC.openPopUpView()
    }
    
    private func fetchCareerPaths() {
        db.collection("careerPaths")
            .limit(to: 8)
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
                
                self.careerPaths.removeAll()
                
                for document in documents {
                    let data = document.data()
                    guard let title = data["title"] as? String, !title.isEmpty,
                          let demandString = data["demand"] as? String, !demandString.isEmpty,
                          let roadmap = data["roadmap"] as? String, !roadmap.isEmpty else {
//                        print("Error parsing document: \(data)")
                        continue
                    }
                    
                    let careerPath = CareerPath1(careerName: title, description: "", roadmap: roadmap, demand: demandString)
                    self.careerPaths.append(careerPath)
                }
                self.careerPathsCollectionView.reloadData()
            }
    }
    
    private func fetchLearningResources() {

        db.collection("LearningResources")
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

                // Clear previous data
                self.learningResources.removeAll()
                self.onlineCourses.removeAll()
                self.articles.removeAll()
                self.certifications.removeAll()
               
                var fetchedResources: [LearningResource] = []

                for document in documents {
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let id = data["learningResourceId"] as? Int,
                          let summary = data["description"] as? String,
                          let link = data["link"] as? String,
                          let type = data["category"] as? String,
                          let skillToDevelop = data["skill"] as? DocumentReference else {
                        print("Error parsing document: \(data)")
                        continue
                    }
                    let learningResource = LearningResource(id: id,type: type, summary: summary, link: link, title: title, skillRef: skillToDevelop)
                    fetchedResources.append(learningResource)

                    switch type.lowercased() {
                    case "online course":
                        self.onlineCourses.append(learningResource)
                    case "article":
                        self.articles.append(learningResource)
                    case "certification":
                        self.certifications.append(learningResource)
                    default:
                        print("Unknown resource type: \(type)")
                    }
                }
                
                print("Learning Resources: \(fetchedResources)")

                DispatchQueue.main.async {
                    self.onlineCoursesCollectionView.reloadData()
                    self.articlesCollectionView.reloadData()
                    self.certificationCollectionView.reloadData()
                }
            }
    }
    
    
    
    func adjustFontSizeForDevice(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            if self.restorationIdentifier == "allResourcesEmployerAdmin" {
                onlineCoursesHeightConstraint.constant = 250
                articlesHeightConstraint.constant = 250
                certificationHeightConstraint.constant = 250
            }else if self.restorationIdentifier == "EmployerCareerResourcesViewController" {
                pageTitle.font = pageTitle.font?.withSize(30)
                pageDescription.font = pageDescription.font?.withSize(24)
                lblLearningResources.font = lblLearningResources.font?.withSize(28)
                lblCareerPaths.font = lblCareerPaths.font?.withSize(28)
            }
        }
    }
}
