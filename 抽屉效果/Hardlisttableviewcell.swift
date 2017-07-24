//
//  Hardlisttableviewcell.swift
//  newstart
//
//  Created by zpzlshcs on 2017/7/9.
//  Copyright © 2017年 zpzlshcs. All rights reserved.
//

import UIKit

class Hardlisttableviewcell: UITableViewCell {

    @IBOutlet weak var hard_id: UILabel!
    @IBOutlet weak var hard_name: UILabel!
    @IBOutlet weak var hard_type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
