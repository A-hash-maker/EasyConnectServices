//
//  LoginVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/1/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTxt.text , email.isNotEmpty, let password = passwordTxt.text , password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields.")
            return
        }
         
        spinner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          
            self!.spinner.stopAnimating() // Stable here
            if let error = error {
                print(error.localizedDescription)
                Auth.auth().handleFirAuthError(error: error, vc: self!)
                return
            }
            self!.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func forgetPassTapped(_ sender: UIButton) {
        let vc = ForgetPasswordVC()
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    
    
}
