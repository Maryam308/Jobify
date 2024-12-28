//
//  FilterViewController.swift
//  Jobify
//
//  Created by Fatima Ali on 04/12/2024.
//

import UIKit
import FirebaseFirestore

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(_ filters: [String: [String]])
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    var filterSections: [FilterSection] = []
    var firebaseManager = FirebaseManager()
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterSections()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Ensure the tab bar is visible when returning to this controller
           self.tabBarController?.tabBar.isHidden = true
        
       }

    
    private func setupFilterSections() {
        // Static sections
        let categories = CategoryJob.allCases.map { $0.rawValue }
        let employmentTypes = EmploymentType.allCases.map { $0.rawValue }
        let levels = JobLevel.allCases.map { $0.rawValue }
        
        filterSections.append(FilterSection(title: "Level", isExpanded: false, items: levels))
        filterSections.append(FilterSection(title: "Employment Type", isExpanded: false, items: employmentTypes))
        filterSections.append(FilterSection(title: "Category", isExpanded: false, items: categories))
        
        // Dynamic sections from Firebase
        fetchCompanyNames()
        fetchLocations()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterItemTableViewCell.self, forCellReuseIdentifier: "FilterItemTableViewCell")
        tableView.register(FilterHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterHeaderView.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func fetchCompanyNames() {
        firebaseManager.fetchCompanyNames(collection: "jobs", field: "companyRef") { [weak self] companyNames in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filterSections.append(FilterSection(title: "Company", isExpanded: false, items: companyNames))
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchLocations() {
        firebaseManager.fetchLocations(collection: "jobs", field: "jobLocation") { [weak self] locations in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filterSections.append(FilterSection(title: "Location", isExpanded: false, items: locations))
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func applyFilter(_ sender: Any) {
        var filters: [String: [String]] = [:]

        
        for section in filterSections {
            print("Selected items in section \(section.title): \(section.selectedItems)")

            filters[section.title] = Array(section.selectedItems)
        }
        
        
        delegate?.didApplyFilters(filters)
        dismiss(animated: true, completion: nil)
        //navigate back to the previous controller "Job Post Controller"
        self.navigationController?.popViewController(animated: true)
        
     
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

class FirebaseManager {
    
    // Fetch unique company names by using companyRef to get companyName
    func fetchCompanyNames(collection: String, field: String, completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(collection).getDocuments { snapshot, error in
            guard error == nil, let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                completion([])
                return
            }
            
            var companyNames: Set<String> = []
            let group = DispatchGroup() // To wait for all async calls
            
            // Loop through all documents and fetch company names via companyRef
            for document in documents {
                if let companyRef = document.data()[field] as? DocumentReference {
                    group.enter() // Enter the group for each async call
                    
                    // Fetch company document from the companyRef
                    companyRef.getDocument { companySnapshot, error in
                        if let error = error {
                            print("Error fetching company document: \(error)")
                        } else {
                            if let companyName = companySnapshot?.data()?["name"] as? String {
                                companyNames.insert(companyName) // Add unique company name
                            }
                        }
                        
                        group.leave() // Leave the group after async call completes
                    }
                }
            }
            
            // After all async calls are finished, return the company names
            group.notify(queue: .main) {
                completion(Array(companyNames)) // Convert Set to Array and return
            }
        }
    }
    
    // Fetch unique locations (cities)
    func fetchLocations(collection: String, field: String, completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection(collection).getDocuments { snapshot, error in
            guard error == nil, let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                completion([])
                return
            }
            
            // Create a set to store unique cities
            var citiesSet = Set<String>()
            
            // Loop through documents and extract city values
            for document in documents {
                if let city = document.data()[field] as? String {
                    citiesSet.insert(city) // Set automatically handles duplicates
                }
            }
            
            // Return the unique cities as an array
            completion(Array(citiesSet))
        }
    }
}
