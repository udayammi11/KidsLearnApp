//
//  LetterDetailView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI
import PencilKit

struct LetterDetailView: View {
    let item: LetterItem
    @EnvironmentObject var appState: AppState
    @State private var showingPractice = false
    @State private var animateCard = false
    private let audio = SimpleAudioPlayer.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Animated GIF or Emoji
                if let gifName = item.gifName {
                    GIFView(gifName: gifName, width: 150, height: 150, shouldLoop: true)
                        .padding(.top)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 160, height: 160)
                        )
                } else {
                    Text(item.exampleEmoji)
                        .font(.system(size: 100))
                        .padding(.top)
                        .frame(width: 150, height: 150)
                        .background(
                            Circle()
                                .fill(Color(.secondarySystemBackground))
                        )
                }
                
                // Letter card
                VStack(spacing: 12) {
                    Text(item.symbol)
                        .font(.system(size: 100, weight: .bold))
                        .scaleEffect(animateCard ? 1 : 0.5)
                        .opacity(animateCard ? 1 : 0)
                    
                    Text(item.exampleWord)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal)
                
                // Action buttons
                HStack(spacing: 15) {
                    Button {
                        audio.play(named: item.audioName)
                    } label: {
                        Label("Listen", systemImage: "speaker.wave.2.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button {
                        withAnimation {
                            showingPractice.toggle()
                        }
                    } label: {
                        Label("Practice", systemImage: "pencil.tip")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(.horizontal)
                
                // Practice area
                if showingPractice {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Practice Writing")
                            .font(.title2.bold())
                            .padding(.leading)
                        
                        PracticeView(letter: item.symbol)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .padding(.top)
                }
                
                // Previous score
                let score = appState.progress.getScore(for: item.symbol)
                if score > 0 {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Your Best Score")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(score)%")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(score >= 80 ? .green : .orange)
                        }
                        
                        Spacer()
                        
                        if score >= 80 {
                            Image(systemName: "star.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                                .symbolEffect(.bounce, value: score)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Learn \(item.symbol)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateCard = true
            }
            
            // Preload GIF
            if let gifName = item.gifName {
                GIFPreloader.shared.preloadGIF(named: gifName)
            }
        }
    }
}
