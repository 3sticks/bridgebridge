//
//  ConnectOnboardViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 3/15/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import SafariServices

let BackendAPIBaseURL: String = "https://mybridgeapp.com" // Set to the URL of your backend server

class ConnectOnboardViewController: UIViewController {

    // ...

    override func viewDidLoad() {
        super.viewDidLoad()

        let connectWithStripeButton = UIButton(type: .system)
        connectWithStripeButton.setTitle("Connect with Stripe", for: .normal)
        connectWithStripeButton.addTarget(self, action: #selector(didSelectConnectWithStripe), for: .touchUpInside)
        view.addSubview(connectWithStripeButton)

        // ...
    }

    @IBAction func button(_ sender: Any) {
        
        didSelectConnectWithStripe()
    }
    @objc
    func didSelectConnectWithStripe() {
        if let url = URL(string: BackendAPIBaseURL)?.appendingPathComponent("onboard-user") {//sooo need to build obvard user
            
            print(url)
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let accountURLString = json["url"] as? String,
                  let accountURL = URL(string: accountURLString) else {
                     print(error)
                return
              }

              let safariViewController = SFSafariViewController(url: url)
              safariViewController.delegate = self

              DispatchQueue.main.async {
                  self.present(safariViewController, animated: true, completion: nil)
              }
          }
        }
    }

    // ...
}

extension ConnectOnboardViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // the user may have closed the SFSafariViewController instance before a redirect
        // occurred. Sync with your backend to confirm the correct state
    }
}
