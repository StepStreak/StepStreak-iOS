//
//  PermissionsViewController.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 21/12/2023.
//

import Foundation
import UIKit
import Turbo
import Strada
import WebKit
import HealthKit

final class PermissionsViewController: VisitableViewController, BridgeDestination {
    private lazy var bridgeDelegate: BridgeDelegate = {
        BridgeDelegate(location: visitableURL.absoluteString,
                       destination: self,
                       componentTypes: BridgeComponent.allTypes)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeDelegate.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bridgeDelegate.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bridgeDelegate.onViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bridgeDelegate.onViewWillDisappear()
        
        let healthService = HealthKitService()

        Task {
            let center = UNUserNotificationCenter.current()
            let success = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            
            if success {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        Task {
            if HKHealthStore.isHealthDataAvailable() {
                healthService.requestAuthorization { success, error in
                    if let error = error {
                        print("Error requesting authorization: \(error)")
                    } else if success {
                        print("Authorization granted")
                    }
                }
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bridgeDelegate.onViewDidDisappear()
    }

    override func visitableDidActivateWebView(_ webView: WKWebView) {
        bridgeDelegate.webViewDidBecomeActive(webView)
    }

    override func visitableDidDeactivateWebView() {
        bridgeDelegate.webViewDidBecomeDeactivated()
    }
    
}
