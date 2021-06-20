//
//  UserViewOwnSchedCell.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class UserViewOwnSchedCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var instrument: UILabel!
    @IBOutlet weak var trainer: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
