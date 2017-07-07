//
//  AppDelegate.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        if UserDefaults.standard.bool(forKey: "login") {
            let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
            window?.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        }
        window?.makeKeyAndVisible()
        return true
    }

}

