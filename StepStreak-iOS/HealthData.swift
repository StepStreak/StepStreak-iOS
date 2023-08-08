//
//  HealthData.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 10/07/2023.
//

import Foundation

struct HealthData: Encodable {
    let data: [DailyHealthData]
    
    init(data: [DailyHealthData]) {
        self.data = data
    }
}