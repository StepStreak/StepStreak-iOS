//
//  UINavigationBar+Appearance.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/12/2023.
//

import UIKit

extension UINavigationBar {
    static func configureWithOpaqueBackground() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
