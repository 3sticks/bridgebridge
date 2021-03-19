//
//  SceneDelegate.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 2/22/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit


let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//global variable named appDelegate so we can call it from any class/file.swift
//let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate



// GLOBAL VARIABLE stores all information about current user
var user : NSDictionary?


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    
    //gets called in login/register
    //func to pass to home page or to tabbar
    ///moved from app delegate. move all scene shit from app delegate (this would include popup functions and stuff like that)
    func login(){
        
        //refer to main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //store tabbar object from main.storyboard in tabbar variable
        let tabBar = storyboard.instantiateViewController(withIdentifier: "homePageID") //homepage id is the storyboard ID of the main tab bar VC, this is the landing page after logging in.
        
        //present tabbar that is stored in tabbar var
        window?.rootViewController = tabBar
    }
    
    func trainerLogin(){
        
        //refer to main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //store tabbar object from main.storyboard in tabbar variable
        let tabBar2 = storyboard.instantiateViewController(withIdentifier: "trainerHomeID") //homepage id is the storyboard ID of the main tab bar VC, this is the landing page after logging in.
        
        //present tabbar that is stored in tabbar var
        window?.rootViewController = tabBar2
    }
    
    
    
    
    func logout(){
        //refer to main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let landing = storyboard.instantiateViewController(withIdentifier: "loginNavCon") //INSTEAD OF logging out to the landing page VC, log out to the nav controller. this makes sure the views are then within the nav controller, and not popover segues. nav doesnt have a vc, but we gave it an id (loginNavCon)
        //todo destroy user var
        window?.rootViewController = landing
        
    }
    
    
    //put stuff here instead of appdelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        // load content in user var

        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary

//        print(user!)
        // if user is once logged in / register, keep them logged in

        if user != nil {

            let id = user!["id"] as? String

            if id != nil {
                login()

                }

        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

