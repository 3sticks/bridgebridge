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
    var didsignup = 0101010
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let seconds = 2.0

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            
            self.signupbutton.setTitle("Sign Up", for: .normal)
            //show the spinner
            self.spinner.isHidden = true
            //spin the spinner
            self.spinner.stopAnimating()
            //okay, new new plan. the us
            if self.didsignup == 1{
                print("success")
            } else {
                
                print("oh man someone signed up before you. try another lesson!")
            }
            print("dididid\(self.didsignup)")
        }
        
            self.dismiss(animated: true, completion: nil)




        }
        
        
        
        
        
        
    }
    

