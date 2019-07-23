//
//  AppDelegate.swift
//  PetsDiffingiOS13
//
//  Created by Alfian Losari on 18/07/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController()
        window.rootViewController = UINavigationController(rootViewController: mainVC)
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}

