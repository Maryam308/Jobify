//
//  SortViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class SortViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    protocol SortViewControllerDelegate: AnyObject {
        func didSelectSortOrder(_ sortOrder: String)
    }
    
  
    
    // Array of options to display in the table view
    private let options = ["Newest to Oldest", "Oldest to Newest"]
    private var selectedOptionIndex: Int?
   

    @IBOutlet weak var sortTableView: UITableView!
    
    @IBAction func applySort(_ sender: Any) {
        // Check if an option is selected
            guard let selectedIndex = selectedOptionIndex else {
                // Optionally show an alert if no option is selected
                let alert = UIAlertController(title: "Error", message: "Please select a sort option.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            
            // Notify the delegate of the selected sort order
            delegate?.didSelectSortOrder(options[selectedIndex])
            
            // Dismiss the SortViewController
            self.navigationController?.popViewController(animated: true)
        }
    
    
    let RadioTableViewCellId = "RadioTableViewCell"
    weak var delegate: SortViewControllerDelegate?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Ensure the tab bar is visible when returning to this controller
           self.tabBarController?.tabBar.isHidden = true
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Ensure the tab bar is visible when leaving this controller
           self.tabBarController?.tabBar.isHidden = false
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
        
        // Set the closure to handle option selection
        cell.onOptionSelected = { [weak self] selectedIndex in
            self?.selectedOptionIndex = selectedIndex
            tableView.reloadData() // Reloading the table to refresh selected states
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Update the selected option index
        selectedOptionIndex = indexPath.row // Set the index of the selected option
        tableView.reloadData() // Reload data to refresh cell states

        // Notify delegate of the selected sort order
        delegate?.didSelectSortOrder(options[selectedOptionIndex!])
    }
  
}
