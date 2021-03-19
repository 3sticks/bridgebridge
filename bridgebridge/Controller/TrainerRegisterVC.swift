//
//  TrainerRegisterVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/18/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//
import UIKit
import Foundation
class TrainerRegisterVC: UIViewController, UITextFieldDelegate {

//changed all these for this VC cause of some outlet shit
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //HIDE THE KEYBOARD WHEN TAPPED OUTSIDE TEXT BOXS!!! uses the extension at the bottom of this vc
    }
    //TODO validate password. how?
    //TODO validate email actually an email adddress. how?
    
    //This makes the cursor jump to the next box when the "next" button is pressed. needed to add the ui textfielddelegate to the top up there, then need to drag each text box's delegate outlet to the VC little boc thing, then itll work.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == nameTF {
         textField.resignFirstResponder()//"When a text view resigns its first responder status, it ends its current editing session, notifies its delegate of that fact, and dismisses the keyboard."
        usernameTF.becomeFirstResponder()
      } else if textField == usernameTF {
         textField.resignFirstResponder()
        emailTF.becomeFirstResponder()
      } else if textField == emailTF {
         textField.resignFirstResponder()
        passwordTF.becomeFirstResponder()
      } else if textField == passwordTF {
         textField.resignFirstResponder()
      }
     return true
      } //last return key is "done"
    

    
    @IBAction func registerButPressed(_ sender: Any) {
        
        
        
        if usernameTF.text!.isEmpty || nameTF.text!.isEmpty || emailTF.text!.isEmpty || passwordTF.text!.isEmpty  { //TODO also need to add email validation and password validation... do this through the database or local?
            
            //username
            usernameTF.attributedPlaceholder = NSAttributedString(string: "Please enter a username!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            //name
            nameTF.attributedPlaceholder = NSAttributedString(string: "Don't you have a name?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            //email
            emailTF.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email address!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
           
            
            //password
            //Tell them the requirements? below? in the text field? do i do the thing that makes things green or red if theyre met?
            passwordTF.attributedPlaceholder = NSAttributedString(string: "Please enter a valid password!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            //TODO I dont like the red staying there.......... or the new text.... figure that out
            
        //own database!
            
        //f text is entered
        } else {
            
        //this is for TRAINERS, so minor edit to register code
        //change the php
            //accept teh same info though
        //change teh login function from scene delagate
            
        //url prep
        //create new user in Mysql
        let url = URL(string: "https://mybridgeapp.com/registertrainer.php")!//EXCLAMATION POINT OPTIONAL
            //so this accesses the register php url. i might TODO this and possobly change the domaiN
            // url to php file
            // request to this file
            var request = URLRequest(url: url)
            // method to pass data to this file (e.g. via POST)
            request.httpMethod = "POST"
            //this body variable is like entering http://mybridgeapp.com/register.php?username=1&password=3&email=3&fullname=3
            //into the url bar
            
            // body to be appended to url
            //remember the optionals!
            let body =  "username=\(usernameTF.text!.lowercased())&password=\(passwordTF.text!)&email=\(emailTF.text!)&fullname=\(nameTF.text!)"
            //so i am just giving the user 1 field to enter their name. should i do two like Ahkmed? I dont think its necessary, but if i did, this is how to combine them. %20 is a space
            //fullname=\(firstnameTxt.text!)%20\(lastnameTxt.text!)"
            
            //append the body to the request (url)
            request.httpBody = body.data(using: .utf8)
            
            
            //proceed with request
            // proceed request
             URLSession.shared.dataTask(with: request) { data, response, error in
                 
                //check for error
                //no error
                 if error == nil {
                //send request
                     
                    // get main queue in code process to communicate back to user interface
                     DispatchQueue.main.async(execute: {
                         
                         do {
                             // get json result
                             let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                             
                             // assign json to new var parseJSON in guard/secured way
                             guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                                 print("Error while parsing")
                                 return
                             }
                             
                             // get id from parseJSON dictionary
                             let id = parseJSON["id"]//(id from dictionary) is this the best way to do this?
                             
                             // successfully registered
                             if id != nil {

                                 // save user information we received from our host
                                  UserDefaults.standard.set(parseJSON, forKey: "parseJSON")//save
                                  user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable
                                  
                                // go to tabbar / home page
                                        DispatchQueue.main.async(execute: {
                                            sceneDelegate?.trainerLogin()
                                        })
                                   
                        
                                //navigate to next homepage
                                print(parseJSON)
                                 
                             //TODO should i make this the same?
                             }
                            
                         } catch {
                                
                                print("Caught an error \(error)")

                            }
                    })
                    
                 }else {
                    
                    print(error)
                }
                                 
                            
                             }.resume()
                  }
    }
    
    
    
    }
//
////anytime user taps outside the text boxes, kill the keyboard
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
