//
//  AddNewCareerPath.swift
//  Jobify
//
//  Created by Maryam Ahmed on 15/12/2024.
//

import UIKit
import Firebase


class AddNewCareerPathViewController: UITableViewController { //should add title in the view and change career to description and change demand to a textfield
    
    //setup to use firestore database
    let db = Firestore.firestore()
    
    //outlets
    @IBOutlet weak var txtViewCareer: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDemand: UITextField!
    @IBOutlet weak var txtViewRoadMap: UITextView!
    
    
    
    //in the method load borders will be added to the textviews
    override func viewDidLoad() {
        //add borders to views
    }
    
    
    @IBAction func btnAdd_Click(_ sender: Any) {
        
            //fetch the values of the text views
        
        //validate that the textViews are not empty and safely unwrap optional values
            if let enteredTitle = txtTitle.text,
               let enteredCareer = txtViewCareer.text,
               let enteredDemand = txtDemand.text,
               let enteredRoadMap = txtViewRoadMap.text {
                
                // Create a dictionary for the career path to add to the firebase document
                let careerPathData = [
                    "title": enteredTitle,
                    "roadmap": enteredRoadMap,
                    "description": enteredCareer,
                    "demand": enteredDemand
                ]
                
                // Add values to database
                //in the collection 'careerPaths' using auto generated id
                //2- Add document to the collection and pass the data
                //3- Add error handling if there is a returned error from firebase and provide feedback
                db.collection("careerPaths").addDocument(data: careerPathData)
                { error in if let error = error { print("Error adding document: \(error)") } else { print("Document successfully added!") } }

                
                
            }
        
        
    }
    
    //when add button clicked : will take in the values added for a new career path
}
