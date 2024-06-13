//
// Local_MessengerApp.swift
// 
// 
// 

	

import SwiftUI

@main
struct Local_MessengerApp: App {
    @State var path: NavigationPath = .init()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                Button("Start Chaitting") {
                    path.append("a")
                }
                .navigationDestination(for: String.self) { _ in
                    MainChatView()
                }
            }
        }
    }
}
