//
//  UIExtension.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 5..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setBorder(color: UIColor) {
        self.layer.borderWidth = 4
        self.layer.borderColor = color.cgColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
