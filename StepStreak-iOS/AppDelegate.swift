//
//  AppDelegate.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import UIKit
import UserNotifications
import KeychainSwift
import UserNotifications
import HealthKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0

        let healthService = HealthKitService()

        if HKHealthStore.isHealthDataAvailable() {
            healthService.requestAuthorization { success, error in
                if let error = error {
                    print("Error requesting authorization: \(error)")
                } else if success {
                    print("Authorization granted")
                }
            }
        }
        return true
    }

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
