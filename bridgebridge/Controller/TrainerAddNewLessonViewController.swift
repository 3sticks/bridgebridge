//
//  TrainerAddNewLessonViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 5/29/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TrainerAddNewLessonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var endTime: UIDatePicker!
//    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var innytextfield: UITextField!
    var pickerTime = Date()
    
    @IBOutlet weak var numberOfAtendees: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var lessonScrip: UITextView!
    
    @IBOutlet weak var attendeesError: UILabel!
    
    
    
    var pickerData: [String] = [String]()
    let innypicker = UIPickerView()
    let placeHolderText = "Tell the people what this lesson is all about. What are you doing? What are you hoping to accomplish? Are you teaching a ballad, chord changes from G to D? Keep it clean, simple, and appealing. This is your chance to sell it. "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //HIDE THE KEYBOARD WHEN TAPPED
        
        //deal with keyboard moving view 
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        self.innypicker.delegate = self
        //self.innypicker.dataSource = self
        
        //hide the errors
        attendeesError.isHidden = true
        
        innytextfield.inputView = innypicker //make the input be the picker, hell yeah

        // Do any additional setup after loading the view.
        //picker date //TODO maybe have this pull from their "instruments" section on their profile???
        pickerData = ["", "Acoustic Guitar", "Electric Guitar", "Bass Guitar", "Piano","Ukelele", "Other"] //not an exhaustive list
        
        //cant go back in time Doc you sneaky motherfucker
        datePicker.minimumDate = Date() //date() is today
        
        
        //the end date cant be less than 15 minutes after the start time. ill allow short 15 minuters, but nothing less.
        pickerTime = datePicker.date
        let add15Mins = Calendar.current.date(byAdding: .minute, value: 15, to: pickerTime)
        endTime.minimumDate = add15Mins
        
        
        //add done button to picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
      //  let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      //  let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        //add to all the necessary shit 
        innytextfield.inputAccessoryView = toolBar
        numberOfAtendees.inputAccessoryView = toolBar // add done to attendees
        price.inputAccessoryView = toolBar
        lessonScrip.inputAccessoryView = toolBar
        
    
        
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        //dismiss this bitch 
        self.dismiss(animated: true, completion: nil)

    }
    @objc func donePicker (){
        //i think you can add all these here no problem. i think
        innytextfield.endEditing(true)
        numberOfAtendees.endEditing(true)
        price.endEditing(true)
        lessonScrip.endEditing(true)
    }
    
    @IBAction func stopEditingAttendPermit(_ sender: Any) {
        if numberOfAtendees.text != ""{ //if they stopped editing it and its not blank
            
            let numbees = String(numberOfAtendees.text!)
            if numbees.isInt { //if it IS an int, make sure its less than thirty
                if Int(numbees)! >= 30 {
                    attendeesError.isHidden = false
                    self.attendeesError.shake() //use the shake extension
                    //self.userNameTextField.backgroundColor = UIColor.red
                    self.numberOfAtendees.layer.borderColor = UIColor.red.cgColor
                    self.numberOfAtendees.layer.borderWidth = 1.0
                    //show the error label
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    //i want get lessons to run when this view goes away, so new lessons added same day will show up
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if let firstVC = presentingViewController as? CustomShitViewController {
                DispatchQueue.main.async {
                    firstVC.tableVIew.reloadData()
                }
            }
        }
    

    
    
    @IBAction func save(_ sender: Any) {
        
        //get the user ID
        let id = user!["id"] as? String
        
        let df = DateFormatter()
        df.dateFormat = "MM-d-yyyy"
//        df.dateStyle = DateFormatter.Style.short
        let strtDate = df.string(from: datePicker.date)
        let endDateStr = df.string(from: endTime.date)
        
        
        let strtDate2 = strtDate.replacingOccurrences(of: "\\", with: "-")
        let endDateStr2 = endDateStr.replacingOccurrences(of: "\\", with: "-")
        print(strtDate2)
        
        let date = self.datePicker.date
        let endDate = self.endTime.date
        let startTimeDisplay = date.dateStringWith(strFormat: "hh:mm a")
        print(startTimeDisplay)
        let endTimeDisplay = endDate.dateStringWith(strFormat: "hh:mm a")
        print (startTimeDisplay)
        
//        //i want to get the LENGTH of the lesson, so ill need military time.
//        let startTimeMath = date.dateStringWith(strFormat: "HH:mm a")
//        print(startTimeMath)
//        let endTimeMath = endDate.dateStringWith(strFormat: "HH:mm a")
//        print (endTimeMath)
        
        //Better option... get length, so get minutes from midnight for both. borrow logic from Time Lorde
        let calendar = Calendar.current
        let startMinutes = calendar.component(.hour, from: date) * 60 + calendar.component(.minute, from: date)
        let endMinutes = calendar.component(.hour, from: endDate) * 60 + calendar.component(.minute, from: endDate)
        
        var length = Int()
        
        //if lesson passes midnight, end time will be less than start time
        if endMinutes < startMinutes{
            length = endMinutes - startMinutes + 1440

        } else {
            length = endMinutes - startMinutes
        }
        print(length)
        
        //unique lesson id is the trainer ID, the start time, and the date. this is going to be unique in the database, so a trainer cant make a leson that starts at the same time on the same date also its used for pulling lesson info
        let uniqueID = id!+strtDate+startTimeDisplay
        
        print(datePicker.date)
        print(endTime.date)
        print(innytextfield.text)
        print(numberOfAtendees.text)
        print(price.text)
        let desssssy = "poop"
        print(strtDate)
        print(endDateStr)
        
        
        let url = URL(string: "https://mybridgeapp.com/newlesson.php")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        //    public function createLesson($id, $datey, $starttime, $endtime, $lessonlength, $instrument, $numpermitted, $price, $description)
        let body = "datey=\(strtDate2)&starttime=\(startTimeDisplay)&endtime=\(endTimeDisplay)&lessonlength=\(length)&instrument=\(innytextfield.text!)&numpermitted=\(numberOfAtendees.text!)&price=\(price.text!)&description=\(desssssy)&uniqueid=\(uniqueID)&id=\(id!)"
        print(body)
        
        request.httpBody = body.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
        
                DispatchQueue.main.async(execute: {
                    
                    do {
                        // get json result
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary //data is in a dictionary form -- you know what that means
                        
                        // assign json to new var parseJSON in guard/secured way
                        guard let parseJSON = json else { ///guard is a safety method  if parse is not equal to json, break and present error
                            print("Error while parsing")
                            return
                        }
                        
                        print(parseJSON)
                        let lesson = parseJSON["uniqueid"] //get the about text
                        
                        // successfully registered
                        if lesson != nil {

//                            // save user information we received from our host
//                             UserDefaults.standard.set(parseJSON, forKey: "parseJSON")//save
//                             user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable
//
                            print(parseJSON)
                            
                        }
                       
                    } catch {
                           
                           print("Caught an error \(error)")

                       }
               })
               
            }else {
               
               print(error)
           }
                            
                       
                        }.resume()

        //adding this here instad of

        self.dismiss(animated: true, completion: nil)
        

        
        
    }
    
    
    //MARK - PICKER DATA

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        innytextfield.text = pickerData[row]
    }

    
    
    @IBAction func startTimeChanged(_ sender: Any) {
        
        //when the date changes, also need to update picker time in order to update the end time
        pickerTime = datePicker.date
        //if it changes, reload pickertime
        let add60Mins = Calendar.current.date(byAdding: .minute, value: 60, to: pickerTime)
        //min date is add15, but make it easy for the people and set it ... you know what? set it to an hour. let them make it 15, but set it to an hour by defualt. we make more money that way
        endTime.date = add60Mins!
        
    }
    
    
    
    //MARK: - Deal with keyboard moving view
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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

//check if string is int
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
// Extension of Date
      extension Date {
       func dateStringWith(strFormat: String) -> String {
              let dateFormatter = DateFormatter()
              dateFormatter.timeZone = Calendar.current.timeZone
              dateFormatter.locale = Calendar.current.locale
              dateFormatter.dateFormat = strFormat
              return dateFormatter.string(from: self)
          }
      }
