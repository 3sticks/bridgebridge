//
//  EmailResestPopViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 2/23/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit

class EmailResestPopViewController: UIViewController {

    @IBOutlet weak var viewOut: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make it look more like a popup with blurred clear background
        viewOut.layer.cornerRadius = 22
        viewOut.clipsToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4) //play with the alpha to get the feeling right (i wore cologne)
        
        //show animate function
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        
        //i guess i want to show the close animate? we'll see lets try it
        //self.removeAnimate() //not necessary
        //this one goes back to the main screen
        //navigationController?.popToRootViewController(animated: true)
        
        //this option goes back to login (goes back to previous view controller... interestingly enough it goes to login screen and not the reset screen. not sure about why, but i love it) TODO one day which one is better??? i think going back to login
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //functions to make animation look cooler, thanks guy on the internet https://www.youtube.com/watch?v=FgCIRMz_3dE
    
    func showAnimate()
       {
           self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
           self.view.alpha = 0.0;
           UIView.animate(withDuration: 0.25, animations: {
               self.view.alpha = 1.0
               self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
           });
       }
    
    //not used right now
       
       func removeAnimate()
       {
           UIView.animate(withDuration: 0.25, animations: {
               self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
               self.view.alpha = 0.0;
               }, completion:{(finished : Bool)  in
                   if (finished)
                   {
                       self.view.removeFromSuperview()
                   }
           });
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
