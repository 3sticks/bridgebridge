//
//  VideoCallViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 6/21/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import AgoraRtcKit

//https://github.com/sidsharma27/Agora-iOS-Tutorial-Swift-1to1#create-an-agora-instance

class VideoCallViewController: UIViewController {
    
    

    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
//    var channel:String?
//
    var agoraKit: AgoraRtcEngineKit!                 // Tutorial Step 1
//    let AppID: String = <#Your App Id#>                  // Tutorial Step 1
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeAgoraEngine()     // Tutorial Step 1
        setupLocalVideo()                // Tutorial Step 2
        joinChannel()               // Tutorial Step 3
//        setupLocalVideo()           // Tutorial Step 4
//        hideVideoMuted()            // Tutorial Step 10
//        setupButtons()              // Tutorial Step 11
    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // Tutorial Step 1
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self as! AgoraRtcEngineDelegate)
    }
    
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localVideo
        // Sets the local video view
        agoraKit?.setupLocalVideo(videoCanvas)
        }
    
    
    func joinChannel(){
            // The uid of each user in the channel must be unique.
            agoraKit?.joinChannel(byToken: "006f2952c72fcca4ce288c430cbc4a8f164IADK2vxldsAPaJrWjxv8iXRZNUoGfzdJVfzGezdLHymyawx+f9gAAAAAEACX33iMw0XSYAEAAQDDRdJg", channelId: "test", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
        })
    }
    
    
    func leaveChannel() {
            agoraKit?.leaveChannel(nil)
        }
    
    // Tutorial Step 6
    @objc func hideControlButtons() {
        controlButtons.isHidden = true
    }

    // Tutorial Step 6
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
    }

    // Tutorial Step 6
    func resetHideButtonsTimer() {
        VideoCallViewController.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
    }

    // Tutorial Step 7
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalAudioStream(sender.isSelected)
        resetHideButtonsTimer()
    }

    // Tutorial Step 8
    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.muteLocalVideoStream(sender.isSelected)
        localVideo.isHidden = sender.isSelected
        localVideoMutedBg.isHidden = !sender.isSelected
        localVideoMutedIndicator.isHidden = !sender.isSelected
        resetHideButtonsTimer()
    }
    
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit.switchCamera()
        resetHideButtonsTimer()
    }

    // Tutorial Step 10
    func hideVideoMuted() {
        remoteVideoMutedIndicator.isHidden = true
        localVideoMutedBg.isHidden = true
        localVideoMutedIndicator.isHidden = true
    }

    // Tutorial Step 11
    func setupButtons() {
        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    // Tutorial Step 11
    @objc func viewTapped() {
        if (controlButtons.isHidden) {
            controlButtons.isHidden = false;
            perform(#selector(hideControlButtons), with:nil, afterDelay:3)
        }
    }
//
    
    

}

//extension VideoCallViewController: AgoraRtcEngineDelegate {
//    // Monitors the didJoinedOfUid callback
//    // The SDK triggers the callback when a remote user joins the channel
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.renderMode = .hidden
//        videoCanvas.view = remoteVideo
//        // Sets the remote video view
//        agoraKit?.setupRemoteVideo(videoCanvas)
//    }
//}

extension VideoCallViewController: AgoraRtcEngineDelegate {
    // Tutorial Step 5
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        if (remoteVideo.isHidden) {
            remoteVideo.isHidden = false
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideo
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }

    // Tutorial Step 5
//    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid:UInt, reason:AgoraRtcUserOfflineReason) {
//        self.remoteVideo.isHidden = true
//    }

    // Tutorial Step 5
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didVideoMuted muted:Bool, byUid:UInt) {
        remoteVideo.isHidden = muted
        remoteVideoMutedIndicator.isHidden = !muted
    }
}

//    // Tutorial Step 2
//    func setupVideo() {
//        agoraKit.enableVideo()  // Default mode is disableVideo
////        agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false) // Default video profile is 360P
//    }
//
//    // Tutorial Step 3
//    func joinChannel() {
//        agoraKit.joinChannel(byKey: nil, channelName: channel!, info:nil, uid:0) {[weak self] (sid, uid, elapsed) -> Void in
//            if let weakSelf = self {
//                weakSelf.agoraKit.setEnableSpeakerphone(true)
//                UIApplication.shared.isIdleTimerDisabled = true
//            }
//        }
//    }
//
//    // Tutorial Step 4
//    func setupLocalVideo() {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = 0
//        videoCanvas.view = localVideo
//        videoCanvas.renderMode = .render_Adaptive
//        agoraKit.setupLocalVideo(videoCanvas)
//    }
//
//    // Tutorial Step 6
//    func leaveChannel() {
//        agoraKit.leaveChannel(nil)
//        hideControlButtons()
//        UIApplication.shared.isIdleTimerDisabled = false
//        remoteVideo.removeFromSuperview()
//        localVideo.removeFromSuperview()
//        agoraKit = nil
//    }

//}
//
