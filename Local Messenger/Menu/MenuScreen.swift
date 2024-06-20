//
// MenuScreen.swift
// 
//
//

import SwiftUI
import Foundation

enum LocalMessengerNavigationPath: Hashable {
    
    case chat
    case setting
    
    func hash(into hasher: inout Hasher) {
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100)
            .padding()
            .background(.blue.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}


struct MenuScreen: View {
    @State
    var path: NavigationPath = .init()
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Button("START_CHATTING") {
                        path.append(LocalMessengerNavigationPath.chat)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    Button("SETTINGS") {
                        path.append(LocalMessengerNavigationPath.setting)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                .navigationDestination(for: LocalMessengerNavigationPath.self)
                { pathTo in
                    switch pathTo {
                        case .chat:
                            MainChatView()
                        case .setting:
                            Text("implement me")
                    }
                }
            }
        }
    }
}

#Preview {
    MenuScreen()
}
