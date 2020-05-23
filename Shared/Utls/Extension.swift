//
//  Extension.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
