//
//  DailyHealthData.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 10/07/2023.
//

import Foundation

struct DailyHealthData: Encodable {
    let date: String
    let steps: Int32?
    let calories: Double?
    let distance: Double?
    let heartRate: Double?
    
    init(date: String, steps: Int32?, calories: Double?, distance: Double?, heartRate: Double?) {
        self.date = date
        self.steps = steps
        self.calories = calories
        self.distance = distance
        self.heartRate = heartRate
    }
}