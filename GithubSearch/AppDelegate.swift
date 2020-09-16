//
//  AppDelegate.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func applicationDidFinishLaunching(_ application: UIApplication) {
        Thread.sleep(forTimeInterval: 0.7)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

