//
//  UIImageView.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-20.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func roundedCornersImage() {
    self.layer.cornerRadius = 20
    self.clipsToBounds = true
    self.layer.borderColor = UIColor.flatBlack()?.cgColor
    self.layer.borderWidth = 1
    }
    
}
