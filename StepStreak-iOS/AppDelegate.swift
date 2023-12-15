//
//  AppDelegate.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import UIKit
import UserNotifications
import KeychainSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()

        let keychain = KeychainSwift()
        keychain.set(token, forKey: "apn-token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
