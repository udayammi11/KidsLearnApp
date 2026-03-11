//
//  HomeView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let count: Int
    let total: Int
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(count)/\(total)")
                    .font(.headline)
                    .bold()
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct HomeCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingProgress = false
    @State private var navigateToAlphabets = false
    @State private var navigateToNumbers = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Welcome header with user info, progress and logout
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        // Welcome message with user name
                        HStack(spacing: 4) {
                            Image(systemName: "hand.wave.fill")
                                .foregroundColor(.yellow)
                                .font(.title3)
                            
                            Text("Welcome,")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(appState.currentUser?.name ?? "Learner")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        
                        // Language and progress
                        HStack(spacing: 6) {
                            Text(appState.selectedLanguage.emoji)
                                .font(.title3)
                            Text(appState.selectedLanguage.displayName)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: progressPercentage)
                            .tint(.green)
                            .frame(width: 120)
                    }
                    
                    Spacer(minLength: 8)
                    
                    HStack(spacing: 12) {
                        // Progress button
                        Button {
                            showingProgress.toggle()
                        } label: {
                            Image(systemName: "chart.bar.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        // Language change button
                        NavigationLink(destination: LanguageSelectView()) {
                            Image(systemName: "globe")
                                .font(.title3)
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        // Logout button
                        Button {
                            appState.logout()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title3)
                                .foregroundColor(.red)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                
                // Stats cards
                HStack(spacing: 12) {
                    StatCard(title: "Letters", count: completedLetters, total: totalLetters, icon: "textformat.abc")
                    StatCard(title: "Numbers", count: completedNumbers, total: totalNumbers, icon: "123.rectangle")
                }
                .padding(.horizontal)
                
                // Cards grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    // Alphabets Card
                    Button {
                        navigateToAlphabets = true
                    } label: {
                        HomeCard(
                            title: "Alphabet",
                            icon: "textformat.abc",
                            color: .blue,
                            progress: alphabetProgress
                        )
                    }
                    .buttonStyle(HomeCardButtonStyle())
                    
                    // Numbers Card
                    Button {
                        navigateToNumbers = true
                    } label: {
                        HomeCard(
                            title: "Numbers",
                            icon: "123.rectangle",
                            color: .green,
                            progress: numbersProgress
                        )
                    }
                    .buttonStyle(HomeCardButtonStyle())
                    
                    // Colors Card (disabled)
                    HomeCard(
                        title: "Colors",
                        icon: "paintpalette.fill",
                        color: .orange,
                        disabled: true
                    )
                    
                    // Rhymes Card (disabled)
                    HomeCard(
                        title: "Rhymes",
                        icon: "music.note.list",
                        color: .purple,
                        disabled: true
                    )
                }
                .padding(.horizontal)
                
                // Optional: Show user type (Guest or PIN protected)
                if let user = appState.currentUser {
                    HStack {
                        Spacer()
                        Label(
                            user.isGuest ? "Guest User" : "PIN Protected",
                            systemImage: user.isGuest ? "person" : "lock.shield"
                        )
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Kids Learn")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingProgress) {
            ProgressStatsView()
                .environmentObject(appState)
        }
        .navigationDestination(isPresented: $navigateToAlphabets) {
            AlphabetView()
        }
        .navigationDestination(isPresented: $navigateToNumbers) {
            NumbersView()
        }
    }
    
    // Computed properties for progress
    private var totalLetters: Int {
        ContentData.letters(for: appState.selectedLanguage).count
    }
    
    private var completedLetters: Int {
        appState.progress.completedLetters.count
    }
    
    private var totalNumbers: Int {
        ContentData.numbers(for: appState.selectedLanguage).count
    }
    
    private var completedNumbers: Int {
        appState.progress.completedNumbers.count
    }
    
    private var progressPercentage: Double {
        let total = totalLetters + totalNumbers
        let completed = completedLetters + completedNumbers
        return total > 0 ? Double(completed) / Double(total) : 0
    }
    
    private var alphabetProgress: Double {
        totalLetters > 0 ? Double(completedLetters) / Double(totalLetters) : 0
    }
    
    private var numbersProgress: Double {
        totalNumbers > 0 ? Double(completedNumbers) / Double(totalNumbers) : 0
    }
}
