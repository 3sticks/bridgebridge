//
//  CalKitVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import CalendarKit

class CalKitVC: UIViewController {

    @IBOutlet var scrolly: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for _ in 0...10 {
            if let dayView = Bundle.main.loadNibNamed("DayView", owner: nil, options: nil)!.first as? DayView {
                dayView.titleLabel.text = "Friday"
                dayView.detailLabel.text = "A long detail text will be shown here"
                scrolly.addArrangedSubview(dayView)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


