//
//  OpenTokVideoVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 7/18/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import OpenTok

//ISSUES
//
//If one user leaves and then comes back, theyre frozen. other user has to reset. 
//


//OpenTok API key
var kApiKey = ""
//session ID
var kSessionId = ""
//token
var kToken = ""




var showbutton = true




class OpenTokVideoVC: UIViewController {
    

    
    //channel that gets passed
    var channel = ""
    
    @IBOutlet weak var buttonstack: UIStackView!
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    
    //start off with mike not muted
    var ismikemuted = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //mike starts hot
        
        
        leaveButton.layer.cornerRadius = leaveButton.frame.size.width/2
        leaveButton.clipsToBounds = true
        micButton.layer.cornerRadius = leaveButton.frame.size.width/2
        micButton.clipsToBounds = true
//        connectToAnOpenTokSession()
        
        self.tabBarController?.tabBar.isHidden = true
        
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        //url with channel passed
        let urlurl = "https://bridgeyboy.herokuapp.com/room/\(channel)"
        
        let url = URL(string: urlurl)
        let dataTask = session.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in

            guard error == nil, let data = data else {
                print(error!)
                return
            }

            let dict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
            kApiKey = dict?["apiKey"] as? String ?? ""
            kSessionId = dict?["sessionId"] as? String ?? ""
            kToken = dict?["token"] as? String ?? ""
            self.connectToAnOpenTokSession()
        }
        dataTask.resume()
        session.finishTasksAndInvalidate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnScreen(_ sender: Any) {
        
        if buttonstack.isHidden == true{
            buttonstack.isHidden = false

        } else{

            //see below my thoughts on animation
//            let duration: TimeInterval = 1.0
//                    UIView.animate(withDuration: duration, animations: {
//                        self.leaveButton.frame.origin.y = 50
//                        }, completion: nil)
            buttonstack.isHidden = true

        }
        
        

        
        // one day make the fucking animation cool but how about right now yo just work on the fuckin app you dumb fuck
        //ok
////        https://stackoverflow.com/questions/27361964/moving-a-button-vertically-swift
//        if showbutton == true{
//
//            let duration: TimeInterval = 1.0
//                    UIView.animate(withDuration: duration, animations: {
//                        self.leaveButton.frame.origin.y = 50
//                        }, completion: nil)
//
//            showbutton = false
//
//        } else {
//
//            leaveButton.isHidden = true
////            let duration: TimeInterval = 1.0
////                    UIView.animate(withDuration: duration, animations: {
////                        self.leaveButton.frame.origin.y = -50
////                        }, completion: nil)
//
//            showbutton = true
//
//
//        }
        
    }
    
    
    //if the user leaves and comes back, view doesnt load it appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        }
    
    
    
    //this is me flying solo here
    @IBAction private func leave() {
        
        
        
        let alert = UIAlertController(title: "Are you sure you want to leave?", message: "I added this in case you pressed hang up by accident.", preferredStyle: .alert)
        
        //destructive style highlights it red
        let yes = UIAlertAction(title: "Leave", style: .destructive, handler: { (action) -> Void in
            print("yes")
            var error: OTError?
            self.session?.disconnect(&error)

            if let error = error {
              print("An error occurred disconnecting from the session", error)
            } else {
//                self.navigationController?.popViewController(animated: true)
            }
            //send the user to the lesson page
            //self.navigationController!.popViewController(animated: true)

            
         })
        
        let no = UIAlertAction(title: "Stay", style: .cancel, handler: { (action) -> Void in
            print("cancel")
            

         })
        
        //Add OK button to a dialog message
        alert.addAction(yes)
        alert.addAction(no)

        self.present(alert, animated: true)
        
        

    }
    
    
    @IBAction func muteMike(_ sender: Any) {
        
        
        let settings = OTPublisherSettings()
            settings.name = UIDevice.current.name
            guard let publisher = OTPublisher(delegate: self, settings: settings) else {
                return
            }

        //this doesnt update the other users screen
        
        publisher.cameraPosition = .back
        var error: OTError?
    session!.publish(publisher, error: &error)
        guard error == nil else {
            print(error!)
            return
        }

        guard let publisherView = publisher.view else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        publisherView.frame = CGRect(x: screenBounds.width - 150 - 20, y: screenBounds.height - 150 - 20, width: 150, height: 150)
        view.addSubview(publisherView)

//THEY DONT TELL YOU YOU NEED TO ADD ALL THIS FUCKING SHIT AT THE END

        
    }
    
    //maybe put it in here???
    func publisher(_ publisher: OTPublisher, didChangeCameraPosition position: AVCaptureDevice.Position) {
        if position == .front {
            // front camera
        } else {
            print("CAMERA IS BACK CAMERA MOTHERFUCKER")

        }
    }
    
    
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    

}


// MARK: - OTSessionDelegate callbacks
extension OpenTokVideoVC : OTSessionDelegate {
   func sessionDidConnect(_ session: OTSession) {
    
    let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
    settings.cameraResolution = .high
    settings.cameraFrameRate = .rate30FPS
        guard let publisher = OTPublisher(delegate: self, settings: settings) else {
            return
        }

    
    
    
//    AVCaptureDevice.requestAccess(for: .video) { granted in
//        if granted {
//            // Access to the camera is granted. You can publish.
//        } else {
//            // Access to the camera is not granted.
//        }
//    }
    

        var error: OTError?
        session.publish(publisher, error: &error)
        guard error == nil else {
            print(error!)
            return
        }

        guard let publisherView = publisher.view else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        publisherView.frame = CGRect(x: screenBounds.width - 150 - 20, y: screenBounds.height - 150 - 20, width: 150, height: 150)
        view.addSubview(publisherView)
    
    
    
       print("The client connected to the OpenTok session.")
   }

   func sessionDidDisconnect(_ session: OTSession) {
       print("The client disconnected from the OpenTok session.")
   }

   func session(_ session: OTSession, didFailWithError error: OTError) {
       print("The client failed to connect to the OpenTok session: \(error).")
   }

   func session(_ session: OTSession, streamCreated stream: OTStream) {
    subscriber = OTSubscriber(stream: stream, delegate: self)
     guard let subscriber = subscriber else {
         return
     }

     var error: OTError?
     session.subscribe(subscriber, error: &error)
     guard error == nil else {
         print(error!)
         return
     }

     guard let subscriberView = subscriber.view else {
         return
     }
     subscriberView.frame = UIScreen.main.bounds
     view.insertSubview(subscriberView, at: 0)
   }

   func session(_ session: OTSession, streamDestroyed stream: OTStream) {
       print("A stream was destroyed in the session.")
   }
}


// MARK: - OTPublisherDelegate callbacks
extension OpenTokVideoVC: OTPublisherDelegate {
   func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
       print("The publisher failed: \(error)")
   }
}

// MARK: - OTSubscriberDelegate callbacks
extension OpenTokVideoVC: OTSubscriberDelegate {
   public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
       print("The subscriber did connect to the stream.")
   }

   public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
       print("The subscriber failed to connect to the stream.")
   }
}
