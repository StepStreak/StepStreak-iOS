//
//  WKWebViewConfiguration+App.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 29/10/2023.
//

import Strada
import Turbo
import WebKit

extension Turbo {
    static func configureStrada() {
        Turbo.config.userAgent +=
            " \(Strada.userAgentSubstring(for: BridgeComponent.allTypes))"

        Turbo.config.makeCustomWebView = { configuration in
            let webView = WKWebView(frame: .zero, configuration: configuration)
            Bridge.initialize(webView)
            return webView
        }
    }
}
