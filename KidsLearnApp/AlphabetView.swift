//
//  AlphabetView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct AlphabetCard: View {
    let item: LetterItem
    let score: Int
    
    var scoreColor: Color {
        switch score {
        case 0: return .clear
        case 1..<50: return .orange
        case 50..<80: return .yellow
        default: return .green
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Animated GIF or Emoji
                if let gifName = item.gifName {
                    GIFView(gifName: gifName, width: 60, height: 60, shouldLoop: true)
                        .clipShape(Circle())
                } else {
                    Text(item.exampleEmoji)
                        .font(.system(size: 40))
                }
                
                // Letter overlay
                Text(item.symbol)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary.opacity(0.2))
            }
            .frame(height: 70)
            
            // Score badge
            if score > 0 {
                Text("\(score)%")
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(scoreColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            } else {
                Text("New")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.gray)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(scoreColor.opacity(0.5), lineWidth: score > 0 ? 2 : 0)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onAppear {
            // Preload GIF for better performance
            if let gifName = item.gifName {
                GIFPreloader.shared.preloadGIF(named: gifName)
            }
        }
    }
}

struct AlphabetView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    private let audio = SimpleAudioPlayer.shared
    
    var body: some View {
        let items = ContentData.letters(for: appState.selectedLanguage)
        let filteredItems = searchText.isEmpty ? items : items.filter {
            $0.symbol.localizedCaseInsensitiveContains(searchText) ||
            $0.exampleWord.localizedCaseInsensitiveContains(searchText)
        }
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                ForEach(filteredItems) { item in
                    NavigationLink {
                        LetterDetailView(item: item)
                    } label: {
                        AlphabetCard(item: item, score: appState.progress.getScore(for: item.symbol))
                    }
                    .buttonStyle(.plain)
                    .simultaneousGesture(TapGesture().onEnded {
                        audio.play(named: item.audioName)
                    })
                    .accessibilityLabel("Letter \(item.symbol) for \(item.exampleWord)")
                    .accessibilityHint("Double tap to learn and practice")
                }
            }
            .padding()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .navigationTitle("Alphabets")
        .navigationBarTitleDisplayMode(.large)
    }
}
