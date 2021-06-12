//
//  SeeTrainerLessonCell.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/10/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class SeeTrainerLessonCell: UITableViewCell {
    
    @IBOutlet weak var instrumentlabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var combinedTime: UILabel!
    @IBOutlet weak var attendees: UILabel!
    @IBOutlet weak var lessonprice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
