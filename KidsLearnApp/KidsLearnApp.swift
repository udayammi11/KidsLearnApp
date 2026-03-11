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
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    
    var body: some View {
        VStack {
            if isActive {
                if appState.currentUser == nil {
                    LoginView()
                } else if appState.selectedLanguage == .english {
                    HomeView()
                } else {
                    LanguageSelectView()
                }
            } else {
                VStack(spacing: 30) {
                    // Use any of the logo designs here
                    AppLogo(size: 180, animate: true)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Text("Kids Learn")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .opacity(logoOpacity)
                    
                    Text("తెలుగు • हिंदी • English")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .opacity(logoOpacity)
                    
                    ProgressView()
                        .tint(.blue)
                        .scaleEffect(1.2)
                        .padding(.top, 20)
                        .opacity(logoOpacity)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}
