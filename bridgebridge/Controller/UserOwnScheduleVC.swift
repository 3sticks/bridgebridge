//
//  UserOwnScheduleVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/19/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class UserOwnScheduleVC: UITableViewController {

    var lessons = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120.0

        getLessons()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getLessons()
        print("view did appear")
    }

    override func viewWillAppear(_ animated: Bool) {
        getLessons()
        print("view will appear")
    }

    // MARK: - Table view data source

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userviewownsched") as! UserViewOwnSchedCell

           // Configure YourCustomCell using the outlets that you've defined.
        let lesson = lessons[indexPath.row]
        let lessonDate = lesson["datey"] as? String
        let instrument = lesson["instrument"] as? String
        let lessonstart = lesson["starttime"] as? String
        let lessonend = lesson["endtime"] as? String
        let lessontype = lesson["lessontype"] as? String
        let attending = lesson["numattending"] as? Int
        let permitted = lesson["numpermitted"] as? Int
        let trainer = lesson["username"] as? String
        //cell.testLabel.text = lessonDate
        cell.instrument.text = instrument
        cell.time.text = "\(lessonstart!)-\(lessonend!)"
        cell.trainer.text = "With: \(trainer!)" //just show their id for now
        cell.date.text = lessonDate
        
        
        //i want something like if attending = permitted color it gold.
//        @IBOutlet weak var date: UILabel!
//        @IBOutlet weak var instrument: UILabel!
//        @IBOutlet weak var trainer: UILabel!
//        @IBOutlet weak var time: UILabel!

        return cell
    }
    
    func getLessons() {
        //data to pass
//        let datey = strDate.replacingOccurrences(of: "\\", with: "-") //get rid of whitespace?? yes, because they are stored as % in sql
        let id = user!["id"] as! String //need to pass the username so it doesnt pull your own username
        let url = URL(string: "https://mybridgeapp.com/deep/dive/do0d/getuserlessons.php")!  // url path to trainers.php file
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        //add  id to body
        let body = "id=\(id)" //id is being passed
        print(body)

        request.httpBody = body.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
        
                DispatchQueue.main.async(execute: {
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                        
                        
                        //cleanup
                        self.lessons.removeAll(keepingCapacity: false)
                        //this is needed so the rows dont stay the same... if row one at started has flowers, and you search, the person who moves to row one will have flowers
                        self.tableView.reloadData()
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                            print("Error while parsing")
                            return
                        }
                        
                        guard let parseLESSSONS = parseJSON["lessons"] else {
                            print(parseJSON["message"] ?? [NSDictionary]())
                            return
                        }
                        
                        print(parseLESSSONS)
                        //store users in array
                        self.lessons = (parseLESSSONS as? [AnyObject])!
                        
                        
                        //reload tableview
                        self.tableView.reloadData()
                        
                        
                        // successfully registered
//                        if about != nil {
//
//                            // save user information we received from our host
//                             UserDefaults.standard.set(parseJSON, forKey: "parseJSON")//save
//                             user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable
//
//                            print(parseJSON)
//
//                        }
                       
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
