//
//  Settings-Controller.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/24.
//

import Foundation
import UIKit
import StoreKit
import UserNotifications

class DataController: ObservableObject {
    /// Requests review right away!
    func showReview() {
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first
        if let windowScene = scene as? UIWindowScene { SKStoreReviewController.requestReview(in: windowScene)}
    }
    /// Opens Notifications in iPhone Settings
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    func checkPushNotification(checkNotificationStatus isEnable: ((Bool) -> Void)? = nil) {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in

                    switch settings.authorizationStatus {

                    case .authorized:
                        print("enabled notification setting")
                        isEnable?(true)
                    case .denied:
                        print("setting has been disabled")
                        isEnable?(false)
                    default:
                        print("something vital went wrong here")
                        isEnable?(false)
                    }
                }
        }
}
