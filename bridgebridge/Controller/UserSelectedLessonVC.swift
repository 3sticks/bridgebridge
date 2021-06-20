//
//  UserSelectedLessonVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/11/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import Alamofire

class UserSelectedLessonVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var insturment: UILabel!
    @IBOutlet weak var descriptionview: UITextView!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var signupbutton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var lesson = NSDictionary()
    var lessonCheck = [AnyObject]()
    var numattendcheck = String()
    var numpermitcheck = String()
    //check if user was able to sign up if it wasnt full
//    var didsignup = Int()
    var didsignup = 0101010 {
        //DID FUCKING SET!!!!!!!!! this watches didsignup to see changes! any time it changes run the function. i honestly dont know why this works when the user stays
        //on the screen and keeps spamming sign up (which they wont be able to do anyway), but fuck it. FINALLY
        //https://www.hackingwithswift.com/read/8/5/property-observers-didset
        didSet {
            infoReturnedSendAlert()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did sign up \(didsignup)")
        descriptionview.delegate = self
        descriptionview.isEditable = false
        descriptionview.layer.borderWidth = 0.25
        descriptionview.layer.borderColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.25).cgColor
        descriptionview.backgroundColor = UIColor.clear


        //hide the spinner to start
        spinner.isHidden = true
        
        //get lesson details passed by previous view
        //rewriting some code here sure, but i think its nec
     //   let lessonDate = lesson["datey"] as? String
        let instrument = lesson["instrument"] as? String
        let lessonstart = lesson["starttime"] as? String
        let lessonend = lesson["endtime"] as? String
       // let lessontype = lesson["lessontype"] as? String
        //let attending = lesson["numattending"] as? Int
        let description = lesson["description"] as? String
        let lessonprice = lesson["price"] as? String
        
        let uniqueid = lesson["uniqueid"] as? String
        
        //grab attending and permitted
        let att = lesson["numattending"] as? Int
        let perm = lesson["numpermitted"] as? Int
        
        print(att)
        print(perm)
        //check to see if its full
        if att == perm{
            //disable the button
            signupbutton.isEnabled = false
            signupbutton.setTitle("Lesson is full!", for: .normal)
            //TODO maybe make this say like, notify me, then send them an email if it opens up????
        }
        
        
        print("LOOOOOK")
        print(lesson)

        print(uniqueid)
        //need to pull the unique id too for when the user signs up and does some shit to the swl table
        // Do any additional setup after loading the view.
        
        time.text = "Time: \(lessonstart!)-\(lessonend!)"
        insturment.text = instrument
        descriptionview.text = description
        price.text = "$\(lessonprice!)" //im putting a dollar sign here for now. will eventually be variable when we go to other countries and shit
        

        
    }
    

    @IBAction func signup(_ sender: Any) {
        signupbutton.setTitle("", for: .normal)
        //show the spinner
        spinner.isHidden = false
        //spin the spinner
        spinner.startAnimating()
        //okay, new new plan. the user presses sign up. it calls a sql statement that adds 1 to the attending column ONLY IF the attending column <> permitted. if it equals permitted, 0 rows get updated, and the user
        // did not sign up. the json "affected" will be 0, send a message to the user.
        let uniqueid = lesson["uniqueid"] as? String


            let userID = user!["id"] as? String
            print(userID)

            let url = URL(string: "https://mybridgeapp.com/signuplesson.php")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
//https://mybridgeapp.com/signuplesson.php?lessonid=5&userid=121
            //    public function createLesson($id, $datey, $starttime, $endtime, $lessonlength, $instrument, $numpermitted, $price, $description)
            let body = "uniqueid=\(uniqueid!)&userid=\(userID!)"
            print(body)

            request.httpBody = body.data(using: .utf8)


            URLSession.shared.dataTask(with: request) { data, response, error in

                if error == nil {

                    DispatchQueue.main.async(execute: { [self] in

                        do {
                            // get json result
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means

                            // assign json to new var parseJSON in guard/secured way
                            guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                                print("Error while parsing")
                                return
                            }
                            
                            //didsignup is gonna be 0 or 1 -- 1 means did sign up
                            self.didsignup = (parseJSON["affected"] as? Int)!
                            print(parseJSON)

                        } catch {

                               print("Caught an error \(error)")

                           }
                   })

                }else {

                   print(error)
               }


                            }.resume()

        //so a dumb fuckin way to do this.. have the program wait 2 secodnds while the network shit runs since its async and what not. so the system pauses. i think i actually like it... assuming it takes less than 2 fuckin seconds for the network shit to run. kind of a gamble. we'll work it out.




        }
    
    //this runs whenever disignup is changed
    func infoReturnedSendAlert(){

            self.signupbutton.setTitle("Sign Up", for: .normal)
            //show the spinner
            self.spinner.isHidden = true
            //spin the spinner
            self.spinner.stopAnimating()
            //okay, new new plan. the us
            if self.didsignup == 1{
                print("success")
                // Create new Alert
                var dialogMessage = UIAlertController(title: "Success!", message: "Successfully signed up for lesson", preferredStyle: .alert)
                
                // Create nice button with action handler
                let nice = UIAlertAction(title: "Nice!", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    //do i want to send the user to their own lesson schedule page here???
                    
                    //this goes to the user schedule page, which isnt built yet. Build it. 
                    self.tabBarController?.selectedIndex = 2
                    
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(nice)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                
                
                
            } else {
                
                // Create new Alert
                var dialogMessage = UIAlertController(title: "Bummer", message: "This lesson filled up while you were reading about it. Head back to the trainers page to see what else they can offer!", preferredStyle: .alert)
                
                // Create nice button with action handler
                
                let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
//                    if let firstViewController = self.navigationController?.viewControllers. {
//                        self.navigationController?.popToViewController(firstViewController, animated: true)
//                    }
                    //go back one view  (back to the trainer lesson page)
                    self.navigationController?.popViewController(animated: true)
                    
                    //send the user back to the trainer page
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(okay)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                
                
                
                print("oh man someone signed up before you. try another lesson!")
            }
            print("dididid\(self.didsignup)")
        
//            self.dismiss(animated: true, completion: nil)

        
    }
        
        
        
        
        
        
    }
    

