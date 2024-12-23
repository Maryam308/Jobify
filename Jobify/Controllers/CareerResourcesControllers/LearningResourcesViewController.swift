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
    
    
    //outlets for title, description, and collection views
    @IBOutlet weak var lblSkillTitle: UILabel!
    @IBOutlet weak var lblSkillDescription: UITextView!
    @IBOutlet weak var onlineCoursesCollectionView: UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    @IBOutlet weak var certificationCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the title and description
        lblSkillTitle.text = skill?.title
        lblSkillDescription.text = skill?.description
        
        setupCollectionView(onlineCoursesCollectionView)
        setupCollectionView(articlesCollectionView)
        setupCollectionView(certificationCollectionView)
        
        fetchLearningResources()
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
        if collectionView == onlineCoursesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as! LearningResourcesCollectionViewCell
            let resource = onlineCourses[indexPath.item]
            cell.setup(learningResource: resource)
            return cell
        } else if collectionView == articlesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as! LearningResourcesCollectionViewCell
            let resource = articles[indexPath.item]
            cell.setup(learningResource: resource)
            return cell
        } else if collectionView == certificationCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as! LearningResourcesCollectionViewCell
            let resource = certifications[indexPath.item]
            cell.setup(learningResource: resource)
            return cell
        }
        
        // Fallback to return an empty UICollectionViewCell if none match
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalSpacing = padding * 2
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height: CGFloat = 140
        return CGSize(width: width, height: height)
    }
    

    private func fetchLearningResources() {
           guard let skillRef = skill?.documentReference else { //
               print("Skill reference is missing.")
               return
           }
            print(skillRef)
           db.collection("LearningResources")
               .whereField("skill", isEqualTo: skillRef) // Filter by the skill reference
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

                   for document in documents {
                       let data = document.data()
                       print("Document data: \(data)") // Debugging output

                       guard let title = data["title"] as? String,
                             let summary = data["description"] as? String,
                             let link = data["link"] as? String,
                             let type = data["category"] as? String,
                             let skillToDevelop = data["skill"] as? DocumentReference else {
                           print("Error parsing document: \(data)")
                           continue
                       }

                       // Create a LearningResource instance
                       let learningResource = LearningResource(type: type, summary: summary, link: link, title: title, skillToDevelop: skillToDevelop)

                       // Categorize resources based on type
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

                   print("Learning Resources fetched: \(self.learningResources)") // Debugging output

                   // Reload the collection views on the main thread
                   DispatchQueue.main.async {
                       self.onlineCoursesCollectionView.reloadData()
                       self.articlesCollectionView.reloadData()
                       self.certificationCollectionView.reloadData()
                   }
               }
       }
}
