//
//  HostingViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import SwiftUI


struct CircleView: View {
    @State var label: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 70, height: 70)
            Text(label)
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Divider()
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(0..<10) { index in
                        CircleView(label: "\(index)")
                    }
                }.padding()
            }.frame(height: 100)
            Divider()
            Spacer()
        }
    }
}

class HostingViewController: UIHostingController<ContentView> {

    override func viewDidLoad() {
        super.viewDidLoad()

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

