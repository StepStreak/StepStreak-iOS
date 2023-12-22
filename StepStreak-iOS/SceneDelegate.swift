//
//  SceneDelegate.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import Turbo
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigator = TurboNavigator(pathConfiguration: pathConfiguration, delegate: self)
    private let pathConfiguration = PathConfiguration(sources: [
        .server(Endpoint.pathConfigurationURL),
        .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!)
    ])

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UINavigationBar.configureWithOpaqueBackground()
        Turbo.configureStrada()

        window?.rootViewController = navigator.rootViewController
        navigator.route(Endpoint.rootURL)
    }
}

extension SceneDelegate: TurboNavigatorDelegate {
    func handle(proposal: VisitProposal) -> ProposalResult {
        switch proposal.viewController {
        case "permissions":
            return .acceptCustom(PermissionsViewController(url: proposal.url))
        default:
            return .acceptCustom(WebViewController(url: proposal.url))

        }

    }
}
