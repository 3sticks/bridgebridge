//
//  ContentView.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/24/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


//struct CircleView: View {
//    @State var label: String
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.blue)
//                .frame(width: 70, height: 70)
//            Text(label)
//        }
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Divider()
//            ScrollView(.horizontal) {
//                HStack(spacing: 10) {
//                    ForEach(0..<10) { index in
//                        CircleView(label: "shite")
//                    }
//                }.padding()
//            }.frame(height: 100)
//            Divider()
//            Spacer()
//        }
//    }
//}

//this is swiping pages
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-scrolling-pages-of-content-using-tabviewstyle

struct ContentView: View {
    var body: some View {
        TabView {
            Text("First")
            Text("Second")
            Text("Third")
            Text("Fourth")
        }
        .tabViewStyle(PageTabViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
