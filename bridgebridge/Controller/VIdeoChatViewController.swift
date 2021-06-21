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
    var agoraView: AgoraVideoViewer!
    

    override func viewDidLoad() {
      super.viewDidLoad()
      self.agoraView = AgoraVideoViewer(
        connectionData: AgoraConnectionData(
          appId: AppID,
          appToken: "006f2952c72fcca4ce288c430cbc4a8f164IADK2vxldsAPaJrWjxv8iXRZNUoGfzdJVfzGezdLHymyawx+f9gAAAAAEACX33iMw0XSYAEAAQDDRdJg"
        )
      )
        
        var agSettings = AgoraSettings()
        agSettings.enabledButtons = .cameraButton
      // fill the view
        self.agoraView.fills(view: self.view)
        agoraView.style = .floating // or .floating
      // join the channel "test"
      agoraView.join(channel: "test", as: .broadcaster)
    }
    
    @IBAction func leave(_ sender: Any) {
        
        leaveChannel()
    }
    func leaveChannel() {
        agoraView.leaveChannel()
        }
    
    

  }

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
    return [button]
  }
  @objc func clickedBolt(sender: UIButton) {
    print("zap!")
    sender.isSelected.toggle()
    sender.backgroundColor = sender.isSelected ?
      .systemYellow : .systemGray
    agoraView.leaveChannel()
  }
}

