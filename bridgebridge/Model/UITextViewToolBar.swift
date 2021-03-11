//
//  UITextViewToolBar.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/3/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//
// This creates a toolbar that is placed above the keyboard on a textview when called. Used for the post keyboard... going to add more things to it
//https://www.swiftdevcenter.com/uitextview-dismiss-keyboard-swift/

//maybe add pictures https://stackoverflow.com/questions/9926978/how-to-add-images-to-uitoolbar


import UIKit

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
