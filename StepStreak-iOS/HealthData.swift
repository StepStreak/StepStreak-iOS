//
//  HealthData.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 10/07/2023.
//

import Foundation

struct HealthData: Encodable {
    let data: [DailyHealthData]
    let heartRateByDate: [Date: Double]?
    
    init(data: [DailyHealthData], heartRateByDate: [Date: Double]?) {
        self.data = data
        self.heartRateByDate = heartRateByDate
    }
}