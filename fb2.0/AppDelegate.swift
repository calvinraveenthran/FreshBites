//
//  AppDelegate.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-11-16.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import Parse
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // [Optional] Power your app with Local Datastore. For more info, go to
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("KxAs5Ob7jKiAn78k83cjllUv4BRxUFPJu0ktHZKl",
            clientKey: "Am22B0RUlpMCJ9zTNAa0o1xOi5dhQZfWcGawpilY");
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        
        
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction: "freshbites347@gmail.com",PayPalEnvironmentSandbox: "ATG758G2etPnkIpkvqhxkYnDYG7XDLIffJbjirscbLJCAfmpbPhQKkrfeV1rbaqoiPlT-dn9uqPD-Tg_"])
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

