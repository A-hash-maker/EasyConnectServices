//
//  RegisterVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/1/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        guard let passTxt = passwordTxt.text else { return }
        
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        }else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = false
                confirmPassCheckImg.isHidden = false
                confirmPassTxt.text = ""
            }
        }
        
        
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
        }else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
        }
        
    }
    
    
    @IBAction func RegisterTapped(_ sender: UIButton) {
        
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
            
            self.spinner.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
