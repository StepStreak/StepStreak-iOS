//
//  BridgeComponent+App.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 29/10/2023.
//

import Foundation
import Strada

extension BridgeComponent {
    static var allTypes: [BridgeComponent.Type] {
        [
            SyncButtonComponent.self,
            TokenComponent.self
        ]
    }
}
