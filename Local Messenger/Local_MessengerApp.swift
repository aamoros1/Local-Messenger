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
            MenuScreen()
        }
    }
}
