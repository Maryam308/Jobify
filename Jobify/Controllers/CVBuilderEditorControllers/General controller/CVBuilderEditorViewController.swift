//
//  CVBuilderEditorViewController.swift
//  Jobify
//
//  Created by Maryam Yousif on 17/12/2024.
//

import UIKit
import FirebaseFirestore
import Firebase

class CVBuilderEditorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore() //creating a refrenece for the firestore database
    //array of user's CVs
    var cvs: [CV] = []
    @IBOutlet weak var myCVsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch user CVs
        fetchCVs()
        
            myCVsTableView.dataSource = self
            myCVsTableView.delegate = self

            // Register CVTableViewCell with myCVsTableView
            myCVsTableView.register(UINib(nibName: "CVTableViewCell", bundle: .main), forCellReuseIdentifier: "CVTableViewCell")

    }

    // Fetch user CVs logic
    func fetchCVs() {
        // Create a test CV asynchronously
        Task {
        do {
            let fetchedCVs = try await CVManager.getAllCVs()
            DispatchQueue.main.async {
        self.cvs = fetchedCVs
        self.myCVsTableView.reloadData()
    }
    } catch {
        print("Error fetching CVs: \(error.localizedDescription)")
    }
    }
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myCVsTableView.dequeueReusableCell(withIdentifier: "CVTableViewCell", for: indexPath) as! CVTableViewCell
           let cv = cvs[indexPath.row]
           cell.setup(cv)
           return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myCVsTableView.frame.width / 2
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
