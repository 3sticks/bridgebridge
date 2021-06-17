//
//  UserSelectedLessonVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/11/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class UserSelectedLessonVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var insturment: UILabel!
    @IBOutlet weak var descriptionview: UITextView!
    @IBOutlet weak var price: UILabel!
    
    
    var lesson = NSDictionary()
    var lessonCheck = [AnyObject]()
    var numattendcheck = String()
    var numpermitcheck = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionview.delegate = self
        descriptionview.isEditable = false
        descriptionview.layer.borderWidth = 0.25
        descriptionview.layer.borderColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.25).cgColor
        descriptionview.backgroundColor = UIColor.clear

        print("LOOOOOK")
        print(lesson)

        
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
        
        let lessonID = lesson["lessonid"] as? String
        
        //need to pull the unique id too for when the user signs up and does some shit to the swl table
        // Do any additional setup after loading the view.
        
        time.text = "Time: \(lessonstart!)-\(lessonend!)"
        insturment.text = instrument
        descriptionview.text = description
        price.text = "$\(lessonprice!)" //im putting a dollar sign here for now. will eventually be variable when we go to other countries and shit
        

        
    }
    

    @IBAction func signup(_ sender: Any) {
        
        //okay new plan. when the user presses save, call select lesson to get the most up to date number of attendees in the lesson theyre fucking around on
        //need to make a new php
        //just need to send the unique id in the body idk why the fuck i used uniqueid when i literally had lesson id but fucking whatever
        let result = checklessonattendees()
        
        let numberattendingha = result.numatten
        let booleancheck = result.booleanhaha
        
        print("num\(numberattendingha)")
        print(booleancheck)
        //only proceed if its false
        if !booleancheck {
            
            print("made it here")
        
            //add one to the number attedning
//            var numbernowattending = String(Int(numberattendingha)! + 1)
//            print(numbernowattending)
//
//            let lessonID = lesson["lessonid"] as? String
//
//            print(lessonID)
//
//            let userID = user!["id"] as? String
//            print(userID)
//
//            let url = URL(string: "https://mybridgeapp.com/signuplesson.php")!
//
//            var request = URLRequest(url: url)
//
//            request.httpMethod = "POST"
//
//            //    public function createLesson($id, $datey, $starttime, $endtime, $lessonlength, $instrument, $numpermitted, $price, $description)
//            let body = "lessonid=\(lessonID!)&userid=\(userID!)&numbernowattending=\(numbernowattending)"
//            print(body)
//
//            request.httpBody = body.data(using: .utf8)
//
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//
//                if error == nil {
//
//                    DispatchQueue.main.async(execute: {
//
//                        do {
//                            // get json result
//                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
//
//                            // assign json to new var parseJSON in guard/secured way
//                            guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
//                                print("Error while parsing")
//                                return
//                            }
//
//                            print(parseJSON)
//
//                        } catch {
//
//                               print("Caught an error \(error)")
//
//                           }
//                   })
//
//                }else {
//
//                   print(error)
//               }
//
//
//                            }.resume()
//
//            //adding this here instad of
//
//            self.dismiss(animated: true, completion: nil)


            
            
        }
        
        
        
        
        
        
    }
    
    //return the boolean, then the values of attendees and shit. all this for future hugo. fuck  you
    func checklessonattendees() -> (booleanhaha: Bool, numatten: String, numperm: String){
        
        var nattend : String = ""
        var npermit : String = ""
        var numbers = NSDictionary()
        print("hahahahahahahaha\(numbers)")
        //"false" means its not filled up, and the function can proceed with signing the user up
        var booleanhaha = false
        let uniqueid = lesson["uniqueid"] as? String
        let url = URL(string: "https://mybridgeapp.com/checklesson.php")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"

        
        let body = "uniqueid=\(uniqueid!)"
        print(body)
        
        request.httpBody = body.data(using: .utf8)
        
        //need this group enter shit for the rest of the function (the assignments) to wait until the network call is done.
        let group = DispatchGroup()
        group.enter()
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
        
    
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                            print("Error while parsing")
                            return
                        }
                        
                        guard let parseLESSSONS = parseJSON["lesson"] else {
                            print(parseJSON["message"] ?? [NSDictionary]())
                            return
                        }
                        
                        
                        print(parseLESSSONS)
                        numbers = parseLESSSONS as! NSDictionary
                        print("numbers \(numbers)")
//                        let na = parseJSON["numattending"] as? String
//                        let np = parseJSON["numpermitted"] as? String
//                        print(na!)
//                        print(np!)
//                        nattend = (parseJSON["numattending"] as? String)!
//                        npermit = np!

                        //i believe i have finally found the CORRECT GD SPOT FOR THIS
                        group.leave()
         
                        //store lessons in array
                       
                    } catch {
                           
                           print("Caught an error \(error)")

                       }

               
            }else {
               
               print(error)
           }
                            
                       
                        }.resume()
        
        
        group.notify(queue: .main) {
            
            print("fgt")
            let doodoocaca = numbers["description"] as? String
            nattend = (numbers["numattending"] as? String)!
            npermit = (numbers["numpermitted"] as? String)!
            print("perm\(doodoocaca!)")

//
            if  nattend == npermit{
                //todo send this to user
                print("lesson has filled up before you could sign up! check trainers other lessons")
                booleanhaha = true
            }
            
        
        }

        //sooooo whats happening is this is going before the https request. probably because of async.

        //SOMETHING FUCKY IS GOING ON HERE
        return (booleanhaha, nattend, npermit)
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
