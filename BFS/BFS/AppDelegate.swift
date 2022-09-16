//
//  AppDelegate.swift
//  BFS
//
//  Created by ui03 on 2022/8/25.
//

import UIKit
import SSZipArchive

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        GlobalTimer.shared.StartTimer()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        GlobalTimer.shared.stopTimer()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GlobalTimer.shared.stopTimer()
    }
    
}

