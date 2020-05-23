//
//  ViewController.swift
//  EasyConnectServicesAdmin
//
//  Created by vipin kumar on 2/27/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var createProfileBtn: UIButton!
    
    //@IBOutlet weak var changeBgView: UIView!
    
    @IBOutlet weak var manLogoImg: UIImageView!
    @IBOutlet weak var peopleProfileView: UIView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    // Logo View Detail labels
    @IBOutlet weak var peopleNameLbl: UILabel!
    @IBOutlet weak var peopleDesLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var peopleServicesLbl: UILabel!
    
    var userEmail: String = ""
    var db: Firestore!
    var peopleID: String = ""
    
    //let login = Notification.Name(rawValue: gmailLoginNotificationKey)
    //let register = Notification.Name(rawValue: gmailRegisterNotificationKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        print("ViewDidLoad is called")
        PresentEasyConnectServicesAdmin()
        
        mainView.isHidden = true
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(viewTapped))
        configureInitialState()
        
        self.navigationItem.hidesBackButton = true
    }
    
    fileprivate func PresentEasyConnectServicesAdmin() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: StoryboardId.AdminLoginVC)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("ViewWillAppear is called")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear is called")
        
        
        configureView(valid: false)
        
        if (Auth.auth().currentUser?.email) != nil {
            getPeoples()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear is called")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear is called")
    }

    @objc func viewTapped() {
        UIView.animate(withDuration: 0.4) {
            self.expandBtn.isHidden = false
            self.mainView.isHidden = true
            self.tapGesture.isEnabled = false
            
            //self.changeBgView.backgroundColor = .clear
            
            self.bgView.backgroundColor = .white
            self.peopleProfileView.backgroundColor = .white
        }
        print("From ViewTapped Function")
    }
    
    
    @IBAction func expandBtnTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4) {
            self.expandBtn.isHidden = true
            self.mainView.isHidden = false
            self.tapGesture.isEnabled = true
            
            
            //self.changeBgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            
            self.bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            self.peopleProfileView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
    }
    
    @IBAction func editProfileTapped(_ sender: UIButton) {
        
        let EditProfVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        EditProfVC.category = CurrentUserData.currentCategory
        EditProfVC.people = CurrentUserData.currentPeople
        EditProfVC.editBtn = true
        
        self.navigationController?.pushViewController(EditProfVC, animated: true)
    }
    
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch {
                Auth.auth().handleFirAuthError(error: error, vc: self)
            }
        }
    }
    
    
    @IBAction func trashBtnTapped(_ sender: UIButton) {
        
        print("tarshBtnTapped btn is Tapped")
        
        let alert = UIAlertController(title: "Alert", message: "Do you really want to delete your profile?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (ok) in
            
            self.db.collection("peoples").document(self.peopleID).delete { (error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    self.simpleAlert(title: "Error", msg: "Fails to delete data")
                }
            }
            
            self.configureView(valid: false)
            
            if (Auth.auth().currentUser?.email) != nil {
                self.getPeoples()
            }
            
            print("Hello from ok Action ")
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default) { (cancel) in
            print("Hi from cancel Action")
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func createYourProfileBtnTapped(_ sender: UIButton) {
        let EditProfVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(EditProfVC, animated: true)
    }
}

extension ViewController {
    
    func getPeoples() {
        
        db.collection("peoples").getDocuments { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snap?.documents else { return }
            for document in documents {
                let data = document.data()
                let email = data[PeopleDetail.peopleGmail] as? String ?? ""
                
                if email == EmailData.email {
                    
                    let imageUrl = data[PeopleDetail.imageUrl] as? String ?? ""
                    guard let url = URL(string: imageUrl) else { return }
                    
                    self.configureView(valid: true)
                    CurrentUserData.currentPeople = People(data: data)
                    
                    self.peopleID = data[PeopleDetail.id] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.peopleNameLbl.text = data[PeopleDetail.peopleName] as? String ?? ""
                        self.peopleDesLbl.text = data[PeopleDetail.peopleDescription] as? String ?? ""
                        self.addressLbl.text = data[PeopleDetail.address] as? String ?? ""
                        self.phoneNoLbl.text = data[PeopleDetail.phoneNumber] as? String ?? ""
                        self.peopleServicesLbl.text = data[PeopleDetail.services] as? String ?? ""
                        self.manLogoImg.kf.setImage(with: url)
                    }
                    let id = data[PeopleDetail.category] as? String ?? ""
                    self.getCategory(id: id)
                    break
                }
            }
        }
    }
    
    func getCategory(id: String) {
        
        print("value of id from getPeople is \(id)")
        
        self.db.collection("categories").getDocuments { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snap?.documents else { return }
            for doument in documents {
                let data = doument.data()
                let currentId = data["id"] as? String ?? ""
                if currentId == id {
                    
                    CurrentUserData.currentCategory = Category(data: data)
                    
                    print("")
                    print("")
                    print("")
                    print("Hello from \(CurrentUserData.currentCategory)")
                    
                    DispatchQueue.main.async {
                        self.categoryLbl.text = data["name"] as? String ?? ""
                    }
                    break
                }
            }
        }
    }
}


extension ViewController {
    
    fileprivate func configureInitialState() {
        self.editBtn.isEnabled = true
        self.deleteBtn.isEnabled = true
        
        self.createProfileBtn.isHidden = true
        self.createProfileBtn.isEnabled = false
        
        self.manLogoImg.isHidden = true
        self.peopleProfileView.isHidden = true
        
    }
    
    fileprivate func configureView(valid: Bool) {
        if valid {
            self.editBtn.isEnabled = true
            self.deleteBtn.isEnabled = true
            
            self.createProfileBtn.isHidden = true
            self.createProfileBtn.isEnabled = false
            
            self.manLogoImg.isHidden = false
            self.peopleProfileView.isHidden = false
        }else {
            
            self.editBtn.isEnabled = false
            self.deleteBtn.isEnabled = false
            
            self.manLogoImg.isHidden = true
            self.peopleProfileView.isHidden = true
            self.createProfileBtn.isHidden = false
            self.createProfileBtn.isEnabled = true
        }
    }
    
    
    
    
}


// For further reference

    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    func createObservers() {
//
//        NotificationCenter.default.addObserver(self, selector: #selector(updateEmailLoginTxt(notification:)), name: login, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(updateEmailLoginTxt(notification:)), name: register, object: nil)
//
//
//    }
    
//    @objc func updateEmailRegisterTxt(notification: NSNotification) {
//        if let notif = notification.userInfo {
//            userEmail = notif["gmail"] as! String
//            print("From register userEmail is \(userEmail)")
//        }
//
//        if (notification.userInfo != nil) {
//            print("has value")
//        }else {
//            print("has no value")
//        }
//
//    }
    
//    @objc func updateEmailLoginTxt(notification: NSNotification) {
//        if let notif = notification.userInfo {
//            userEmail = notif["gmail"] as! String
//            print("From loginuserEmail is \(userEmail)")
//        }
//    }
