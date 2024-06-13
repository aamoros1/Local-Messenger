//
// ContentView.swift
// 
// 


import SwiftUI
import PeerToPeerConnection
import ChatLibrary
import Combine



struct PeerConnectionView: View {
    @Environment(ChatControllerManager.self)
    var chatManager
    
    var body: some View {
        List {
            Section("Found Peers") {
                ForEach(chatManager.connectionManager.foundPeers, id: \.displayName) { peer in
                    Button {
                        chatManager.connectionManager.invitePeer(with: peer, withContext: "")
                    } label: {
                        Text(peer.displayName)
                    }
                }
            }
            Section("Connected Peers") {
                ForEach(chatManager.connectionManager.connectedPeers, id: \.peerID) {
                    Text($0.peerID.displayName)}
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    advertisingButton
                    browsingButton
                } label: {
                    Text("+")
                }
            }
        }
    }
}

extension PeerConnectionView {
    var advertisingButton: some View {
        Button {
            chatManager.connectionManager.isAdvertising.toggle()
        } label: {
            Label(
                title: {
                    Text(chatManager.connectionManager.isAdvertising ?
                          "Stop Advertising Session": "Start Advertising Session")
                }, icon: {
                    Image(
                        systemName: chatManager.connectionManager.isAdvertising ? "antenna.radiowaves.left.and.right.slash" : "antenna.radiowaves.left.and.right"
                    )
                }
            )
        }
    }

    var browsingButton: some View {
        Button {
            chatManager.connectionManager.isBrowsing.toggle()
        } label: {
            Label(
                title: {
                    Text(chatManager.connectionManager.isBrowsing ?
                          "Stop Scanning": "Start Scanning")
                }, icon: {
                    Image(
                        systemName: chatManager.connectionManager.isBrowsing ? "wifi.slash" : "wifi"
                    )
                }
            )
        }
    }
}



#Preview {
    NavigationStack {
        MainChatView()
    }
}


