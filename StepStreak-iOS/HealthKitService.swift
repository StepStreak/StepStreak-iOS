//
//  HealthKitService.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import Foundation
import HealthKit

class HealthKitService {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: [], read: allTypes) { (success, error) in
            completion(success, error)
        }
    }
    


    func getStepsCount(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, nil)
            return
        }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let startOfMonth = calendar.date(from: components) else {
            completion(nil, nil)
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: now, options: .strictStartDate)

        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: steps,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfMonth,
                                                intervalComponents: interval)

        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(nil, error)
            } else if let results = results {
                var stepsByDate = [Date: Double]()

                results.enumerateStatistics(from: startOfMonth, to: now) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        stepsByDate[date] = steps
                    }
                }

                completion(stepsByDate, nil)
            }
        }

        healthStore.execute(query)
    }

    func getCalories(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        guard let calories = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, nil)
            return
        }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let startOfMonth = calendar.date(from: components) else {
            completion(nil, nil)
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: now, options: .strictStartDate)

        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: calories,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfMonth,
                                                intervalComponents: interval)

        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(nil, error)
            } else if let results = results {
                var stepsByDate = [Date: Double]()

                results.enumerateStatistics(from: startOfMonth, to: now) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.kilocalorie())
                        stepsByDate[date] = steps
                    }
                }

                completion(stepsByDate, nil)
            }
        }

        healthStore.execute(query)
    }
        
    func getDistance(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        guard let distance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(nil, nil)
            return
        }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let startOfMonth = calendar.date(from: components) else {
            completion(nil, nil)
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: now, options: .strictStartDate)

        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: distance,
                                                quantitySamplePredicate: predicate,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfMonth,
                                                intervalComponents: interval)

        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(nil, error)
            } else if let results = results {
                var stepsByDate = [Date: Double]()

                results.enumerateStatistics(from: startOfMonth, to: now) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.meter())
                        stepsByDate[date] = steps
                    }
                }

                completion(stepsByDate, nil)
            }
        }

        healthStore.execute(query)
    }
}
