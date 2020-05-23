//
//  PeopleCell.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/20/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Kingfisher

class PeopleCell: UITableViewCell {
    
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var personNameLbl: UILabel!
    @IBOutlet weak var servicesLbl: UILabel!
    @IBOutlet weak var peopleAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    func configureCell(people: People) {
        personNameLbl.text = people.peopleName
        peopleAddress.text = "Address:- \(people.address)"
        
        servicesLbl.text = people.services
        
        let longitude = people.coordinates.longitude
        let latitude = people.coordinates.latitude
        
        print("longitude is \(longitude)")
        print("latitude is \(latitude)")
        
        
        if let url = URL(string: people.imageUrl) {
            personImg.kf.setImage(with: url)
        }
    }
}
