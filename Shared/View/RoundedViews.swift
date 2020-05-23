//
//  RoundedViews.swift
//  EasyConnectServices
//
//  Created by vipin kumar on 3/9/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.shadowColor = AppColors.Blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}


class CircularImageView: UIImageView {
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
        
    }
}

class CircularView: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
    }
}


class SemiRoudedView: UIView {
    override func awakeFromNib() {
        
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
