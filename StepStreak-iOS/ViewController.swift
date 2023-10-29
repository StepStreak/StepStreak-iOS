//
//  ViewController.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthService = HealthKitService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if HKHealthStore.isHealthDataAvailable() {
            print("available")
        }

        healthService.requestAuthorization { success, error in
                    if let error = error {
                        print("Error requesting authorization: \(error)")
                    } else if success {
                        print("Authorization granted")
                    }
                }
    }
}
