//
//  TrainerLessonTableTableViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/18/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TrainerLessonTableTableViewController: UITableViewController {
    let datePicker2 = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        //i want the title to be clickable
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button


//        let datePicker = UIDatePicker()
//        datePicker.date = Date()
//        datePicker.locale = .current
//        datePicker.preferredDatePickerStyle = .compact
//        datePicker.datePickerMode = .date
//        navigationItem.titleView = datePicker
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        

    }
    func showDatePicker() {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .inline
        
        //datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        view.addSubview(datePicker)
    }
    // MARK: - Table view data source

    @objc func clickOnButton() {
        view.addSubview(datePicker2)

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainerlessonsched", for: indexPath) as! TrainerLessonCellTableViewCell

        // Configure the cell...
        //cell.price.text = "penis"
        //FULL is gold???
        //color literal gets you picker
        cell.backgroundColor = #colorLiteral(red: 0.8241059184, green: 0.7567040324, blue: 0.5418246388, alpha: 1)
        
        

        return cell
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
