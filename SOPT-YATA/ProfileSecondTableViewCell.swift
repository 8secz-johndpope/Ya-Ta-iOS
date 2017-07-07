//
//  ProfileSecondTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class ProfileSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var profile: ProfileResultData? {
        didSet {
            guard let data = profile else { return }
            userNameLabel.text = data.user_name
            idLabel.text = data.user_id
            passwordLabel.text = "*******"
        }
    }
}
