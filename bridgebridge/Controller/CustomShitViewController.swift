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
    var strDateDash = ""
    var lessons = [AnyObject]()
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
        self.tableVIew.rowHeight = 120.0
        // Do any additional setup after loading the view.
        //test
        //COLORS ARE SET IN THE SIDE BAR. I HAVE MADE IT CLEAR
//        datePicker?.locale = Locale(identifier: "")
        if #available(iOS 14.0, *) {
            datePickerha.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        
        //off the bat, set title to be collapse -- since were setting picker to be inline
//        expColl.setTitle("Collapse", for: .normal)
         
        
        getDate()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeRight.direction = .left
           self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeLeft.direction = .right
           self.view.addGestureRecognizer(swipeLeft)
        
        getLessons()

        print(user!["id"])

    }
    override func viewDidAppear(_ animated: Bool) {
        getLessons()
        print("view did appear")
    }

    override func viewWillAppear(_ animated: Bool) {
        getLessons()
        print("view will appear")
    }
    


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! RenameThisIfItWorksTVCell

           // Configure YourCustomCell using the outlets that you've defined.
        let lesson = lessons[indexPath.row]
        let lessonDate = lesson["datey"] as? String
        let instrument = lesson["instrument"] as? String
        let lessonstart = lesson["starttime"] as? String
        let lessonend = lesson["endtime"] as? String
        let lessontype = lesson["lessontype"] as? String
        let attending = lesson["numattending"] as? Int
        let permitted = lesson["numpermitted"] as? Int
        //cell.testLabel.text = lessonDate
        cell.instrumentlabel.text = instrument
        cell.combinedTime.text = "\(lessonstart!)-\(lessonend!)"
        cell.attendees.text = "\(lessontype!) \(attending!)/\(permitted!)"
        
        //i want something like if attending = permitted color it gold. 
    

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
        getLessons() //need to add get lessons here numbnuts -- or just put it in get date?????
    }
    
    //changes title of nav bar and also stores date as a string
    func getDate() {
        let df = DateFormatter()
        df.dateStyle = DateFormatter.Style.short
//        df.dateFormat = "MM-d-yyyy"
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
        
        let dfDash = DateFormatter()
        dfDash.dateStyle = DateFormatter.Style.short
        dfDash.dateFormat = "MM-d-yyyy"
        strDateDash = dfDash.string(from: datePickerha.date)



    }
    
    func getLessons() {
        //data to pass
        print(strDate)
//        let datey = strDate.replacingOccurrences(of: "\\", with: "-") //get rid of whitespace?? yes, because they are stored as % in sql
        let datey = strDateDash
        print(datey)
        let id = user!["id"] as! String //need to pass the username so it doesnt pull your own username
        
        
        let url = URL(string: "https://mybridgeapp.com/deep/dive/do0d/getlessons.php")!  // url path to trainers.php file
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        //add bio info and id to body
        let body = "datey=\(datey)&id=\(id)" //username and word being passed
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
                        self.tableVIew.reloadData()
                        
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
                        self.tableVIew.reloadData()
                        
                        
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

