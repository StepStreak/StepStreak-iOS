//
//  Endpoint.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/12/2023.
//

import Foundation

enum Endpoint {
    static var rootURL: URL {
        let baseURL: URL
        #if DEBUG
        baseURL = URL(string: "http://localhost:3000")!
        #else
        baseURL = URL(string: "https://stepstreak.xyz")!
        #endif
        
        let languageCode: String
         if let preferredLanguage = Locale.preferredLanguages.first {
             languageCode = String(preferredLanguage.prefix(2))
         } else {
             languageCode = "en"
         }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [URLQueryItem(name: "locale", value: languageCode)]
        
        return components.url!
    }
    
    static var apiURL: URL {
        #if DEBUG
        return URL(string: "http://localhost:3000/api/")!
        #else
        return URL(string: "https://stepstreak.xyz/api/")!
        #endif
    }

    static var pathConfigurationURL: URL {
        rootURL.appending(path: "configurations/ios.json")
    }
}
