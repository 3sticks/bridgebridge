//
//  test.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/13/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class trainers: UITableViewCell {
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var instrument: UILabel!
    @IBOutlet weak var pitcher: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pitcher.layer.masksToBounds = true
        pitcher.layer.cornerRadius = pitcher.bounds.width / 2
        
    }



}
