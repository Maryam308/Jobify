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
 
    // Closure for passing selected CV back
        var onCVSelected: ((CV) -> Void)?

    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var ChooseCVTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register CVTableViewCell with myCVsTableView
        
        let nib = UINib(nibName: "ChooseCVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChooseCVCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCVs()

       
    }

    func fetchCVs() {
        // Create a test CV asynchronously
        Task {
            do {
                let fetchedCVs = try await CVManager.getAllCVs()
                DispatchQueue.main.async {
                    self.cvs = fetchedCVs
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching CVs: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cvs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCVCell", for: indexPath) as! ChooseCVCell
            let cv = cvs[indexPath.row]
            cell.cvTitleLabel.text = cv.cvTitle
            cell.cvDateLabel.text = DateFormatter.localizedString(from: cv.creationDate, dateStyle: .medium, timeStyle: .none)

            // Configure "View Details" button
            cell.viewCVButton.tag = indexPath.row
            cell.viewCVButton.addTarget(self, action: #selector(viewCVTapped(_:)), for: .touchUpInside)

            return cell
        }
    
    @objc func viewCVTapped(_ sender: UIButton) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedCV = cvs[indexPath.row]

            // Call the closure with the selected CV
            onCVSelected?(selectedCV)

        self.navigationController?.dismiss(animated: true, completion: nil)
        }

}
