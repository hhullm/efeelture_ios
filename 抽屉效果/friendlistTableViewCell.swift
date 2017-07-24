//
//  friendlistTableViewCell.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/15.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class friendlistTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
