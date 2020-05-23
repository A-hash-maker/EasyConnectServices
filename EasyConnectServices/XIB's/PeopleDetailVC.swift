//
//  PeopleDetailVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 5/4/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class PeopleDetailVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var peopleImg: UIImageView!
    @IBOutlet weak var peopleNameLbl: UILabel!
    @IBOutlet weak var peopleDescriptionLbl: UILabel!
    @IBOutlet weak var peopleAddress: UILabel!
    @IBOutlet weak var peoplePhonNoLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var peopleRating: UILabel!
    
    @IBOutlet weak var msgTxt: UITextView!
    
    var people: People!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView(people: people)
        mapView.delegate = self
                
                //locationManager.delegate = self
                
                //checkLocationServices()
                
                
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPeople))
        //        tap.numberOfTapsRequired = 1
        //        bgView.addGestureRecognizer(tap)
                
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(presentPeoplePhotoVC))
        photoTap.numberOfTapsRequired = 1
        peopleImg.addGestureRecognizer(photoTap)

    }
    
    @objc func presentPeoplePhotoVC() {
               
        let vc = PeoplePhotoVC()
        vc.imgString = people.imageUrl
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func configureView(people: People) {
        peopleNameLbl.text = people.peopleName
        peopleDescriptionLbl.text = people.peopleDescription
        peopleAddress.text = "Address:-\(people.address)"
        peoplePhonNoLbl.text = "\(people.phoneNumber)"
        backBtn.titleLabel?.text = "<\(people.category)"
        peopleRating.text = "Rating:- \(people.rating)"
        if let url = URL(string: people.imageUrl) {
                peopleImg.kf.setImage(with: url)
            }
            
        guard let latitude = CLLocationDegrees(exactly: people.coordinates.latitude) else { return }
        guard let longitude = CLLocationDegrees(exactly: people.coordinates.longitude) else { return }
            
        let cordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            //mapview.show
    //
    //        if let location = locationManager.location?.coordinate {
    //            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
    //            mapview.setRegion(region, animated: true)
    //        }
            
        let annotations = MKPointAnnotation()
            annotations.coordinate = cordinates
        annotations.title = people.peopleName
            
        mapView.addAnnotation(annotations)
            
            
        let region = MKCoordinateRegion.init(center: cordinates, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
            
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func phoneBtnTapped(_ sender: UIButton) {
            
//        guard let phoneNumber = sender.titleLabel?.text else { simpleAlert(title: "Error", msg: "Invalid Phone Number")
//            return
//        }
        
//        guard let phoneNumber = people.phoneNumber else {
//            simpleAlert(title: "Error", msg: "Invalid phone Number")
//            return
//        }
        
        
        let url: NSURL = NSURL(string: "TEL://\(people.phoneNumber)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
//        if phoneNumber.count == 10 {
////            let url: NSURL = NSURL(string: "tel://\(phoneNumber)")!
////            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
////        }else {
////            simpleAlert(title: "Error", msg: "Wrong Phone Number")
////            return
////        }
            
    }
    
    
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        
        if MFMessageComposeViewController.canSendText() {
            
            let controller = MFMessageComposeViewController()
            controller.body = self.msgTxt.text
            controller.recipients = [self.peoplePhonNoLbl.text!]
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }else {
            print("Cannot send text")
        }
    }
    
        

        
    //    func centerViewOnUserLocation() {
    //        if let location = locationManager.location?.coordinate {
    //            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
    //            mapview.setRegion(region, animated: true)
    //        }
    //    }
}


extension PeopleDetailVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    
    
}



//extension PeopleDetailVC: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        mapview.setRegion(region, animated: true)
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAuthorization()
//    }
//
//}
