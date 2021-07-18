//
//  OpenTokVideoVC.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 7/18/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import OpenTok


//OpenTok API key
var kApiKey = "47281584"
//session ID
var kSessionId = "2_MX40NzI4MTU4NH5-MTYyNjY0MzE5NDUxN35aZTlPYmdnWnd2bElWM2hVSWVxT0dwRFJ-fg"
//token
var kToken = "T1==cGFydG5lcl9pZD00NzI4MTU4NCZzaWc9NDliNzJkMjE4ZGQ0MzA5ZjI0OGNiNmE3NGNhNDdjNDg5MGNhYzdjYjpzZXNzaW9uX2lkPTJfTVg0ME56STRNVFU0Tkg1LU1UWXlOalkwTXpFNU5EVXhOMzVhWlRsUFltZG5XbmQyYkVsV00yaFZTV1Z4VDBkd1JGSi1mZyZjcmVhdGVfdGltZT0xNjI2NjQzMzAzJm5vbmNlPTAuMjkxNzQ0MTU2ODkxNDUwNyZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNjI5MjM1MzAzJmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"

class OpenTokVideoVC: UIViewController {
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectToAnOpenTokSession()

        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
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


// MARK: - OTSessionDelegate callbacks
extension OpenTokVideoVC : OTSessionDelegate {
   func sessionDidConnect(_ session: OTSession) {
    
    let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        guard let publisher = OTPublisher(delegate: self, settings: settings) else {
            return
        }

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
