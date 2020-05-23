//
//  AdminRegisterVC.swift
//  EasyConnectServicesAdmin
//
//  Created by vipin kumar on 5/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import FirebaseAuth

//let gmailRegisterNotificationKey = "gmailRegisterNotificationKey"

class AdminRegisterVC: RegisterVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    override func RegisterTapped(_ sender: UIButton) {
        
        guard let email = emailTxt.text, email.isNotEmpty,
        let userName =  userNameTxt.text, userName.isNotEmpty,
        let password = passwordTxt.text, password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields.")
            return
        }
        guard let confirmPass = confirmPassTxt.text, confirmPass == password else {
        simpleAlert(title: "Error", msg: "Password do not match.")
        return
        }
        spinner.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
        if let error = error {
            print(error.localizedDescription)
            Auth.auth().handleFirAuthError(error: error, vc: self)
            self.spinner.stopAnimating()
            return
            }

            
        guard let userEmail = authResult?.user.email else { return }
            EmailData.email = userEmail
            self.spinner.stopAnimating()
            self.backTwo()
         }
    }
}

// For further reference
        //guard let userEmail = authResult?.user.email else { return }
                
//        let name = Notification.Name(rawValue: gmailRegisterNotificationKey)
//            NotificationCenter.default.post(name: name, object: nil, userInfo: ["gmail": userEmail])
//
//            guard let userEmail = authResult?.user.email else { return }
                
//            let name = Notification.Name(rawValue: gmailLoginNotificationKey)
//                NotificationCenter.default.post(name: name, object: nil, userInfo: ["gmail": userEmail])
