//
//  NoteCellTableViewCell.swift
//  people
//
//  Created by John Grayson on 20/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
