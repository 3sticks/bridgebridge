//
//  test.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class test: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this works, but very buggily. presents a popup, only on load and not reload (easily fixable, of course)
        let vc = CalandarViewController() //change this to your class name
        self.present(vc, animated: true, completion: nil)


        // Do any additional setup after loading the view.
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
