import UIKit
import FirebaseFirestore

class AllCareerPathsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var careerPathCollectionView: UICollectionView!
    
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    
    @IBOutlet weak var learningResourcesCollectionView: UICollectionView!
    
    @IBOutlet weak var lblAllLearningResources: UITextView!
    
    var skill: Skill? // Property to hold the passed skill
    let db = Firestore.firestore()
    var careerPaths: [CareerPath1] = []
    var skills: [Skill] = []
    var learningResources: [LearningResource] = []
    var popupVC: PopupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a layout and configure for 2 columns
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4 // Spacing between items in the same row
        layout.minimumLineSpacing = 8 // Spacing between rows
        
        // Check the storyboard ID and configure the appropriate collection view
        if self.restorationIdentifier == "allcareerpath" {
            careerPathCollectionView.collectionViewLayout = layout
            careerPathCollectionView.delegate = self
            careerPathCollectionView.dataSource = self
            
            let careerPathNib = UINib(nibName: "CareerPathCollectionViewCell", bundle: nil)
            careerPathCollectionView.register(careerPathNib, forCellWithReuseIdentifier: "CareerPathCollectionViewCell")
       
            fetchCareerPaths()
            
            
        } else if self.restorationIdentifier == "skills" {
            skillsCollectionView.collectionViewLayout = layout
            skillsCollectionView.delegate = self
            skillsCollectionView.dataSource = self
            
            let skillsNib = UINib(nibName: "CareerPathCollectionViewCell", bundle: nil)
            skillsCollectionView.register(skillsNib, forCellWithReuseIdentifier: "CareerPathCollectionViewCell")
            fetchSkills()
        } else if self.restorationIdentifier == "viewAllResources"{
            learningResourcesCollectionView.collectionViewLayout = layout
            learningResourcesCollectionView.delegate = self
            learningResourcesCollectionView.dataSource = self
            
            let allResourcesNib = UINib(nibName: "LearningResourcesCollectionViewCell", bundle: nil)
            learningResourcesCollectionView.register(allResourcesNib, forCellWithReuseIdentifier: "LearningCollectionViewCell")
            if let skillTitle = skill?.title {
                lblAllLearningResources.text = "All Learning Resources for \(skillTitle)"
            } else {
                lblAllLearningResources.text = "All Learning Resources"
            }
            fetchLearningResources()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == careerPathCollectionView {
            return careerPaths.count
        } else if collectionView == skillsCollectionView {
            return skills.count
        } else if collectionView == learningResourcesCollectionView {
            return learningResources.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == careerPathCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareerPathCollectionViewCell", for: indexPath) as! CareerPathCollectionViewCell
            cell.setUp(careerPath: careerPaths[indexPath.item].title)
            return cell
        } else if collectionView == learningResourcesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LearningCollectionViewCell", for: indexPath) as! LearningResourcesCollectionViewCell
            cell.setup(learningResource: learningResources[indexPath.item])
            return cell
            
        } else if collectionView == skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareerPathCollectionViewCell", for: indexPath) as! CareerPathCollectionViewCell
            cell.setUp(careerPath: skills[indexPath.item].title)
            return cell
        }

        // Return a default cell if neither collection view matches (should not happen)
        return UICollectionViewCell()
    }
    
    // Configure size for each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 4 // Spacing between cells and edges
        let totalSpacing = padding * 3 // Spacing for two columns (left, right, and inter-column)

        // Determine which collection view is being laid out
        var width: CGFloat
        if collectionView == careerPathCollectionView {
            // Calculate width for careerPathCollectionView
            width = (careerPathCollectionView.frame.width - totalSpacing) / 2
        } else if collectionView == skillsCollectionView {
            // Calculate width for skillsCollectionView
            width = (skillsCollectionView.frame.width - totalSpacing) / 2
        } else if collectionView == learningResourcesCollectionView {
            // Calculate width
            width = (learningResourcesCollectionView.frame.width - totalSpacing) / 2
        }else {
            // Default case (should not happen)
            width = 0
        }

        let height = width * 0.9

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == careerPathCollectionView {
            let selectedCareerPath = careerPaths[indexPath.item]
            showPopup(with: selectedCareerPath)
        } else if collectionView == skillsCollectionView {
            let selectedSkill = skills[indexPath.item]
            navigateToSkillResources(with: selectedSkill)
        } else if collectionView == learningResourcesCollectionView {
            
        }
    }

    private func navigateToSkillResources(with skill: Skill) {
        // Instantiate the SkillResourcesViewController using its storyboard ID
        let storyboard = UIStoryboard(name: "CareerResourcesAndSkillDevelopment", bundle: nil)
        if let skillResourcesVC = storyboard.instantiateViewController(withIdentifier: "skillResources") as? LearningResourcesViewController {
            skillResourcesVC.skill = skill
            navigationController?.pushViewController(skillResourcesVC, animated: true)
        } else {
            print("Error: Could not instantiate SkillResourcesViewController")
        }
    }

    private func showPopup(with careerPath: CareerPath1) {
        // Check if popupVC already exists, if not, create a new one
        if popupVC == nil {
            popupVC = PopupViewController()
        }
        
        popupVC?.createInstanceOfPopUp(senderView: view, theViewController: self, sizeOfPopUpViewContainer: 400)
        popupVC?.careerPath = careerPath // Pass the selected career path
        popupVC?.openPopUpView()
    }
    
    
    
    @IBAction func viewAllResources(_ sender: Any) {
        
        
    }
 
    
    
    private func fetchCareerPaths() {
        db.collection("careerPaths")
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
                    print("Document data: \(data)") // Debugging output

                    guard let title = data["title"] as? String, !title.isEmpty,
                          let demandString = data["demand"] as? String, !demandString.isEmpty,
                          let roadmap = data["roadmap"] as? String, !roadmap.isEmpty else {
                        print("Error parsing document: \(data)")
                        continue
                    }

                    let careerPath = CareerPath1(careerName: title, description: "", roadmap: roadmap, demand: demandString)
                    self.careerPaths.append(careerPath)
                }

                print("Career paths fetched: \(self.careerPaths)") // Debugging output
                
                // Reload the collection view on the main thread
                DispatchQueue.main.async {
                    self.careerPathCollectionView.reloadData()
                }
            }
    }
    
    private func fetchSkills() {
        db.collection("skills")
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

                self.skills.removeAll()

                for document in documents {
                    let data = document.data()
                    print("Document data: \(data)") // Debugging output

                    guard let title = data["title"] as? String, !title.isEmpty,
                          let description = data["description"] as? String, !description.isEmpty else {
                        print("Error parsing document: \(data)")
                        continue
                    }

                    let documentReference = document.reference // Get the document reference
                    let skill = Skill(title: title, description: description, documentReference: documentReference) // Initialize with reference
                    self.skills.append(skill)
                }

                print("Skills fetched: \(self.skills)")
                
                // Reload the collection view on the main thread
                DispatchQueue.main.async {
                    self.skillsCollectionView.reloadData()
                }
            }
    }
    
    //fetch learning resources
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
                       let learningResource = LearningResource(type: type, summary: summary, link: link, title: title, skillRef: skillToDevelop)
                       self.learningResources.append(learningResource)
                   }

                   print("Learning Resources fetched: \(self.learningResources)") // Debugging output

                   // Reload the collection view on the main thread
                   DispatchQueue.main.async {
                       self.learningResourcesCollectionView.reloadData()

                   }
               }
       }
    
    
    
    
    
}
