//
//  TrainerCell.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/13/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TrainersCell: UITableViewCell {


    @IBOutlet var fullname: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var instrument: UILabel!
    @IBOutlet var pitcher: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        make image round
        pitcher?.layer.masksToBounds = true
        pitcher?.layer.cornerRadius = pitcher.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//if let imageURL = URL(string: imageUrlString) {
//    DispatchQueue.global().async {
//        let data = try? Data(contentsOf: imageURL)
//        if let data = data {
//            let image = UIImage(data: data)
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }
//    }
//}
