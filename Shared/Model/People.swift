//
//  People.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/19/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct People {
    var peopleName: String
    var id: String
    var category: String
    var peopleDescription: String
    var imageUrl: String
    var phoneNumber: String
    var services: String
    var address: String
    var rating: Double
    var peopleGmail: String
    var peoplePostalCode: String
    var coordinates: GeoPoint
    var timeStamp: Timestamp
    
    
    init(peopleName: String, id: String, category: String, peopleDescription: String, imageUrl: String, services: String, address: String, rating: Double = 0.0, peopleGmail: String, phoneNumber: String ,peoplePostalCode: String, coordinates: GeoPoint, timeStamp: Timestamp = Timestamp()) {
        self.peopleName = peopleName
        self.id = id
        self.category = category
        self.peopleDescription = peopleDescription
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.address = address
        self.rating = rating
        self.peopleGmail = peopleGmail
        self.peoplePostalCode = peoplePostalCode
        self.coordinates = coordinates
        self.timeStamp = timeStamp
        self.services = services
    }
    
    
    init(data: [String: Any]) {
        self.peopleName = data["peopleName"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category =  data["category"] as? String ?? ""
        self.peopleDescription = data["peopleDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.services = data["services"] as? String ?? ""
        self.rating = data["rating"] as? Double ?? 0.0
        self.coordinates = data["coordinates"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
        self.peopleGmail = data["peopleGmail"] as? String ?? ""
        self.peoplePostalCode = data["peoplePostalCode"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(people: People) -> [String: Any] {
       
        let data: [String: Any] = [
            "peopleName": people.peopleName,
            "id": people.id,
            "category": people.category,
            "peopleDescription": people.peopleDescription,
            "imageUrl": people.imageUrl,
            "phoneNumber": people.phoneNumber,
            "services": people.services,
            "address": people.address,
            "rating": people.rating,
            "peopleGmail": people.peopleGmail,
            "peoplePostalCode": people.peoplePostalCode,
            "coordinates": people.coordinates,
            "timeStamp": people.timeStamp
        ]
        return data
    }
}
