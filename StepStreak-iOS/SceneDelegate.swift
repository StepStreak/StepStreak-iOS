//
//  SceneDelegate.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import UIKit
import Turbo
import WebKit
import Strada

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window!.rootViewController = navigationController
        visit(url: URL(string: "http://192.168.0.89:3000/")!)
    }
    
    private func visit(url: URL, action: VisitAction = .advance) {
        let viewController = TurboWebViewController(url: url)

        
        if session.activeVisitable?.visitableURL == url {
             replaceLastController(with: viewController)
         } else if action == .advance {
             navigationController.pushViewController(viewController, animated: true)
         } else {
             replaceLastController(with: viewController)
         }
        
        session.visit(viewController)
    }
    
    func replaceLastController(with controller: UIViewController) {
        let viewControllers = navigationController.viewControllers.dropLast()
        navigationController.setViewControllers(viewControllers + [controller], animated: false)
    }
    
    private lazy var session: Session = {
        let webView = WKWebView(frame: .zero, configuration: .appConfiguration)
        webView.isInspectable = true
        
        Bridge.initialize(webView)
        
        let session = Session(webView: webView)
        session.delegate = self
        return session
    }()
}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url, action: proposal.options.action)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("didFailRequestForVisitable: \(error)")
    }
    
    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
}
