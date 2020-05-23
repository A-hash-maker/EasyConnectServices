//
//  HomeVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/10/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class HomeVC: UIViewController, CLLocationManagerDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK:- Variables
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db : Firestore!
    var listener: ListenerRegistration!
    
    let locationManager = CLLocationManager()
    
    //MARK:- ViewControllerLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentLoginVC()
        db = Firestore.firestore()
        setupCollectionView()
        setupNavigationBar()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCategoriesCollection()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    //MARK:- NavigationBarSetupMethod
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK:- SetupCollectionView
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.categoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.categoryCell)
    }
    
    //MARK:- LoginVCPresentMethod
    
    fileprivate func presentLoginVC() {
        let storyboard = UIStoryboard.init(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    //MARK:- LogoutBtnMethod
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                presentLoginVC()
            } catch {
                Auth.auth().handleFirAuthError(error: error, vc: self)
            }
        }
    }
}

// UICollectionViewDelegate and UICollectionViewDataSource

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.categoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth / 2) - 8
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toPeople, sender: self)
    }
    
    //MARK:- SegueMethods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toPeople {
            if let destination = segue.destination as? PeopleVC {
                destination.category = selectedCategory
                destination.locationManager = locationManager
            }
        }
    }
}


//MARK:- LocationManager

extension HomeVC {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
        
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alert
            break
        case .denied:
            // Show alert instructing them how to turn on permission
            break
        case .authorizedAlways:
            break
        }
    }
}



//MARK:- SetCategoriesMethods

extension HomeVC {
    
    func setCategoriesCollection() {
        listener = db.collection("categories").order(by: "timeStamp").addSnapshotListener({ (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemove(change: change)
                @unknown default:
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            })
        })
    }
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        
        if change.oldIndex == change.newIndex {
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }else {
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemove(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
}


// This is for the reference

//    func fetchDocument() {
//        spinner.startAnimating()
//        let docRef = db.collection("categories").document("fSf8KEDsQ83gUO5klbNz")
//
//        listener = docRef.addSnapshotListener { (snap, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let data = snap?.data() else { return }
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//
////        docRef.getDocument { (snap, error) in
////
////            if let error = error {
////                print(error.localizedDescription)
////                return
////            }
////
////            guard let data = snap?.data() else { return }
////            let newCategory = Category(data: data)
////            self.categories.append(newCategory)
////            self.collectionView.reloadData()
////            self.spinner.stopAnimating()
////        }
//    }
//
//    func fetchCollection() {
//        let collectionRef = db.collection("categories")
//
//        listener = collectionRef.addSnapshotListener { (snap, error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            self.categories.removeAll()
//            guard let documents = snap?.documents else { return }
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
//
//        // for getting collection document once
////        collectionRef.getDocuments { (snap, error) in
////            if let error = error {
////                print(error.localizedDescription)
////                return
////            }
////
////            guard let documents = snap?.documents else { return }
////
////            for document in documents {
////                let data = document.data()
////                let newCategory = Category(data: data)
////                self.categories.append(newCategory)
////            }
////            self.collectionView.reloadData()
////        }
//    }
