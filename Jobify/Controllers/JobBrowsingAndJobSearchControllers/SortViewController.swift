//
//  SortViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 12/12/2024.
//

import UIKit

class SortViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sortArray: [String] = ["Newest to oldest", "Oldest to newest"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // num of rows to show on table (table cell)
        return sortArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sortArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me ")
    }
    

    @IBOutlet weak var sortTableView: UITableView!
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
        
        

    }
    
   
    

  
}
