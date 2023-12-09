//
//  Endpoint.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/12/2023.
//

import Foundation

enum Endpoint {
    static var rootURL: URL {
        #if DEBUG
        return URL(string: "http://192.168.0.89:3000")!
        #else
        return URL(string: "http://192.168.0.89:3000")!
        #endif
    }

    static var pathConfigurationURL: URL {
        rootURL.appending(path: "configurations/ios.json")
    }
}
