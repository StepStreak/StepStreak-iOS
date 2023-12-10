//
//  TokenComponent.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 10/12/2023.
//

import Foundation
import Strada
import UIKit
import Network
import KeychainSwift

final class TokenComponent: BridgeComponent {
    override class var name: String { "token" }
    
    override func onReceive(message: Message) {
        print("we are here in token component")
        guard let event = Event(rawValue: message.event) else {
            return
        }
        
        switch event {
        case .connect:
            handleConnectEvent(message: message)
        case .submitEnabled:
            handleSubmitEnabled()
        case .submitDisabled:
            handleSubmitDisabled()
        }
    }
    
    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }
    
    // MARK: Private
    
    private func handleConnectEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        
        let keychain = KeychainSwift()
        keychain.set(data.syncToken, forKey: "token")
    }
    
    private func handleSubmitEnabled() {
    }
    
    private func handleSubmitDisabled() {
    }
    
}

// MARK: Events

private extension TokenComponent {
    enum Event: String {
        case connect
        case submitEnabled
        case submitDisabled
    }
}

// MARK: Message data

private extension TokenComponent {
    struct MessageData: Decodable {
        let syncToken: String
    }
}
