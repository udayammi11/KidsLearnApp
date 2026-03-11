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
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(count)/\(total)")
                    .font(.headline)
                    .bold()
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct HomeCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
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
            VStack(spacing: 18) {
                // Language header with progress
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(appState.selectedLanguage.emoji)
                                .font(.title2)
                            Text(appState.selectedLanguage.displayName)
                                .font(.headline)
                        }
                        
                        ProgressView(value: progressPercentage)
                            .tint(.green)
                            .frame(width: 100)
                    }
                    
                    Spacer()
                    
                    Button {
                        showingProgress.toggle()
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: LanguageSelectView()) {
                        Label("Change", systemImage: "globe")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                    // Alphabets Card
                    Button {
                        print("✅ Alphabets card tapped")
                        navigateToAlphabets = true
                    } label: {
                        HomeCard(
                            title: "Alphabets",
                            icon: "textformat.abc",
                            color: .blue,
                            progress: alphabetProgress
                        )
                    }
                    .buttonStyle(HomeCardButtonStyle())
                    
                    // Numbers Card
                    Button {
                        print("✅ Numbers card tapped")
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
                    
                    HomeCard(
                        title: "Colors",
                        icon: "paintpalette.fill",
                        color: .orange,
                        disabled: true
                    )
                    
                    HomeCard(
                        title: "Rhymes",
                        icon: "music.note.list",
                        color: .purple,
                        disabled: true
                    )
                }
                .padding()
            }
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
