//
//  ChooseCVTableViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 16/12/2024.
//

import UIKit

class ChooseCVTableViewController: UITableViewController {

    //array of user's CVs
    var cvs: [CV] = []
    
    struct CV{
        var cvTitle: String
        var cvDate: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register CVTableViewCell with myCVsTableView
        let nib = UINib(nibName: "ChooseCVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChooseCVCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCVs()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cvs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func fetchCVs() {
        
        
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
                    if let cvTitle = data["cvTitle"] as? String {
                        let cvDate = data["cvDate"] as? String ?? "Unknown"
                        
                        
                        let cv = CV(
                            cvTitle: cvTitle,
                            cvDate: cvDate
                        )
                        cvs.append(cv)
                    }
                }
                tableView.reloadData()
            }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
