//
//  AppDelegate.swift
//  bridgebridge
//
//  Created by Hugo Bucci III on 2/22/21.
//  Copyright © 2021 Hugo Bucci III. All rights reserved.
//

import UIKit
import CoreData
import Stripe


//global variable named appDelegate so we can call it from any class/file.swift
let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

//agora app id
let AppID = "f2952c72fcca4ce288c430cbc4a8f164"

// stores all information about current user
//var user : NSDictionary?


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51IVQemLDOGUrLhOmjSQLWVwlCiKk9WKUMfTjBYBoNgqC2Q3xwfGHy1sSFD10SkkbQNRWKVACYK5QYIBYdKE450Mv00CUHT2i6E"
        // do any other necessary launch configuration
        return true
    }
    

//    //gets called in login/register
//    //func to pass to home page or to tabbar
//    //TODO this is depricated
//    func login(){
//
//        //refer to main storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        //store tabbar object from main.storyboard in tabbar variable
//        let tabBar = storyboard.instantiateViewController(withIdentifier: "dick")
//
//        //present tabbar that is stored in tabbar var
//        window?.rootViewController = tabBar
//
//        //FIME NOT WORKING
//    }
    
    
    
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "bridgebridge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

