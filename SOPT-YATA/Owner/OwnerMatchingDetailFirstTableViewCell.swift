//
//  OwnerMatchingDetailFirstTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 8..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerMatchingDetailFirstTableViewCell: UITableViewCell {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startLabel.text = UserDefaults.standard.string(forKey: "firstLocTitle") ?? ""
        endLabel.text = UserDefaults.standard.string(forKey: "secondLocTitle") ?? ""
    }

}
