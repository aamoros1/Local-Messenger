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
        connectionManager
            .dataReceiverPublisher
            .receive(on: DispatchQueue.main)
            .map { (data: Data, peer: MCPeerID) -> (content: String?, peerName: String) in
                let content = String(data: data, encoding: .utf8)
                let peerName = peer.displayName
                return (content: content, peerName: peerName)
            }
            .map { [ChatRemoteMessage($0.content ?? "??", identifier: $0.peerName)] }
            .sink { [weak self] messages in
                guard let self else { return }
                self.messages += messages
            }
            .store(in: &cancelable)
    }

    override func sendMessage(message: String) async {
        await super.sendMessage(message: message)
        connectionManager.sendData(message)
    }

    override func userTappedSubmit(params: String...) {
        chatStatus = .chatting
    }

    override func end() {
        cancelable.removeAll()
    }
}
