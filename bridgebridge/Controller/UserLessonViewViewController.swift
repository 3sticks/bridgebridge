//
//  UserLessonVIewViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/20/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class UserLessonViewViewController: UIViewController {
    //being passed by segue
    var lesson = NSDictionary()
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var trainer: UILabel!
    
    @IBOutlet weak var instrument: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(lesson)
        
        let instrumenty = lesson["instrument"] as? String
        let lessonstart = lesson["starttime"] as? String
        let lessonend = lesson["endtime"] as? String
        let datey = lesson["datey"] as? String
        let trainusername = lesson["username"] as? String
        
        
        
        time.text = "Time: \(lessonstart!)-\(lessonend!)"
        date.text = datey
        trainer.text = "Learning with: \(trainusername!)"
        instrument.text = instrumenty
        
        print("UniqueIDForThisLesson : \(lessonstart!)-\(lessonend!) : \(datey)")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //all this shit needs to be in view did appear too i htink
        super.viewWillAppear(true)
        let instrumenty = lesson["instrument"] as? String
        let lessonstart = lesson["starttime"] as? String
        let lessonend = lesson["endtime"] as? String
        let datey = lesson["datey"] as? String
        let trainusername = lesson["username"] as? String
        
        
        
        time.text = "Time: \(lessonstart!)-\(lessonend!)"
        date.text = datey
        trainer.text = "Learning with: \(trainusername!)"
        instrument.text = instrumenty
        print("UniqueIDForThisLesson : \(lessonstart!)-\(lessonend!) : \(datey)")
        
        
        }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func joinLessson(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "videochatOT") as! OpenTokVideoVC
        vc.channel = "POOP"     
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        self.present(vc, animated: true, completion: nil)
//        performSegue(withIdentifier: "TOVIDEO", sender: self)
        navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    
    
    
    
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        //check if cell exists or if we pressed a cell
//        if let cell = sender as? UITableViewCell {
//
//            if segue.identifier == "gotolesson" {
//
//                // call trainerprofile to access trainerprofile
//                let LessonSelect = segue.destination as! UserSelectedLessonVC
//
//                //  assign trainer info to the trainer var in trainerVC
//
//                //pass all of the lesson info thats pulled from the cell row index to the lesson NS dictionary variable on the lesson screen
//                LessonSelect.lesson = lessons[index] as! NSDictionary
//
//                // new back button
////                let backItem = UIBarButtonItem()
////                backItem.title = ""
////                navigationItem.backBarButtonItem = backItem
//
//            }
//
//        }
//
//    }
    

}
