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
