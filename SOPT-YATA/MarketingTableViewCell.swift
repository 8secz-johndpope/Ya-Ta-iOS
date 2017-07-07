//
//  MarketingTableViewCell.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class MarketingTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
