//
//  PeopleVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/19/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class PeopleVC: UIViewController {
    
    //MARK:-
    
    @IBOutlet weak var tableView: UITableView!
    
    var peoples = [People]()
    var category: Category!
    var listener: ListenerRegistration!
    var db: Firestore!
    
    var locationManager: CLLocationManager!
    
    //let locationManager = CLLocationManager()
    
    
    //MARK:- viewLifecycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        setupTableView()
//        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCollection()
        //setPeoples()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Identifiers.PeopleCell, bundle: nil), forCellReuseIdentifier: Identifiers.PeopleCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
    }
}


//MARK:- UITableViewDataSource and UITableViewDelegate

extension PeopleVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.PeopleCell, for: indexPath) as? PeopleCell {
            cell.configureCell(people: peoples[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PeopleDetailVC()
        let selectedPeople = peoples[indexPath.row]
        vc.people = selectedPeople
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return tableView.estimatedRowHeight
//    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        print(preferredContentSize.height)
//        print(tableView.contentSize.height)
//        print(tableView.contentSize)
//
//        return 300
//    }
}


//MARK:- getPeopleMethods

extension PeopleVC {
    
    func fetchCollection() {
        let collectionRef = db.collection("peoples").whereField("category", isEqualTo: category.id)
        listener = collectionRef.addSnapshotListener { (snap, error) in
    
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.peoples.removeAll()
            guard let documents = snap?.documents else { return }
            for document in documents {
                let data = document.data()
                let newPeople = People(data: data)
       
                
                // For creating only people around 5 KM of user location only
//                guard let coordinates = self.locationManager.location?.coordinate else { return }
//
//                let theirDistance = self.distance(lat1: coordinates.latitude, lon1: coordinates.longitude, lat2: newPeople.coordinates.latitude, lon2: newPeople.coordinates.longitude)
//
//                if(theirDistance <= 5000) {
//                    self.peoples.append(newPeople)
//                }
                
                self.peoples.append(newPeople)
            }
            self.tableView.reloadData()
        }
    }
}


extension PeopleVC {
    
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }

    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }

    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        dist = dist * 1.609344 * 1000
        return dist
    }
}

extension PeopleVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //checkLocationAuthorization()
    }
}



// For Reference Point of View only
    
//    func setPeoples() {
//
//        //let data = db.collection("peoples").
//
//        listener = db.collection("peoples").whereField("category", isEqualTo: category.id).addSnapshotListener({ (snap, error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            snap?.documentChanges.forEach({ (change) in
//                let data = change.document.data()
//                let people = People(data: data)
//
//                switch change.type {
//                case .added:
//                    self.onPeopleAdded(change: change, people: people)
//                case .modified:
//                    self.onPeopleModified(change: change, people: people)
//                case .removed:
//                    self.onPeopleRemoved(change: change)
//                }
//            })
//        })
//    }
//
//    func onPeopleAdded(change: DocumentChange, people: People) {
//        let newIndex = Int(change.newIndex)
//        peoples.insert(people, at: newIndex)
//        tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .fade)
//    }
//
//    func onPeopleModified(change: DocumentChange, people: People) {
//
//        if change.oldIndex == change.newIndex {
//            let oldIndex = Int(change.oldIndex)
//            peoples[oldIndex] = people
//            tableView.reloadRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
//        }else {
//            let newIndex = Int(change.newIndex)
//            let oldIndex = Int(change.oldIndex)
//
//            peoples.remove(at: oldIndex)
//            peoples.insert(people, at: newIndex)
//            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
//        }
//    }
//
//    func onPeopleRemoved(change: DocumentChange) {
//        let oldIndex = Int(change.oldIndex)
//        peoples.remove(at: oldIndex)
//        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
//
//    }
//}


             //for getting collection document once
//            collectionRef.getDocuments { (snap, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//
//                guard let documents = snap?.documents else { return }
//
//                for document in documents {
//                    let data = document.data()
//                    //let newCategory = Category(data: data)
//                    let newPeople = People(data: data)
//                    self.peoples.append(newPeople)
//                    //self.categories.append(newCategory)
//                }
//                self.tableView.reloadData()
//            }
