//
//  CustomTextField.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 5..
//  Copyright © 2017년 YATA. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 2.0, dy: 1.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 2.0, dy: 1.0)
    }
}
