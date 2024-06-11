//
// ChatControllerManager.swift
// 
//
//


import Foundation
import ChatLibrary
import PeerToPeerConnection
import Combine
import MultipeerConnectivity

@Observable
final class LocalPeerToPeerConnectionManager: PeerToPeerConnectionManager {
    
    
    
    

    
}

final class ChatControllerManager: ChatController {
    lazy var connectionManager: PeerToPeerConnectionManager = {
        PeerToPeerConnectionManager()
    }()
    
    private var cancelable: Set<AnyCancellable> = .init()
    
    override init() {
        super.init()
        setupSubscribers()
    }

    func setupSubscribers() {
        connectionManager
            .connectedPeers
            .publisher
            .sink { [weak self] _ in
                self?.isDisabled = self?.connectionManager.connectedPeers.isEmpty ?? true
            }
            .store(in: &cancelable)
        connectionManager
            .permissionRequestPublisher
            .map { (request: PeerToPeerConnectionManager.PermitionRequest) -> AlertController in
                let alert = AlertController(
                    alertTitle: "Session Invitation",
                    bodyMessage: "\(request.peerId.displayName) has invited you to their session."
                )
                alert.addAlertAction(titleButton: "Approve") {
                    request.onRequest(true)
                }
                alert.addAlertAction(titleButton: "Decline") {
                    request.onRequest(false)
                }
                return alert
            }.sink { _ in
                
            } receiveValue: { [weak self] alertController in
                guard let self else { return }
                self.showAlert = true
                self.chatAlert = alertController
            }
            .store(in: &cancelable)
        connectionManager
            .connectionObserver
            .filter { $0.state == .connected }
            .sink { [weak self] _ in
                guard let self else { return }
                self.isDisabled = false
            }
            .store(in: &cancelable)
    }

    override func start() {
    }
}
