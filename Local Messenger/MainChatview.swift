//
// MainChatview.swift
// 
//
// 

	
import SwiftUI
import Foundation
import ChatLibrary

struct MainChatView: View {
    @State
    var chatManager = ChatControllerManager()
    
    var body: some View {
        ChatContainerView<ChatControllerManager, PeerConnectionView>(chatController: chatManager) {
            PeerConnectionView()
        }
        .environment(chatManager)
        .alert(chatManager.chatAlert?.alertTitle ?? "Alert",
               isPresented: $chatManager.showAlert,
               presenting: chatManager.chatAlert)
        { newAlert in
            ForEach(newAlert.actions) { alertAction in
                Button(alertAction.title,
                       role: alertAction.buttonRole,
                       action: alertAction.action)
            }
        } message: { newAlert in
            Text(newAlert.alertBodyMessage)
        }
        
    }
}
