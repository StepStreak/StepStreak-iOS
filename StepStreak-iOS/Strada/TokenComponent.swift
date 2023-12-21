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
    
    let apiService = APIService()
        
    private func handleConnectEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        
        let keychain = KeychainSwift()
        keychain.set(data.syncToken, forKey: "token")
        
        if (keychain.get("server-apn-token") != keychain.get("apn-token")) {
            apiService.sendDeviceTokenToServer()
        }
    }
    
    private func handleSubmitEnabled() {
    }
    
    private func handleSubmitDisabled() {
    }
    
}

private extension TokenComponent {
    enum Event: String {
        case connect
        case submitEnabled
        case submitDisabled
    }
}

private extension TokenComponent {
    struct MessageData: Decodable {
        let syncToken: String
    }
}
