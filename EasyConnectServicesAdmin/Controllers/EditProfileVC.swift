//
//  EditProfileVC.swift
//  EasyConnectServicesAdmin
//
//  Created by vipin kumar on 5/8/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import Kingfisher
import FirebaseStorage

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var welcomelbl: UILabel!
    @IBOutlet weak var tapOnImageLbl: UILabel!
    @IBOutlet weak var peopleImageView: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var servicesTxt: UITextView!
    @IBOutlet weak var saveBtn: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Constants to be used to pass data
    
    var peopleDescription: String = ""
    var peopleName: String = ""
    var categoryName: String = ""
    var peopleAddress: String = ""
    var peoplePhoneNumber: String = ""
    var peopleServices: String = ""
    var categoryId: String = ""
    var peoplePostalCode = ""
    var latutide = 0.0
    var longitude = 0.0
    
    var people: People?
    var category: Category?
    var editBtn: Bool = false
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?

    var categoryArr:[String] = []
    
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        photoTap.numberOfTapsRequired = 1
        peopleImageView.isUserInteractionEnabled = true
        peopleImageView.addGestureRecognizer(photoTap)

        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryTxtField.delegate = self
        
        mapView.delegate = self
        previousLocation = getCenterLocation(for: mapView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear from editprofile")
        getCategoryNames()
        
        if let people = people, let category = category {
            print("Comfigure print")
            configurePeopleProfile(people: people, category: category)
        }else {
            notConfigureView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @objc func imgTapped() {
        // For launchinf imagePicker
        launchImagePicker()
    }
    
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        uploadImageThanDocument()
    }
    
    
    func uploadImageThanDocument() {
        
        guard let image = peopleImageView.image, let name = nameTxtField.text, let category = categoryTxtField.text, let address = addressLbl.text, let description = descriptionTxt.text, let phone = phoneNumberTxt.text, let services = servicesTxt.text else {
           simpleAlert(title: "Error", msg: "Please fill out all required fields.")
            return
        }
        
        self.peopleName = name
        self.categoryName = category
        self.peopleAddress = address
        self.peopleDescription = description
        self.peoplePhoneNumber = phone
        self.peopleServices = services
        
        getCategoryId(categoryName: categoryName)
        activityIndicator.startAnimating()
        
        guard let data = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/peopleImages/\(name).jpeg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.putData(data, metadata: metaData) { (metData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Fail to upload image")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Fails to download url")
                    return
                }
                
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var currentPeople = People(peopleName: peopleName, id: "", category: categoryId, peopleDescription: peopleDescription, imageUrl: url, services: peopleServices, address: peopleAddress, peopleGmail: EmailData.email ?? "", phoneNumber: peoplePhoneNumber, peoplePostalCode: peoplePostalCode, coordinates: GeoPoint(latitude: latutide, longitude:
        longitude))
        
        if let peopleToEdit = people {
            docRef = Firestore.firestore().collection("peoples").document(peopleToEdit.id)
            
            currentPeople.id = peopleToEdit.id
        }else {
            docRef = Firestore.firestore().collection("peoples").document()
            currentPeople.id = docRef.documentID
            
        }
        
        let data = People.modelToData(people: currentPeople)
        
        if editBtn {
            docRef.updateData(data) { (error) in
                
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print(error.localizedDescription)
                    self.simpleAlert(title: "Error", msg: "Fails to Update User Data")
                    return
                }
                
                self.simpleAlert(title: "Alert", msg: "Your data is updated successfully")
                print("Your data is updated successfully")
                self.navigationController?.popViewController(animated: true)
                
                }
            }
        else {
            docRef.setData(data, merge: true) { (error) in
                
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload Firestore")
                    return
                }
                self.simpleAlert(title: "Alert", msg: "Your data is save successfully")
                
                print("Your data is save successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func getCategoryId(categoryName: String) {
        db.collection("categories").getDocuments { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snap?.documents else { return }
            
            for document in documents {
                let data = document.data()
                let currentName = data["name"] as? String ?? ""
                
                if currentName == categoryName {
                    let currentCategoryId = data["id"] as? String ?? ""
                    self.categoryId = currentCategoryId
                    break
                }
            }
        }
    }
    
    func configurePeopleProfile(people: People, category: Category) {
        
        nameTxtField.text = people.peopleName
        guard let imageUrl = URL(string: people.imageUrl) else { return }
        peopleImageView.kf.setImage(with: imageUrl)
        categoryTxtField.text = category.name
        
        let latitude = people.coordinates.latitude
        let logitude = people.coordinates.longitude
        
        let latitude1 = CLLocationDegrees(exactly: latitude)!
        let logitude1 = CLLocationDegrees(exactly: logitude)
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude1 , longitude: logitude1 ?? 0.0)
        mapView.setCenter(coordinates, animated: true)
        descriptionTxt.text = people.peopleDescription
        phoneNumberTxt.text = people.phoneNumber
        servicesTxt.text = people.services
        saveBtn.titleLabel?.text = "Save Changes"
    }
    
    func notConfigureView() {
        peopleImageView.image = #imageLiteral(resourceName: "manLogo")
        nameTxtField.text = ""
        categoryTxtField.text = ""
        addressLbl.text = ""
        descriptionTxt.text = ""
        phoneNumberTxt.text =  ""
        servicesTxt.text = ""
        saveBtn.titleLabel?.text = "Save"
    }
    
    func handleError(error: Error, msg: String) {
        print(error.localizedDescription)
        simpleAlert(title: "Error", msg: msg)
        activityIndicator.stopAnimating()
    }
    
}

//MARK:- UIPickerViewDelegate, UIPickerViewDataSource

extension EditProfileVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return categoryArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTxtField.text = self.categoryArr[row]
        self.categoryPickerView.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArr.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.categoryTxtField {
            self.categoryTxtField.isHidden = false
        }
    }
}

//MARK:- UIImagePickerControllerDelegate and UINaviagtionControllerDelegate

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        peopleImageView.contentMode = .scaleAspectFill
        peopleImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension EditProfileVC: CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 20 else { return }
        self.previousLocation = center
        

        self.latutide = center.coordinate.latitude
        self.longitude = center.coordinate.longitude
        
        geoCoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.first else {
                // show alert to the user
                return
            }
            
            //let country = placemark.country ?? ""
            let postalCode = placemark.postalCode ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            let subAdministrativeArea = placemark.subAdministrativeArea ?? ""
            let locality = placemark.locality ?? ""
            let subLocality = placemark.subLocality ?? ""
            let throughfare = placemark.thoroughfare ?? ""
            let subThoroughfare = placemark.subThoroughfare ?? ""
            
            self.peoplePostalCode = postalCode
            
            DispatchQueue.main.async {
                self.addressLbl.text = "\(locality) \(subLocality) \(throughfare) \(subThoroughfare) \(administrativeArea) \(subAdministrativeArea) - \(postalCode)"
            }
        }
    }
}


//MARK:- For setting up pickerView names

extension EditProfileVC {
    
    func getCategoryNames() {
        db.collection("categories").getDocuments { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snap?.documents else { return }
            
            for document in documents {
                let data = document.data()
                let category = data["name"] as? String ?? ""
                self.categoryArr.append(category)
            }
            
            self.categoryPickerView.reloadAllComponents()
            
        }
    }
}
