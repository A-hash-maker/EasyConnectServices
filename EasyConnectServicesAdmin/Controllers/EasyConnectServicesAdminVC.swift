//
//  EasyConnectServicesAdminVC.swift
//  EasyConnectServicesAdmin
//
//  Created by vipin kumar on 5/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit

class EasyConnectServicesAdminVC: UIViewController {
    
    @IBOutlet weak var headingTitleLbl: UILabel!
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var freeProfileLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headingTitleLbl.alpha = 0
        getStartedBtn.alpha = 0
        freeProfileLbl.alpha = 0
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAnimation(headingTitleLbl, getStartedBtn, freeProfileLbl)
    }
    
    
    func showAnimation(_ headingTitleLbl: UILabel, _ getStartedBtn: UIButton, _ freeProfileLbl: UILabel){
        UIView.animate(withDuration: 0.5, animations: {
            headingTitleLbl.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                freeProfileLbl.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: 0.5) {
                    getStartedBtn.alpha = 1
                }
            }
        }
    }
    
    
    @IBAction func getStartedBtnTapped(_ sender: UIButton) {
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}
