//
//  OwnerMatchingTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 7..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerMatchingTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var data: OwnerListResultData? {
        didSet {
            guard let data = data else { return }
            nameLabel.text = data.user_name
            messageLabel.text = data.applying_message
            if let time = data.applying_created_at.components(separatedBy: "T").first {
                timeLabel.text = time.replacingOccurrences(of: "-", with: ". ")
            }
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        messageLabel.text = ""
        timeLabel.text = ""
    }
}
