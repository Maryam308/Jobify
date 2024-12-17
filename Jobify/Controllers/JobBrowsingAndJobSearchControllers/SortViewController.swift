//
//  SortViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class SortViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   // let sortArray: [String] = ["Newest to oldest", "Oldest to newest"]
    
    // Array of options to display in the table view
    private let options = ["Newest to Oldest", "Oldest to Newest"]
    private var selectedOptionIndex: Int?
   

    @IBOutlet weak var sortTableView: UITableView!
    
    let RadioTableViewCellId = "RadioTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //responsible for handling interactions and providing data for the table
        sortTableView.dataSource = self
        sortTableView.delegate = self
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: sortTableView.frame.size.width, height: 50))
        
        header.backgroundColor = UIColor(hex: "#D9D9D9")
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: sortTableView.frame.size.width, height: 50))
        
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Sort"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        header.addSubview(label)
        
        sortTableView.tableHeaderView = header
        
        let nib = UINib(nibName: RadioTableViewCellId, bundle: nil)
              sortTableView.register(nib, forCellReuseIdentifier: RadioTableViewCellId)

        sortTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // num of rows to show on table (table cell)
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCellId, for: indexPath) as! RadioTableViewCell
         
         // Set titles for options from the array
         cell.setOptionsTitleFrom(options)
         
         // Set the selected state for the cell
        cell.setOptionSelected((selectedOptionIndex == indexPath.row))
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Update the selected option index
            selectedOptionIndex = indexPath.row
            tableView.reloadData() // Reload data to refresh cell states
        }
    
  
}
