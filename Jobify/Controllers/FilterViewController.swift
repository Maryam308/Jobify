//
//  FilterViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 04/12/2024.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    var filterSections: [FilterSection] = [
        FilterSection(title: "Level", isExpanded: false, items: ["Senior", "Junior", "Intern"]),
        FilterSection(title: "Employment Type", isExpanded: false, items: ["Full-Time", "Part-Time", "Intern", "Contract"]),
        FilterSection(title: "Category", isExpanded: false, items: ["IT", "Healthcare", "Education", "Engineering"]),
        FilterSection(title: "Location", isExpanded: false, items: ["Remote", "On-Site", "Hybrid"]),
        FilterSection(title: "Company", isExpanded: false, items: ["Apple", "Google", "Amazon", "Meta"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterItemTableViewCell.self, forCellReuseIdentifier: "FilterItemTableViewCell") // Correct cell registration
        tableView.register(FilterHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterHeaderView.identifier)
        tableView.tableFooterView = UIView() // Removes extra separators
        
    }
    
    @objc func applyFilter() {
        // Handle filter application logic here
        print("Filters applied!")
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSections[section].isExpanded ? filterSections[section].items.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterItemTableViewCell", for: indexPath) as? FilterItemTableViewCell else {
            return UITableViewCell()
        }
        
        let section = filterSections[indexPath.section]
        let item = section.items[indexPath.row]
        
        // Configure cell with checkbox
        cell.configure(with: item, isSelected: section.selectedItems.contains(item))
        cell.selectionStyle = .none
        cell.checkboxTapped = { [weak self] in
            // Handle checkbox selection
            if section.selectedItems.contains(item) {
                self?.filterSections[indexPath.section].selectedItems.remove(item)
            } else {
                self?.filterSections[indexPath.section].selectedItems.insert(item)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Standard height for rows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterHeaderView.identifier) as! FilterHeaderView
        let sectionData = filterSections[section]
        
        header.configure(with: sectionData.title, section: section, isExpanded: sectionData.isExpanded)
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return filterSections[section].isExpanded ? 10 : 0.1 // Remove padding when collapsed
    }
}

extension FilterViewController: FilterHeaderViewDelegate {
    func toggleSection(header: FilterHeaderView, section: Int) {
        filterSections[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
