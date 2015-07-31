//
//  ReminderTableViewCell.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
