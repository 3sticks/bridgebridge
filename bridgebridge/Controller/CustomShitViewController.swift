//
//  CustomShitViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/26/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import DatePickerDialog

class CustomShitViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
    @IBOutlet var expColl: UIButton!
    
    var strDate = ""
    
    @IBOutlet var scrollypollyollu: UIScrollView!
    @IBOutlet var datePickerha: UIDatePicker!
    @IBOutlet var dateButton: UIButton!
    private var datePicker : UIDatePicker?
    
    

    @IBOutlet weak var tableVIew: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    var date = Date()
    var dateString = ""
    
    //scheduleCell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "Schedule"
        // Do any additional setup after loading the view.
        //test
        //COLORS ARE SET IN THE SIDE BAR. I HAVE MADE IT CLEAR
//        datePicker?.locale = Locale(identifier: "")
        datePickerha.preferredDatePickerStyle = .inline
        
        //off the bat, set title to be collapse -- since were setting picker to be inline
//        expColl.setTitle("Collapse", for: .normal)
         
        
        getDate()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeRight.direction = .left
           self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeLeft.direction = .right
           self.view.addGestureRecognizer(swipeLeft)
        




    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! RenameThisIfItWorksTVCell

           // Configure YourCustomCell using the outlets that you've defined.
        
        cell.testLabel.text = strDate
    

        return cell
    }
    

    
    //when user swipes on the table view (doesnt affect the user swiping the calendar)
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                let pickerDate = datePickerha.date
                let pickerDatePlusOneDay = Calendar.current.date(byAdding: .day, value: -1, to: pickerDate)
                print(pickerDatePlusOneDay)
//                var newDate =
                datePickerha.setDate(pickerDatePlusOneDay!, animated: true)
                getDate()
            case .down:
                print("Swiped down")
            case .left: //left means we want to go one day in the future
                let pickerDate = datePickerha.date
                let pickerDatePlusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: pickerDate)
                print(pickerDatePlusOneDay)
//                var newDate =
                datePickerha.setDate(pickerDatePlusOneDay!, animated: true)
                getDate()
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    //if the date changes, run get date function
    @IBAction func dateChanged(_ sender: Any) {
        getDate()
    }
    
    //changes title of nav bar and also stores date as a string
    func getDate() {
        let df = DateFormatter()
        df.dateStyle = DateFormatter.Style.short
        strDate = df.string(from: datePickerha.date)


        let today = df.string(from: date)
        let tom = df.string(from: Date().dayAfter)
        let yes = df.string(from: Date().dayBefore)


        print(today)
        print(tom)
        print(yes)
        if strDate == today{
            self.navigationItem.title = "Today"
        } else if strDate == tom{
            self.navigationItem.title = "Tomorrow"
        } else if strDate == yes {
            self.navigationItem.title = "Yesterday"
        } else {

            self.navigationItem.title = strDate
        }

        tableVIew.reloadData()

        print(user)


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

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
extension UIView {
    func loopDescendantViews(_ closure: (_ subView: UIView) -> Void) {
        for v in subviews {
            closure(v)
            v.loopDescendantViews(closure)
        }
    }
}

