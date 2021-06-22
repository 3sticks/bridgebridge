//
//  VIdeoChatViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/20/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//https://stackoverflow.com/questions/43714948/draggable-uiview-swift-3


//https://medium.com/agora-io/how-to-create-an-ios-or-macos-video-streaming-application-with-a-few-lines-of-code-8dac963934bb

//https://www.agora.io/en/blog/quickstart-with-agora-uikit-for-ios/

//https://ashok-b.medium.com/getting-started-with-agora-ios-d2197bcdada8

import UIKit
//import AgoraRtcKit
import AgoraUIKit_iOS

//let AppID: String = “Your-App-ID”


class VIdeoChatViewController: UIViewController {
    @IBOutlet weak var videoView: AgoraVideoViewer!
    @IBOutlet weak var styleToggle: UISegmentedControl!
    @IBOutlet weak var videooview: UIView!
    var agoraView: AgoraVideoViewer!
    override func viewDidLoad() {
      super.viewDidLoad()
        

        var agSettings = AgoraSettings()
//        agSettings.enabledButtons = [
//        ]
//        agSettings.buttonPosition = .left
        
        
        self.agoraView = AgoraVideoViewer(
        connectionData: AgoraConnectionData(
          appId: AppID,
          appToken: "006f2952c72fcca4ce288c430cbc4a8f164IADK2vxldsAPaJrWjxv8iXRZNUoGfzdJVfzGezdLHymyawx+f9gAAAAAEACX33iMw0XSYAEAAQDDRdJg"
        ),
            
        agoraSettings: agSettings,
        //THIS IS WHAT THEY MEAN BY SETTING THE FUCKING DELEGATE
        delegate: self
      )
        

        agoraView.fills(view: videooview) //fill in the view you created. i thought of this all by myself.
//        agoraView.style = .floating // or .floating
      // join the channel "test"
        agoraView.join(channel: "test", as: .broadcaster)
        
        self.styleChange(self.styleToggle)
        self.view.bringSubviewToFront(self.styleToggle)
        
        
    }
    
    func leaveChannel() {
        agoraView.leaveChannel()
        }

    
    @IBAction func styleChange(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
        agoraView.style = .floating
    } else {
        agoraView.style = .grid
    }
    }

override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    leaveChannel()
}
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    leaveChannel()
}

    override func viewWillAppear(_ animated: Bool) {
        agoraView.join(channel: "test", as: .broadcaster)
    }

}


//for the hang up button
extension VIdeoChatViewController: AgoraVideoViewerDelegate {
  func extraButtons() -> [UIButton] {
    let button = UIButton()
    button.setImage(UIImage(
      systemName: "phone.down.fill",
      withConfiguration: UIImage.SymbolConfiguration(scale: .large)
    ), for: .normal)
    button.addTarget(
      self,
      action: #selector(self.clickedBolt),
      for: .touchUpInside
    )
    button.backgroundColor = .systemRed
    return [button]
  }
  @objc func clickedBolt(sender: UIButton) {
    print("zap!")
    sender.isSelected.toggle()
    sender.backgroundColor = sender.isSelected ?
      .systemYellow : .systemGray
    
    
    let alert = UIAlertController(title: "Are you sure you want to leave?", message: "I added this in case you pressed hang up by accident.", preferredStyle: .alert)
    
    //destructive style highlights it red
    let yes = UIAlertAction(title: "Leave", style: .destructive, handler: { (action) -> Void in
        print("yes")
        self.agoraView.leaveChannel()
        //send the user to the lesson page
        
     })
    
    let no = UIAlertAction(title: "Stay", style: .cancel, handler: { (action) -> Void in
        print("cancel")
        
//                    if let firstViewController = self.navigationController?.viewControllers. {
//                        self.navigationController?.popToViewController(firstViewController, animated: true)
//                    }
        //go back one view  (back to the trainer lesson page)
//        self.navigationController?.popViewController(animated: true)
        
        //send the user back to the trainer page
     })
    
    //Add OK button to a dialog message
    alert.addAction(yes)
    alert.addAction(no)

    self.present(alert, animated: true)

  }
}

