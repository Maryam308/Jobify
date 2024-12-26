//
//  Untitled.swift
//  Profile - Test
//
//  Created by Zainab Alawi on 11/12/2024.
//

//SettingsViewController
import UIKit

class settingsViewController: UIViewController {
    
    
}

class settingsSignInAndSecurityViewController: UIViewController{
    
}

class settingsAccountViewController:  UIViewController{
    
    @IBOutlet weak var deleteAccount: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteAccount.layer.cornerRadius = 15.0
        deleteAccount.clipsToBounds = true
    }
    
}


class settingsTermsAndConditionsViewController:   UIViewController{
    
    
    @IBOutlet weak var termsAndConditions: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsAndConditions.layer.cornerRadius = 15.0
        termsAndConditions.clipsToBounds = true
    }
    
}


class termsAndConditionsPrivacyPolicyViewController:   UIViewController{
    
}

class termsAndConditionsDataRetentionPolicyViewController:   UIViewController{
    
}

class settingsFAQs:   UIViewController{
    
}



