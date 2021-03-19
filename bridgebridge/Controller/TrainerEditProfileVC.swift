//
//  TrainerEditProfileVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

//same as user..... should be 

class TrainerEditProfileVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var instrument: UITextField!
    @IBOutlet weak var exper: UITextField!
    @IBOutlet weak var linkBox: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        //use the uitextviewtoolbar swift class and add a done button to the keybaord
        textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:))) //this is enabled by creating an extension to UITextView, in UITTEXTVIEWTOOLBAR.SWIFT

        
        
        //obviously want to pull in the text from user defaults here so the user can edit it
        let about = user!["about"] as? String
        let instrumentText = user!["instrument"] as? String
        let name = user!["fullname"] as? String //user sets their full name at the beginning
        let experience = user!["experience"] as? String
        
        if about! == "" {
        
            textView.text = "Tell the people about yourself. Use this space to highlight your strengths as a trainer, and why the users should train with you."
            
        } else {
            
            
            textView.text = about
            
        }
        
        //TEXTVIEW

        textView.textColor = UIColor.lightGray
        //add border, using brand gray
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.25).cgColor
        
        //THE REST
        nameLabel.text = name
        instrument.text = instrumentText
        exper.text = experience
        
    }
    
    //goes along with done button on toolbar we created
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    //only clear when typing if the placeholder is there
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tell the people about yourself. Use this space to highlight your strengths as a trainer, and why the users should train with you." {
            textView.text = nil
            textView.textColor = UIColor.black
        }

        
    }


    @IBAction func savePressed(_ sender: Any) {
        
        if linkBox != nil { //if the link is not empty, make sure it is a link
            //https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift/49072718
            
        }
        
        //get the user ID
        let id = user!["id"] as? String
        //COMMENTS FOR ALL OF THIS ARE ON THE REGISTER SCREEN IF YOU FORGET
        let url = URL(string: "https://mybridgeapp.com/aboutme.php")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        print(instrument.text!)
        //add bio info and id to body
        let body = "about=\(textView.text!)&instrument=\(instrument.text!)&fullname=\(nameLabel.text!)&experience=\(exper.text!)&id=\(id!)"
        print(body)
        request.httpBody = body.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
        
                DispatchQueue.main.async(execute: {
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                            print("Error while parsing")
                            return
                        }
                        
                        let about = parseJSON["about"] //get the about text
                        
                        // successfully registered
                        if about != nil {

                            // save user information we received from our host
                             UserDefaults.standard.set(parseJSON, forKey: "parseJSON")//save
                             user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable
                            
                            print(parseJSON)
                            
                        }
                       
                    } catch {
                           
                           print("Caught an error \(error)")

                       }
               })
               
            }else {
               
               print(error)
           }
                            
                       
                        }.resume()

       self.navigationController?.popViewController(animated: true)
    }

    //if they press done.... actually..... i wamt the placeholder gone, since they can post a pic with no text. yeah, remove this. but keep it just in case.
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//        }
//    }

}
