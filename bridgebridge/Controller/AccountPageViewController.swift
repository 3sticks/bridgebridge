//
//  AccountPageViewController.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 2/25/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//


//todo edit profile picture -- edit profile,jump to new view controller. guy has it in his udemy shit
import UIKit
import Alamofire

class AccountPageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {//through the navigation controller, we open the picker controller to select an image
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make the profile image circular
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        
        
        //get user details from user global variable
        let username = user!["username"] as? String
        let ava = user!["ava"] as? String
        
        
        //assign values(s) -- right now just username. not putting emails and shit
        usernameLabel.text = username //fixme do we need this if the username is the nav title?
        
        
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
    
    @IBAction func editClicked(_ sender: Any) {
        
        //select profile picture
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    //to also allow camera one day
    //UIImagePickerController.SourceType.camera //https://stackoverflow.com/questions/54268856/upload-image-to-my-server-via-php-using-swift
    //https://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
    
    
    //select image ///https://developer.apple.com/forums/thread/653389
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                profileImage.image = info[.editedImage] as? UIImage //stores the image in the profileImage outlet, which shows in the image view and is used by the upload function
                self.dismiss(animated: true, completion: nil)

        //call function to upload avatar
        alamoUpload()
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //custom body of HTTP request to upload image file
    //string string is associative array
    //value 1 is key, value 2 is value in array
    func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data{
        
        let body = NSMutableData();
        
        if parameters != nil{
            
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
            
        }
        //filename of image being stored
        let filename = "ava.jpg"
        let mimetype = "image/jpg" //media type
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Conent-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n") //rn is breaks
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        print("image data key \(imageDataKey as Data)")
        print("body data!!!!!")
        print(body as Data)
        return body as Data
    
        
        //FIXME these as's might not work.....
        
    }
    
    //Got this from here. changed the forkey to id, and went on my way. finally fucking worked. image uploaded!
    //https://stackoverflow.com/questions/55626235/how-to-upload-image-multipart-using-alamofire-5-0-0-beta-3-swift-5
    //ALAMO FIRE BABYYYYYYYY maybe actually learn what this is doing instead of just jacking the code. TODO maybe. maybeeeee.
    func alamoUpload() {
        let api_url = "https://mybridgeapp.com/uploadava.php"
        guard let url = URL(string: api_url) else {
            return
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        let id = user!["id"] as! String //cant make this user name since url uses id
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        parameterDict.setValue(id, forKey: "id") //just id for now

        //Set Image Data
        let imgData = profileImage.image!.jpegData(compressionQuality: 0.5)!

       // Now Execute
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in parameterDict {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key as! String + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(imgData, withName: "file", fileName: "ava.jpg", mimeType: "image/jpg")
        }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in

                       switch data.result {

                       case .success(_):
                        do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary //does this need to be nmutable containers?
                          
                            print("Success!")
                            print(dictionary)
                            
                            //TODO maybeeeee add ina guard let here
                            
                            // save user information we received from our host to userdefaults
                            //pasrse json is the key we used for the user value
                            UserDefaults.standard.set(dictionary, forKey: "parseJSON")//save /////dictionary instead of parsejson.. think will work
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary //assign to user variable

                            
                       }
                       catch {
                          // catch error.
                        print("catch error")

                              }
                        break
                            
                       case .failure(_):
                        print("failure")

                        break
                        
                    }


            })
    }
    
    //Logout the user. TODO bury this in a drawer one day
    @IBAction func logout_clicked(_ sender: Any) {
        
        
                //want to remove all user info
                    // remove saved information
                    UserDefaults.standard.removeObject(forKey: "parseJSON") //parsejson matches user creation
                    UserDefaults.standard.synchronize()
        // go to mainlanding page (instant jump)
                DispatchQueue.main.async(execute: { //todo what the hell is this
                  sceneDelegate?.logout()
                })
        
        
        ///note -- the above rolls back to the main landing page (login/register). the below presents a popover segue. dont know what i like better. keeping both around.
//

//
//            // go to login page
//        //DECLARE VARIABLE THAT STORES THE LOGIN PAGE
//            let LogInViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
//            self.present(LogInViewController, animated: true, completion: nil)
//

    }
    
    
    
}


//Dont think these are needed anymore


//Creating protocol of appending string to a variable of type data
extension NSMutableData{
    func appendString(_ string: String){
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

extension URLRequest {
    func log() {
        print("\(httpMethod ?? "") \(self)")
        print("BODY \n \(httpBody?.toString())")
        print("HEADERS \n \(allHTTPHeaderFields)")
    }
}
