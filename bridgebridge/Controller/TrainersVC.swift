//
//  TrainersVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/13/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

//TODO add in the link 
class TrainersVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBurp: UISearchBar!
    
    
    //array of objects to store all user's information
    var users = [AnyObject]()//refactor this as Trainers? TODO
    var avas = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 120.0
        //searchbar customization
        //dont worry about colors here, should follow global tint
        searchBurp.showsCancelButton = false //initially no cancel button
        doSearch("")
    }
    
    //user starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //call search php request
        doSearch(searchBurp.text!)
    }
    
    //click in search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBurp.showsCancelButton = true
    }
    //clicked cancel button (native search bar function)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //remove all text and show all users (for now)
        searchBurp.endEditing(false)//remove keyboard
        searchBurp.showsCancelButton = false
        searchBurp.text = ""//empty out the search bar

        
        //i dont think i like this........
        users.removeAll(keepingCapacity: false)
       avas.removeAll(keepingCapacity: false)
        
        tableView.reloadData()
        
        doSearch("") //show the whole party again
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    }
    //

    // MARK: - Table view data source

//    //keep for now
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    //cell number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count//returning ALL users for now.... but TODO change this to be a certain number? like the top 10?
    }

    
    //cell configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainersID", for: indexPath) as! trainers
        

        //get one by one users (trainers)
        let user = users[indexPath.row]
        let ava = avas[indexPath.row]
        
        
        let username = user["username"] as? String
        let fullname = user["fullname"] as? String
        let instrument = user["instrument"] as? String
        
        //fill in user info
        cell.fullname.text = fullname
        cell.username.text = username
        cell.instrument.text = instrument
        cell.pitcher.image = ava
        // Configure the cell...

        return cell
    }
    
    //search/retrieve users
    func doSearch(_ word : String) {
        //data to pass
        let word = searchBurp.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) //get rid of whitespace?? yes, because they are stored as % in sql
        let username = user!["username"] as! String
        
        
        let url = URL(string: "https://mybridgeapp.com/deep/dive/do0d/trainers.php")!  // url path to trainers.php file
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        //add bio info and id to body
        let body = "word=\(word)&username=\(username)" //username and word being passed

        request.httpBody = body.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
        
                DispatchQueue.main.async(execute: {
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                        
                        
                        //cleanup
                        self.users.removeAll(keepingCapacity: false)
                        //this is needed so the rows dont stay the same... if row one at started has flowers, and you search, the person who moves to row one will have flowers 
                        self.avas.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                            print("Error while parsing")
                            return
                        }
                        
                        // declare new secure vat to store $returnArray["users"]
                        guard let parseUSERS = parseJSON["users"] else {
                            print(parseJSON["message"] ?? [NSDictionary]())
                            return
                        }
                        
                        print(parseUSERS)
                        //store users in array
                        self.users = parseUSERS as! [AnyObject]
                        
                        // for i=0; i < users.count; i++
                        for i in 0 ..< self.users.count {

                            // getting path to ava file of user
                            let ava = self.users[i]["ava"] as? String
                            print(ava)

                            // if path exists -> laod ava via path
                            if !ava!.isEmpty {
                                let url = URL(string: ava!)! // convert parth of str to url
                                let imageData = try? Data(contentsOf: url) // get data via url and assing to imageData
                                
                                //AHA! I HAVE CONQUERED THE BEAST. future me: on 3/13, i was having major issues with imagedata coming back nil and crashing the app. it took me way too long to figure out why.
                                //somehow, a profile image link was added to the database, but the file was not uploaded to the folder. a weird error, but definitely something to check for. to combat this in the future,
                                //im putting in this little if function... if imagedate is nil, it means theres no profile picture in the directory, so pop in a placeholder instead of crashing everyones app. some crazy
                                //shit might happen where all the profile pictures get destroyed, but you still want the app to run. i worked on this for 8 hours. i was cranky with sara and frank because of it. i am so mad.
                                //BUT it is fixed.
                                //for now.
                                
                                if imageData == nil{
                                    
                                    let image = UIImage(named: "wizzr.jpg")
                                    self.avas.append(image!)
                                    
                                } else {
                                let image = UIImage(data: imageData!)! // convert data of image via data imageData to UIImage
                                self.avas.append(image)
                                }

                            // else use placeholder for ava
                            } else {
                                let image = UIImage(named: "wizzr.jpg")
                                self.avas.append(image!)
                            }

                        }
                        
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

    //proceeding segue to trainer view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        //check if cell exists or if we pressed a cell
        if let cell = sender as? UITableViewCell {
            
            // define index to later on pass exact guest user related info
            let index = tableView.indexPath(for: cell)!.row
            
            // if segue is trainer which it is ...
            if segue.identifier == "trainer" {
                
                // call trainerprofile to access trainerprofile
                let TrainerProfile = segue.destination as! TrainerProfileViewController
                
                //  assign trainer info to the trainer var in trainerVC
                TrainerProfile.trainer = users[index] as! NSDictionary
                
                // new back button
//                let backItem = UIBarButtonItem()
//                backItem.title = ""
//                navigationItem.backBarButtonItem = backItem
                
            }
            
        }
        
    }


}
