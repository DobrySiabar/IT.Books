//
//  AppDelegate.swift
//  IT.Books
//
//  Created by Philip on 10.09.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    // Change colour
//    func customizeAppearance() {
//        let barTintColor = UIColor(red: 114/255, green: 216/255, blue: 255/255, alpha: 1)
//        UISearchBar.appearance().barTintColor = barTintColor
//        window!.tintColor = UIColor(red: 114/255, green: 216/255, blue: 255/255, alpha: 1)
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Sending the NSManagedObjectContext object to View Controllers
//        let tabBarController = window?.rootViewController as? UITabBarController
//        if let tabBarViewControllers = tabBarController?.viewControllers {
//            let searchViewController = tabBarViewControllers[0] as! SearchViewController
//            searchViewController.managedObjectContext = managedObjectContext
//            let favouriteViewController = tabBarViewControllers[1]
//            let _ = favouriteViewController.view
//            customizeAppearance()
//        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    

}

