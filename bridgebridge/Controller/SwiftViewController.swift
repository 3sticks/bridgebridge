//
//  SwiftViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/24/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import SwiftUI
class SwiftViewController: UIViewController {

    @IBOutlet var dateswiper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let controller = UIHostingController(rootView: ContentView())
////        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        addChild(controller)
//        controller.view.frame = dateswiper.bounds
//        dateswiper.addSubview(controller.view)
//        controller.didMove(toParent: self)
////        self.view.addSubview(controller.view)
//        controller.didMove(toParent: self)
//
//
//        NSLayoutConstraint.activate([
//                   controller.view.widthAnchor.constraint(equalToConstant: 200),
//                   controller.view.heightAnchor.constraint(equalToConstant: 44),
//                   controller.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                   controller.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        ])
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

//
//If you want to embed SwiftUI into a UIKit view controller, use a Container View.
//
//class ViewController: UIViewController {
//    @IBOutlet weak var theContainer: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let childView = UIHostingController(rootView: SwiftUIView())
//        addChild(childView)
//        childView.view.frame = theContainer.bounds
//        theContainer.addSubview(childView.view)
//        childView.didMove(toParent: self)
//    }
//}
