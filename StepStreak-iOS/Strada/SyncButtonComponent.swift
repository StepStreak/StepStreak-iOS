//
//  SyncButtonComponent.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 29/10/2023.
//

import Foundation
import Strada
import UIKit
import Network

final class SyncButtonComponent: BridgeComponent {
    override class var name: String { "sync" }
    let healthService = HealthKitService()
    let apiService = APIService()
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func onReceive(message: Message) {
        print("we are here")
        guard let event = Event(rawValue: message.event) else {
            return
        }

        switch event {
        case .connect:
            handleConnectEvent(message: message)
        case .submitEnabled:
            handleSubmitEnabled()
        case .submitDisabled:
            handleSubmitDisabled()
        }
    }

    private weak var submitBarButtonItem: UIBarButtonItem?
       private var viewController: UIViewController? {
           delegate.destination as? UIViewController
       }
    
    // MARK: Private

    private func handleConnectEvent(message: Message) {
        print("connected component")
        guard let data: MessageData = message.data() else { return }

        guard let viewController else { return }
        
        let item = UIBarButtonItem(title: data.syncTitle,
                                   style: .plain,
                                   target: self,
                                   action: #selector(performAction))
        
        viewController.navigationItem.rightBarButtonItem = item
        submitBarButtonItem = item
    }

    private func handleSubmitEnabled() {
        submitBarButtonItem?.isEnabled = true
    }
    
    private func handleSubmitDisabled() {
        submitBarButtonItem?.isEnabled = false
    }
    
    @objc func performAction() {
//        reply(to: Event.connect.rawValue)
        fetchHealthData()
    }
    
    @objc func fetchHealthData() {
//        activityIndicator.startAnimating()
        
        let group = DispatchGroup()

        var stepsByDate: [Date: Int32]?
        var caloriesByDate: [Date: Double]?
        var distanceByDate: [Date: Double]?
        var heartRateByDate: [Date: Double]?
        var maxHeartRateByDate: [Date: Double]?
        var restingHeartRateByDate: [Date: Double]?

//        let calendar = Calendar.current
//        var fromComponents = DateComponents()
//        fromComponents.day = 1
//        fromComponents.month = 10
//        fromComponents.year = 2018
//
//        guard let startTime = calendar.date(from: fromComponents) else { return  }
//
//        var toComponents = DateComponents()
//        toComponents.day = 31
//        toComponents.month = 7
//        toComponents.year = 2023
//
//        guard let endTime = calendar.date(from: toComponents) else { return }
        
        let endTime = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: endTime)
        guard let startTime = calendar.date(from: components) else { return }
        
        group.enter()
        healthService.getStepsCount(startTime: startTime, endTime: endTime) { steps, error in
            if let error = error {
                print("Error reading steps count: \(error.localizedDescription)")
            } else {
                stepsByDate = steps
            }
            group.leave()
        }

        group.enter()
        healthService.getCalories(startTime: startTime, endTime: endTime) { calories, error in
            if let error = error {
                print("Error reading calories: \(error.localizedDescription)")
            } else {
                caloriesByDate = calories
            }
            group.leave()
        }

        group.enter()
        healthService.getHeartRate(startTime: startTime, endTime: endTime) { heartRate, error in
            if let error = error {
                print("Error reading heart rate: \(error.localizedDescription)")
            } else {
                heartRateByDate = heartRate
            }
            group.leave()
        }
        
        group.enter()
        healthService.getMaxHeartRate(startTime: startTime, endTime: endTime) { maxHeartRate, error in
            if let error = error {
                print("Error reading max heart rate: \(error.localizedDescription)")
            } else {
                maxHeartRateByDate = maxHeartRate
            }
            group.leave()
        }
        
        group.enter()
        healthService.getDistance(startTime: startTime, endTime: endTime) { distance, error in
            if let error = error {
                print("Error reading distance: \(error.localizedDescription)")
            } else {
                distanceByDate = distance
            }
            group.leave()
        }
        
        group.enter()
        healthService.getRestingHeartRate(startTime: startTime, endTime: endTime) { restingHeartRate, error in
            if let error = error {
                print("Error reading resting heart rate: \(error.localizedDescription)")
            } else {
                restingHeartRateByDate = restingHeartRate
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            var dailyData: [DailyHealthData] = []

            let monitor = NWPathMonitor()

            let stepDates = stepsByDate?.keys.map { $0 } ?? []
            let calorieDates = caloriesByDate?.keys.map { $0 } ?? []
            let distanceDates = distanceByDate?.keys.map { $0 } ?? []
            let allDates = Set(stepDates + calorieDates + distanceDates)

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            for date in allDates {
                let dateString = formatter.string(from: date)
                let steps = stepsByDate?[date] ?? 0
                let calories = caloriesByDate?[date] ?? 0
                let distance = distanceByDate?[date] ?? 0
                let heartRate = heartRateByDate?[date] ?? 0
                let maxHeartRate = maxHeartRateByDate?[date] ?? 0
                let restingHeartRate = restingHeartRateByDate?[date] ?? 0
                let dailyHealthData = DailyHealthData(date: dateString, steps: steps, calories: calories, distance: distance, heartRate: heartRate, restingHeartRate: restingHeartRate, maxHeartRate: maxHeartRate)
                dailyData.append(dailyHealthData)
            }

            let healthData = HealthData(activity: dailyData)
            
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("We're connected!")
                    self?.apiService.sendData(healthData: healthData) { error in
                        if let error = error {
                            print("Error sending health data: \(error.localizedDescription)")
                        } else {
                            print("Successfully sent health data")
                        }
//                        self?.activityIndicator.stopAnimating()
                    }
                } else {
                    print("No connection.")
                }
                print(path.isExpensive)
            }
            let queue = DispatchQueue(label: "Network")
            monitor.start(queue: queue)
        }
    }
}

// MARK: Events

private extension SyncButtonComponent {
    enum Event: String {
        case connect
        case submitEnabled
        case submitDisabled
    }
}

// MARK: Message data

private extension SyncButtonComponent {
    struct MessageData: Decodable {
        let syncTitle: String
    }
}
