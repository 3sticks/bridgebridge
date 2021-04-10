//
//  TrainerProfileViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/14/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class TrainerProfileViewController: UIViewController, UITextViewDelegate {//through the navigation controller, we open the picker controller to select an image
    
    //variable that stores trainer info passed via segue
    var trainer = NSDictionary()
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var instrumentsLabel: UILabel!
    
//    let username = user!["username"] as? String
//    let ava = user!["ava"] as? String
//    let name = user!["fullname"] as? String
//    let about = user!["about"] as? String
//
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self

        
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor(red: 106/255, green: 106/255, blue: 106/255, alpha: 0.25).cgColor
        textView.backgroundColor = UIColor.clear
        
        //make the profile image circular
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2

//
        //get trainer details passed by previous view
        let username = trainer["username"] as? String
        let ava = trainer["ava"] as? String
        let name = trainer["fullname"] as? String
        let about = trainer["about"] as? String
        let instrumentText = trainer["instrument"] as? String
        let experience = trainer["experience"] as? String
        //TODO let link = link (do the same thing you ddid for the trainer)
        
        
        //dont want user to edit textview here
        textView.isEditable = false
        //replacing occurences didnt work
        
        //assign values(s) -- right now just username. not putting emails and shit
        fullNameLabel.text = name //fixme do we need this if the username is the nav title?
        textView.text = about
        instrumentsLabel.text = instrumentText
        
        
        // get user profile picture
        if ava != "" {
            
            // url path to image
            let imageURL = URL(string: ava!)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.profileImage.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }
        
        
        //make the navigation title the username
        self.navigationItem.title = username

        // Do any additional setup after loading the view.
    }
    
    
    //TODO figure out if you need both of these. seem redundant??
    
//    //UPDATE ABOUT ME AND WHATEVER ELSE THE USER CHANGES
//    //view will appear works when pressing the back button, but thats stupid, because the back button is a cancel button.
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        //AHHH, have to reload the user variable, since it changed. Duh! You dumb fuck.
//        let about = user!["about"] as? String
//        let name = user!["fullname"] as? String
//        fullNameLabel.text = name
//        textView.text = about
//        //will user name need to be here?
//        let instrumentText = user!["instrument"] as? String
//        instrumentsLabel.text = instrumentText
//    }
//    //But, the save button wasnt impacting view will apear, so i said fuck it and added view did appear, and it worked. best practice? i dont know. facebook can figure it out when they buy the app.
//    override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(true)
//
//            //AHHH, have to reload the user variable, since it changed. Duh! You dumb fuck.
//            let about = user!["about"] as? String
//        let name = user!["fullname"] as? String
//        fullNameLabel.text = name
//            textView.text = about
//        let instrumentText = user!["instrument"] as? String
//        instrumentsLabel.text = instrumentText
//
//         //Your code here will execute after viewDidLoad() or when you dismiss the child viewController
//
//    }

    //to also allow camera one day
    //UIImagePickerController.SourceType.camera //https://stackoverflow.com/questions/54268856/upload-image-to-my-server-via-php-using-swift
    //https://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
