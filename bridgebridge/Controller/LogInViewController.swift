//
//  LogInVC.swift
//  Bridge
//
//  Created by Hugo Bucci III on 10/25/20.
//  Copyright © 2020 Hugo Bucci III. All rights reserved.
//


//TODO add in a forgot username
import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!// do username or username?
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameIncorrectLabel: UILabel!
    
    @IBOutlet weak var passwordIncorrectLabel: UILabel!
    
    
    //create constraint for the login button because we are going to move it down to show password does not exist label. just cool shit.
    @IBOutlet weak var loginTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //on load up, remove the "incorrect username label"
            usernameIncorrectLabel.isHidden = true
        //hide the password too
        passwordIncorrectLabel.isHidden = true

            self.hideKeyboardWhenTappedAround() //hide keyboard .. pulled from extenstion on the register vc
            //usernameIncorrectLabel.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
    


    //add ibaction from connections for usernametextfield
    //for this, i clicked on the usernametextfield, when to the connection inspector
    //then dragged "editing changed" to right here.
    //so, when the user starts editing the text field, we change the color back to gray from red if they previously had an incorrect username
    @IBAction func usernameChanged(_ sender: Any) {
        self.userNameTextField.layer.borderColor = UIColor.gray.cgColor
        self.userNameTextField.layer.borderWidth = 1.0
        
        //remove error label
        usernameIncorrectLabel.isHidden = true
        //usernameIncorrectLabel.removeFromSuperview()
    }
    
    //same with password
    //time to walk frank
    
    @IBAction func passwordChanged(_ sender: Any) {
        self.passwordTextField.layer.borderColor = UIColor.gray.cgColor
        self.passwordTextField.layer.borderWidth = 1.0
        //remove error label
        passwordIncorrectLabel.isHidden = true
        
        //move the login button back up
        self.loginTopConstraint.constant = 16
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            
            //username
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Please enter a username!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            //name
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Did you forget your password?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            
        }
        
        else{
            
            let username = userNameTextField.text!.lowercased()
            let password = passwordTextField.text!
            
            //send mysql request
            let url = URL(string: "https://mybridgeapp.com/login.php")! //path to login file
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            let body = "username=\(username)&password=\(password)"
            
            
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
                                     
                                     // get id from parseJSON dictionary
                                     let id = parseJSON["id"] as? String //(id from dictionary) is this the best way to do this?
                                     
                                     // successfully logged in
                                     if id != nil {
                                        print(parseJSON)
                                        
                                        // save user information we received from our host to userdefaults user variable from scene delegate
                                        UserDefaults.standard.set(parseJSON, forKey: "parseJSON")//save
                                        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable
                                        //THIS SETS USER FOR THIS DEVICE UNTIL LOGOIT
                
                                      // go to tabbar / home page
                                              DispatchQueue.main.async(execute: { //todo what the hell is this
                                                sceneDelegate?.login()
                                              })
                                         
                                        
                                        //TODO i think i need to add a dispatch main queue thing?? iS THIS NECESSARY FIXME
                                        //learn more about this shit yah jabroni. probably add all the error UI updates to the
                                        //dispatch main que shit, like you did for the username right here
                                        //https://www.hackingwithswift.com/read/9/4/back-to-the-main-thread-dispatchqueuemain cdffsfsdghjklm;p[''-;'
                                     // if unable to process request
                                     } else {
                                     
                                        //cast the json as string, check if message is user not found
                                        if parseJSON["message"] as? String == "User is not found"{
                                            
                                            DispatchQueue.main.async {
                                                self.userNameTextField.shake()
                                                //self.userNameTextField.backgroundColor = UIColor.red
                                                self.userNameTextField.layer.borderColor = UIColor.red.cgColor
                                                self.userNameTextField.layer.borderWidth = 1.0
                                                //show the error label
                                                self.usernameIncorrectLabel.isHidden = false
                                                
    
                                            }
//                                            self.userNameTextField.shake()
//                                            //self.userNameTextField.backgroundColor = UIColor.red
//                                            self.userNameTextField.layer.borderColor = UIColor.red.cgColor
//                                            self.userNameTextField.layer.borderWidth = 1.0
//                                            //show the error label
//                                            self.usernameIncorrectLabel.isHidden = false
                                            
                                            //TODO i think i want the red to go away? or should i keep it?
                                            //like when the user taps on the screen to reenter, should i make it clear again?
                                            
                                        }
                                        //do the same for password
                                        if parseJSON["message"] as? String == "Incorrect Password"{
                                        self.passwordTextField.shake()
                                        self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                                        self.passwordTextField.layer.borderWidth = 1.0
                                            self.passwordIncorrectLabel.isHidden = false
                                            
                                            //if the password is wrong, we have to move the login button down to have the error fit
                                            //move it down 8 clicks
                                            self.loginTopConstraint.constant = 32
                                            
                                        }
                                        

                                        
                                        print(parseJSON) //goes to console

                                                      
                                    }
                                    
                                 } catch {
                                        // get main queue to communicate back to user
           
                                        print("Caught an error \(error)")

                                    }
                            })
                            
                         }else {
                            
                            print(error)
                        }}.resume()
            }

        }
    
    }
//needed for the shake
public extension UIView {

    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}

//send to next screen HAHA

