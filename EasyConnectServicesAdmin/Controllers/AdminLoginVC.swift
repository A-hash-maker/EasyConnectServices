//
//  AdminLoginVC.swift
//  EasyConnectServicesAdmin
//
//  Created by vipin kumar on 5/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import FirebaseAuth

//let gmailLoginNotificationKey = "gmailLoginNotificationKey"

class AdminLoginVC: LoginVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func createNewUserBtnTapped(_ sender: UIButton) {
        
        let registerVC = (storyboard?.instantiateViewController(withIdentifier: "AdminRegisterVC")) as! AdminRegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
    
    
    override func loginTapped(_ sender: UIButton) {
        
        guard let email = emailTxt.text , email.isNotEmpty, let password = passwordTxt.text , password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields.")
            return
        }
         
        spinner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          
            self?.spinner.stopAnimating() // Stable here
            if let error = error {
                print(error.localizedDescription)
                Auth.auth().handleFirAuthError(error: error, vc: self!)
                return
            }
            
            guard let userEmail = authResult?.user.email else { return }
            EmailData.email = userEmail
            
            self!.spinner.stopAnimating()
            self!.navigationController?.popViewController(animated: true)
        }
    }
    
}


// For further reference

//            guard let userEmail = authResult?.user.email else { return }
//
//            let name = Notification.Name(rawValue: gmailLoginNotificationKey)
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["gmail": userEmail])
