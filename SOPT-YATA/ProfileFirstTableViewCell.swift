//
//  ProfileFirstTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class ProfileFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var profile: ProfileResultData? {
        didSet {
            guard let data = profile else { return }
            emailLabel.text = data.user_email
            phoneLabel.text = data.user_phone
        }
    }
}
