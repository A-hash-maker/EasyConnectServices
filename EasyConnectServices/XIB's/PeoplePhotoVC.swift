//
//  PeoplePhotoVC.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/30/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Kingfisher

class PeoplePhotoVC: UIViewController {
    
    
    var imgString = ""
    
    @IBOutlet weak var peopleImgView: UIImageView!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        tap.numberOfTapsRequired = 1
        
        bgView.addGestureRecognizer(tap)
        
        
        if let url = URL(string: imgString) {
            peopleImgView.kf.setImage(with: url)
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    

}
