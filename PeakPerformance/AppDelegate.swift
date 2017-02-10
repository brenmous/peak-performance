//
//  AppDelegate.swift
//  PeakPerformance
//
//  Created by Bren on 20/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init( )
    {
        super.init( )
        
        //Set up Firebase framework
        FIRApp.configure( )
        FIRDatabase.database( ).persistenceEnabled = true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let UITabBar = UITabBarItem.appearance()
        UITabBar.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 255, green: 201, blue: 255, alpha: 1.0)], for: UIControlState.highlighted)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert], categories: nil))
        
        Fabric.with([Twitter.self])
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

