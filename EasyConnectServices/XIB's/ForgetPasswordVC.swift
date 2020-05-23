//
//  ForgetPasswordVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/17/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Firebase

class ForgetPasswordVC: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        
        guard let email = emailTxt.text, email.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please enter your eamil.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
                Auth.auth().handleFirAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
