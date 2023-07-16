//
//  ViewController.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import UIKit
import HealthKit
import Network

class ViewController: UIViewController {

    let healthService = HealthKitService()
    let apiService = APIService()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create a button
        let button = UIButton(type: .system)
        button.setTitle("Fetch Health Data", for: .normal)
        button.addTarget(self, action: #selector(fetchHealthData), for: .touchUpInside)

        // Add the button to the view
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        // Position the button in the center of the view
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
    
    @objc func fetchHealthData() {
        activityIndicator.startAnimating()
        
        let group = DispatchGroup()

        var stepsByDate: [Date: Double]?
        var caloriesByDate: [Date: Double]?
        var distanceByDate: [Date: Double]?

        group.enter()
        healthService.getStepsCount { steps, error in
            if let error = error {
                print("Error reading steps count: \(error.localizedDescription)")
            } else {
                stepsByDate = steps
            }
            group.leave()
        }

        group.enter()
        healthService.getCalories { calories, error in
            if let error = error {
                print("Error reading calories: \(error.localizedDescription)")
            } else {
                caloriesByDate = calories
            }
            group.leave()
        }

        group.enter()
        healthService.getDistance { distance, error in
            if let error = error {
                print("Error reading distance: \(error.localizedDescription)")
            } else {
                distanceByDate = distance
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
                let dailyHealthData = DailyHealthData(date: dateString, steps: steps, calories: calories, distance: distance)
                dailyData.append(dailyHealthData)
            }

            let healthData = HealthData(healthData: dailyData)
            
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("We're connected!")
                    self?.apiService.sendData(healthData: healthData) { error in
                        if let error = error {
                            print("Error sending health data: \(error.localizedDescription)")
                        } else {
                            print("Successfully sent health data")
                        }
                        self?.activityIndicator.stopAnimating()
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
