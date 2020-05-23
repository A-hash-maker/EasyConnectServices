//
//  Constants.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "LoginVC"
    static let AdminLoginVC = "AdminLoginVC"
    static let EditProfileVC = "EditProfileVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.2117647059, green: 0.2431372549, blue: 0.431372549, alpha: 1)
    static let Red = #colorLiteral(red: 0.7147049492, green: 0.1662300606, blue: 0.1394550304, alpha: 0.9072666952)
    static let OffWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct Identifiers {
    static let categoryCell = "CategoryCell"
    static let PeopleCell = "PeopleCell"
}

struct Segues {
    static let toPeople = "toPeopleVC"
    static let toEditProfile = "toEditProfile"
}

struct EmailData {
    static var email: String?
}

struct CurrentUserData {
    static var currentPeople: People?
    static var currentCategory: Category?
}


struct PeopleDetail {
    
    static let peopleName = "peopleName"
    static let id = "id"
    static let category = "category"
    static let peopleDescription = "peopleDescription"
    static let imageUrl = "imageUrl"
    static let phoneNumber = "phoneNumber"
    static let services = "services"
    static let address = "address"
    static let rating = "rating"
    static let peopleGmail = "peopleGmail"
    static let peoplePostalCode = "peoplePostalCode"
    static let coordinates = "coordinates"
    static let timeStamp = "timeStamp"
    
}
