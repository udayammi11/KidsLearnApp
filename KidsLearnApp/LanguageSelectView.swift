//
//  LanguageSelectView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

struct LanguageSelectView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateCards = false
    @State private var navigateToHome = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .symbolEffect(.bounce, value: animateCards)
                
                Text("Choose Language")
                    .font(.largeTitle)
                    .bold()
                
                Text("భాష ఎంచుకోండి • भाषा चुनें")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)
            
            // Language cards
            VStack(spacing: 16) {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            appState.selectedLanguage = lang
                            navigateToHome = true
                        }
                        
                        // Haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        
                    } label: {
                        HStack {
                            Text(lang.emoji)
                                .font(.system(size: 40))
                                .frame(width: 60)
                            
                            Text(lang.displayName)
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            if appState.selectedLanguage == lang {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.title3)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(appState.selectedLanguage == lang ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(appState.selectedLanguage == lang ? Color.blue : Color.clear, lineWidth: 3)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .offset(x: animateCards ? 0 : -300)
                    .opacity(animateCards ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(Double(AppLanguage.allCases.firstIndex(of: lang) ?? 0) * 0.1),
                        value: animateCards
                    )
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView()
        }
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
    }
}
