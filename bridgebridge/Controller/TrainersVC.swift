//
//  TESTDELETE.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/13/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TrainersVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBurp: UISearchBar!
    
    
    //array of objects to store all user's information
    var users = [AnyObject]()//refactor this as Trainers? TODO
    var avas = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100.0
        //searchbar customization
        //dont worry about colors here, should follow global tint
        searchBurp.showsCancelButton = false //initially no cancel button
        doSearch(word: "")
    }
    
    //user starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //call search php request
        doSearch(word: searchBurp.text!)
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

        
        
        users.removeAll(keepingCapacity: false)
       // avas.removeAll(keepingCapacity: false)
        
        tableView.reloadData()
        
        doSearch(word: "") //show the whole party again
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
    func doSearch(word : String) {
        //data to pass
        let word = searchBurp.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) //get rid of whitespace?? yes, because they are stored as % in sql
        let username = user!["username"] as! String
        
        
        let url = URL(string: "https://mybridgeapp.com/trainers.php")!  // url path to trainers.php file
        
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
                       // self.avas.removeAll(keepingCapacity: false)
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
                        print(self.users.count)
                        
                        // for i=0; i < users.count; i++
                        for i in 0 ..< self.users.count {

                            // getting path to ava file of user
                            let ava = self.users[i]["ava"] as? String
                            print(ava)

                            // if path exists -> laod ava via path
                            if ava != ""{
                                print(ava)
                                let imgURL = URL(string: ava!)! // convert parth of str to url

                                guard let imageData = try? Data(contentsOf: imgURL) else {
                                    print(try? Data(contentsOf : imgURL))
                                    print("There was an error!")
                                    return
                                }
                                //let imageData = try? Data(contentsOf: url) // get data via url and assing to imageData
                                let image = UIImage(data: imageData)! // convert data of image via data imageData to UIImage
                                self.avas.append(image)

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
