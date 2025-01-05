//
//  JobApplicationViewController.swift
//  Jobify
//
//  Created by Zahraa ElKhayer on 04/12/2024.
//

import UIKit
import FirebaseFirestore






class JobApplicationViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    
    
    let db = Firestore.firestore()
    
    
    var cvs: [CV] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "ChooseCVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChooseCVCell")
        tableView.delegate = self
        //tableView.dataSource = self
        
    }
    
   
    }
    
    
    
    

