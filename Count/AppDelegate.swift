//
//  AppDelegate.swift
//  Count
//
//  Created by Mac on 05.04.2018.
//  Copyright © 2018 FokinMC. All rights reserved.
//
//let kAPP_KEY = "063a427b697bb3ad038da591151b2ebf89ccb7f2c8ecebc1"

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.9450980392, green: 0.5019607843, blue: 0.1960784314, alpha: 1)      //цвет текста
//        UITabBar.appearance().tintColor = #colorLiteral(red: 0.672329545, green: 0.4029557109, blue: 0.7608545423, alpha: 1)
//        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9830823541, green: 0.8759781718, blue: 0.9753966928, alpha: 1)
//        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabSelectBG")
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBarView.backgroundColor = #colorLiteral(red: 0.9830823541, green: 0.8759781718, blue: 0.9753966928, alpha: 1)
        self.window?.rootViewController?.view.insertSubview(statusBarView, at: 0)
        
//        if let barFont = UIFont(name: "AppleSDGothicNeo-Light", size: 24) {
//            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: barFont]
//        }
        if let barFont = UIFont(name: "AppleSDGothicNeo-Light", size: 24) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.5019607843, blue: 0.1960784314, alpha: 1), NSAttributedStringKey.font: barFont] as [NSAttributedStringKey : Any]
        }
        
//        // реклама
//        let userDefaults = UserDefaults.standard
//        let isSwitchOfAds = userDefaults.bool(forKey: "switchOfAds")
//        if isSwitchOfAds == false {
//            initializeAppodealSDK()                                            //Отключение рекламы
//        } // реклама
        
        if #available(iOS 10.3, *) {
            RateManager.incrementCount()
        } else {
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.coreDataStack.saveContext()
    }
    
//    func initializeAppodealSDK() {
//        let adTypes: AppodealAdType = [.interstitial, .banner, .rewardedVideo, .nativeAd]
//        Appodeal.setLogLevel(.off)
//        Appodeal.setAutocache(true, types: adTypes)
//        Appodeal.initialize(withApiKey: kAPP_KEY, types: adTypes)
//    }

}

