//
//  LearningResourcesViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 23/12/2024.
//

import UIKit
import FirebaseFirestore

class LearningResourcesViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var skill: Skill? // Property to hold the passed skill
    var learningResources: [LearningResource] = [] // Array to hold all learning resources fetched
    var onlineCourses: [LearningResource] = [] // Separate array for online courses
    var articles: [LearningResource] = [] // Separate array for articles
    var certifications: [LearningResource] = [] // Separate array for certifications
    var selectedResource: LearningResource? // Property to hold the selected resource for details
    
    //outlets for title, description, and collection views
    @IBOutlet weak var lblSkillTitle: UILabel!
    @IBOutlet weak var lblSkillDescription: UITextView!
    @IBOutlet weak var onlineCoursesCollectionView: UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    @IBOutlet weak var certificationCollectionView: UICollectionView!
    
    @IBOutlet weak var lblCourses: UILabel!
    @IBOutlet weak var lblArticles: UILabel!
    @IBOutlet weak var lblCertification: UILabel!
    
    @IBOutlet weak var onlineCoursesHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var articlesHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var certificationHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSkillTitle.text = skill?.title
        lblSkillDescription.text = skill?.description

        setupCollectionView(onlineCoursesCollectionView)
        setupCollectionView(articlesCollectionView)
        setupCollectionView(certificationCollectionView)

        fetchLearningResources()
        adjustFontSizeForDevice()
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
        if collectionView == onlineCoursesCollectionView {
            return onlineCourses.count
        } else if collectionView == articlesCollectionView {
            return articles.count
        } else if collectionView == certificationCollectionView {
            return certifications.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let resource = resourceForCollectionView(collectionView, at: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as? LearningResourcesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(learningResource: resource)
        return cell
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
     
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resource: LearningResource
        if collectionView == onlineCoursesCollectionView {
            resource = onlineCourses[indexPath.item]
        } else if collectionView == articlesCollectionView {
            resource = articles[indexPath.item]
        } else {
            resource = certifications[indexPath.item]
        }

        // Create an alert to confirm action
        Task {
            do {
                let isSaved = try await resourceManager.isResourceSaved(learningResource: resource)
                let actionTitle = isSaved ? "Unsave" : "Save"
                let alertController = UIAlertController(title: "Choose an action", message: "What would you like to do with \(resource.title ?? "this resource")?", preferredStyle: .alert)

                // Save/Unsave action
                let saveAction = UIAlertAction(title: actionTitle, style: .default) { _ in
                    Task {
                        do {
                            // Handle favorite action
                            try await self.handleFavoriteAction(resource, isCurrentlySaved: isSaved)

                            // Show success alert
                            let successMessage = isSaved ? "Resource unsaved successfully!" : "Resource saved successfully!"
                            let successAlert = UIAlertController(title: "Success", message: successMessage, preferredStyle: .alert)
                            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(successAlert, animated: true, completion: nil)

                        } catch {
                            print("Failed to save/unsave resource: \(error.localizedDescription)")
                        }
                    }
                }
                alertController.addAction(saveAction)

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

            } catch {
                print("Error checking saved state: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleFavoriteAction(_ selectedResource: LearningResource, isCurrentlySaved: Bool) async throws {
        if isCurrentlySaved {
            // Unsaving the resource
            try await resourceManager.removeLearningResource(learningResource: selectedResource)
            print("Resource unsaved successfully")
        } else {
            // Saving the resource
            try await resourceManager.saveLearningResource(learningResource: selectedResource)
            print("Resource saved successfully")
        }
    }
    

        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalSpacing = padding * 2
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    private func fetchLearningResources() {
        guard let skillRef = skill?.documentReference else {
            print("Skill reference is missing.")
            return
        }

        db.collection("LearningResources")
            .whereField("skill", isEqualTo: skillRef)
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

            

                DispatchQueue.main.async {
                    self.onlineCoursesCollectionView.reloadData()
                    self.articlesCollectionView.reloadData()
                    self.certificationCollectionView.reloadData()
                }
            }
    }
    
    func adjustFontSizeForDevice(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            onlineCoursesHeightConstraint.constant = 250
            articlesHeightConstraint.constant = 250
            certificationHeightConstraint.constant = 250
            lblSkillTitle.font = lblSkillTitle.font?.withSize(28)
            lblSkillDescription.font = lblSkillDescription.font?.withSize(24)
            lblCourses.font = lblCourses.font?.withSize(24)
            lblArticles.font = lblArticles.font?.withSize(24)
            lblCertification.font = lblCertification.font?.withSize(24)
        }
    }

}
