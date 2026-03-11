//
//  KidsLearnApp.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

@main
struct KidsLearnApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
            }
            .environmentObject(appState)
        }
    }
}

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                if appState.selectedLanguage == .english {
                    HomeView()
                } else {
                    LanguageSelectView()
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "abcube")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    Text("Kids Learn")
                        .font(.largeTitle)
                        .bold()
                    ProgressView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
