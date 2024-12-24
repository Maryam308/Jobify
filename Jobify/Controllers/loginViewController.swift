//
//  loginViewController.swift
//  Jobify
//
//  Created by Maryam Ahmed on 21/12/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    //as if the admin has logged in
    var currentUser: User = User(userID: 1, name: "John Doe", email: "adminMaster@jobify.com", role: UserType.admin, imageURL: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSession.shared.loggedInUser = currentUser

    }
    
    
    
    
    
}
