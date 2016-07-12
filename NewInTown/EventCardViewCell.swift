//
//  EventCardViewCell.swift
//  NewInTown
//
//  Created by fnord on 7/11/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit
import Material

class EventCardViewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
