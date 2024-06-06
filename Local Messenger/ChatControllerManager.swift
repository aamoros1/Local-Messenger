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

final class LocalPeerToPeerConnectionManager: PeerToPeerConnectionManager {
    override func invitePeer<Obj>(with peerID: MCPeerID, withContext context: Obj? = nil) where Obj: Codable {
        
    }
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
        connectionManager.connectedPeers
            .publisher
            .sink { [weak self] _ in
                self?.isDisabled = self?.connectionManager.connectedPeers.isEmpty ?? true
            }
            .store(in: &cancelable)
    }

    
}
