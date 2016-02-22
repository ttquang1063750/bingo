//
//  SlotCellTableViewCell.swift
//  Bingo
//
//  Created by GUMI-QUANG on 2/22/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class SlotCellTableViewCell: UITableViewCell {

    @IBOutlet weak var slot01: UIImageView!
    @IBOutlet weak var slot02: UIImageView!
    @IBOutlet weak var slot03: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
