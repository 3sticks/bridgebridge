////
////  FinalViewForNowViewController.swift
////  Bridge
////
////  Created by Hugo Bucci III on 10/26/20.
////  Copyright © 2020 Hugo Bucci III. All rights reserved.
////
//
//import UIKit
//
//
//class FinalViewForNowViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    @IBOutlet weak var messageTextField: UITextField!
//
//    var posts: [Post] = [
//    Post(sender: "sender1", body: "sht up"),
//    Post(sender: "2", body: "no")]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self //look to final view controller and trigger delegate methods (below) to get data
//        //tableView.delegate = self //to to self and see the user interact with cell MAYBE LIKE CLICKINGON A ROW LEADS TO THE POST?????
//        //want to hide the backbutton on the final screen
//        navigationItem.hidesBackButton = true
//
//        //register custom nib for use in the table view
//        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: K.reusableCell) //create messagecell in constants
//
//        //create a posts variable that is datatype Post struct
//        //fill array with post structs
//        //title = bridge?
//
//        // Do any additional setup after loading the view.
//    }
//
//    // MARK: - Navigation
//
////    // In a storyboard-based application, you will often want to do a little preparation before navigation
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        // Get the new view controller using segue.destination.
////        // Pass the selected object to the new view controller.
////    }
//    @IBAction func sendPressed(_ sender: Any) {
//        let messageBody = messageTextField.text //get the text that was entered into the text field
//        let messageSender = Auth.auth().currentUser?.displayName
//
//    }
//
//    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
//
//    //changed from whats on firebase site, just put auth.auth in the do
//        do {
//          try Auth.auth().signOut()
//        //if successful, go to login screen
//            //use nav controller to go back to main screen (not firebase code, firebase jus logs out)
//            navigationController?.popToRootViewController(animated: true)//animate???/yeah looks much better
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError) //why would there be an error? TODO try to create an error maybe
//        }
//
//
//    }
//
//}
//
//extension FinalViewForNowViewController: UITableViewDataSource {
//
//    //these are added automatically
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //how many rows???
//        return posts.count
//
//    }
//
//    //when tableview loads, it makes a request for data
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
//        UITableViewCell {//asking for UITable View Cell that it should display in each row
//        //create cell and return to table view
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath) as! MessageCell //cast as messagecell class
//            //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table. //option click to read more about it
//        //uses the reusable cell onject we created
//
//        //give cell data
//            //usese label iboutlet from xib
//            cell.label.text = posts[indexPath.row].body //so this takes the body of the post at the index path row and places it into cell
//        return cell
//    }
//
// }
//    //what happens when cell is interacted with?
//    //like which cell did the user interact with??? (GOOD FOR TODO LIST AND CHECKING THINGS OFF)
////TODO: might be good for when a user clicks on a post, to segue or something.
//
////    extension FinalViewForNowViewController: UITableViewDelegate{ //Methods for managing selections, configuring section headers and footers, deleting and reordering cells, and performing other actions in a table view.
////
////        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
////            }
////        }
////
//
//
//
//
////}
