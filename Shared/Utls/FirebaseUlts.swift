//
//  FirebaseUlts.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/17/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Firebase

extension Auth {
    func handleFirAuthError(error: Error, vc: UIViewController){
        if let errorCode = AuthErrorCode(rawValue: error._code){
            let alert = UIAlertController.init(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
        default:
            return "Sorry, something went wrong."
        }
    }
}
