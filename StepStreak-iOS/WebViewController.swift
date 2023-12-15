//
//  TurboWebViewController.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 29/10/2023.
//

import Foundation
import UIKit
import Turbo
import Strada
import WebKit
import HealthKit

final class WebViewController: VisitableViewController, BridgeDestination {

    let healthService = HealthKitService()

    private lazy var bridgeDelegate: BridgeDelegate = {
        BridgeDelegate(location: visitableURL.absoluteString,
                       destination: self,
                       componentTypes: BridgeComponent.allTypes)
    }()

    // MARK: View lifecycle

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
        
        Task {
            let center = UNUserNotificationCenter.current()
            let success = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            
            if success {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bridgeDelegate.onViewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bridgeDelegate.onViewDidDisappear()
    }

    // MARK: Visitable

    override func visitableDidActivateWebView(_ webView: WKWebView) {
        bridgeDelegate.webViewDidBecomeActive(webView)
    }

    override func visitableDidDeactivateWebView() {
        bridgeDelegate.webViewDidBecomeDeactivated()
    }
}
