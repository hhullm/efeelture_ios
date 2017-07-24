//
//  TableViewCell.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/9.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var hardid: UILabel!
    @IBOutlet weak var hardcloudid: UILabel!
    @IBOutlet weak var tyoe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
