//
//  OwnerMatchingDetailThirdTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 7..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerMatchingDetailThirdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var driverData: DriverDetailInformationResultData? {
        didSet {
            guard let data = driverData else { return }
            messageLabel.text = data.applying_message
        }
    }
}
