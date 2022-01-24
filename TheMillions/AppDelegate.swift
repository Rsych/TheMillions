//
//  AppDelegate.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        registerForNotification()
        return true
    }
    
    func registerForNotification() {
        // For device token and push notifications.
        UIApplication.shared.registerForRemoteNotifications()
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        //        center.delegate = self
        
        center.requestAuthorization(options: [.sound, .alert, .badge ], completionHandler: { (_, error) in
            if error != nil { UIApplication.shared.registerForRemoteNotifications() } else {
                
            }
        })
    }
}
