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
    let restingHeartRate: Double?
}