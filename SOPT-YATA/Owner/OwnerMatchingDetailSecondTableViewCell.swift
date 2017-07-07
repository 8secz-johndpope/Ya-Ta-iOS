//
//  OwnerMatchingDetailSecondTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 7..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerMatchingDetailSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var withLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    
    var driverData: DriverDetailInformationResultData? {
        didSet {
            guard let data = driverData else { return }
            nameLabel.text = data.user_name
            ageLabel.text = "\(data.user_age)"
            ratingLabel.text = "\(data.rating_star)"
            withLabel.text = "\(data.applying_companion)명"
            previousLabel.text = data.user_career
        }
    }
}
