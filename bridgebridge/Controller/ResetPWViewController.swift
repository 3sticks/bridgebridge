//
//  ResetPWViewController.swift
//  Bridge
//
//  Created by Hugo Bucci III on 12/29/20.
//  Copyright © 2020 Hugo Bucci III. All rights reserved.
//

import UIKit

class ResetPWViewController: UIViewController {
    
    //UI object
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var notFoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the email not found label
        notFoundLabel.isHidden = true
        
        //hides the back button -- just a demo, not keeping here
        //self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
    }
    
    //the user starts editing the email they entered
    @IBAction func emailchanged(_ sender: Any) {
        self.emailText.layer.borderColor = UIColor.gray.cgColor
        self.emailText.layer.borderWidth = 1.0
        
        //rehide the not dound label
        notFoundLabel.isHidden = true
        
    }
    @IBAction func resetButton(_ sender: Any) {
        
        if emailText.text!.isEmpty {
            
            //red placeholder
            emailText.attributedPlaceholder = NSAttributedString(string: "Please enter your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        //can we add an email verifier here?? TODO like make sure valid email address
     else {
            
            let email = emailText.text!.lowercased()
            
            //send mysql request
                       let url = URL(string: "https://mybridgeapp.com/resetpassword.php")! //path to login file
                       var request = URLRequest(url: url)
                       
                       request.httpMethod = "POST"
                       
            
                       //add email to body to be appended to the url
                       let body = "email=\(email)"
                       
                       
                       request.httpBody = body.data(using: .utf8)
                               
                               // launch session
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
                                                
                                                if parseJSON["message"] as? String == "Email not found"{ //could just have any error message, since its always going to be email not found
                                                    
                                                    self.emailText.shake() //can call shake from other VC without initializing that vc since its public extension
                                                    self.emailText.layer.borderColor = UIColor.red.cgColor
                                                    self.emailText.layer.borderWidth = 1.0
                                                    
                                                    //show not found label
                                                    self.notFoundLabel.isHidden = false
                                                } //should i go else here? is there any other thing the json message could be??? check the php
                                                else { ///using an else ... if the error isnt email not found, we sent an email. show popup
                                                    
                                                    //POP UP FOR PASSWORD RESET LINK NOTIFICATION
                                                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpID")
                                                    self.addChild(popOverVC)
                                                    popOverVC.view.frame = self.view.frame
                                                    self.view.addSubview(popOverVC.view)
                                                    popOverVC.didMove(toParent: self)
                                                }
                                                
                                                //pop up saying "email reset sent. then return to login. 
                                                   print(parseJSON) //this is the logger message
                                                
                                                
                                   
                                                
                                                
                                                // if unable to process request
                                               
                                               
                                            } catch {
                                                   
                                                   print("Caught an error \(error)")

                                               }
                                       })
                                       
                                    }else {
                                       
                                       print(error)
                                   }}.resume()

                       }

                   }
    
    //mysql request
    
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

