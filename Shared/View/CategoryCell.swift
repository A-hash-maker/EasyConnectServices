//
//  CategoryCell.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 4/19/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(category: Category) {
        categoryLbl.text = category.name
        
        if let url = URL(string: category.imageUrl) {
            let placeholder = UIImage(systemName: "placeholder")
            let options: KingfisherOptionsInfo = [.transition(.fade(0.3))]
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            categoryImg.kf.indicatorType = .activity
        }
    }
}
