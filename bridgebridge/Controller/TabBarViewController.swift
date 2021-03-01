//
//  TabBarViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 2/24/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //used runtime attributes to change the tab bar icon selected/unselected colors instead of all this shit, got it from //https://stackoverflow.com/questions/26835148/change-tab-bar-item-selected-color-in-a-storyboard
        
        
//        // Do any additional setup after loading the view.
//
//        //color of items in tab bar
//        self.tabBar.tintColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 1) //this is the brand black
//
//        self.tabBar.isTranslucent = false //without this, the tab bar is a weird gray color
        
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
