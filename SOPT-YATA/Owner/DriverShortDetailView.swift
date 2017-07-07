//
//  DriverShortDetailView.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class DriverShortDetailView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var withLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func cancel(_ sender: UIButton) {
        self.isHidden = true
    }
    
    var driverData: DriverDetailInformationResultData? {
        didSet {
            guard let data = driverData else { return }
            nameLabel.text = data.user_name
            ageLabel.text = "\(data.user_age)"
            ratingLabel.text = "\(data.rating_star)"
            withLabel.text = "\(data.applying_companion)명"
            previousLabel.text = data.user_career
            messageLabel.text = data.applying_message
        }
    }
}
