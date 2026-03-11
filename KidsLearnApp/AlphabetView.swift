//
//  AlphabetView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

// Move AlphabetCard outside AlphabetView
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
                Text(item.symbol)
                    .font(.system(size: 42, weight: .bold))
                
                if score > 0 {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(score)%")
                                .font(.caption2)
                                .bold()
                                .padding(4)
                                .background(scoreColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                }
            }
            
            Text(item.exampleEmoji)
                .font(.system(size: 28))
            
            if score >= 80 {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .font(.caption)
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
