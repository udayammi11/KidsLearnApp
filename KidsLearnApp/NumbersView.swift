//
//  NumbersView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import SwiftUI

struct NumbersView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedNumber: NumberItem?
    private let audio = SimpleAudioPlayer.shared
    
    var body: some View {
        let items = ContentData.numbers(for: appState.selectedLanguage)
        let filteredItems = searchText.isEmpty ? items : items.filter {
            $0.display.contains(searchText) ||
            $0.word.localizedCaseInsensitiveContains(searchText)
        }
        
        List {
            ForEach(filteredItems) { item in
                Button {
                    selectedNumber = item
                    audio.play(named: item.audioName)
                } label: {
                    HStack(spacing: 16) {
                        Text(item.display)
                            .font(.system(size: 34, weight: .bold))
                            .frame(width: 70, alignment: .leading)
                            .foregroundColor(appState.progress.completedNumbers.contains(item.number) ? .green : .primary)
                        
                        VStack(alignment: .leading) {
                            Text(item.word)
                                .font(.title3)
                            Text("Number \(item.number)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if appState.progress.completedNumbers.contains(item.number) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                        
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .navigationTitle("Numbers")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedNumber) { item in
            NumberDetailView(item: item)
        }
    }
}

struct NumberDetailView: View {
    let item: NumberItem
    @Environment(\.dismiss) var dismiss
    @State private var count = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text(item.display)
                    .font(.system(size: 100, weight: .bold))
                
                Text(item.word)
                    .font(.largeTitle)
                
                HStack(spacing: 20) {
                    ForEach(0..<min(item.number, 10), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                }
                
                // Simple counting practice
                VStack {
                    Text("Count to \(item.number)")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        ForEach(0..<item.number, id: \.self) { i in
                            Circle()
                                .fill(i < count ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        count = i + 1
                                        if count == item.number {
                                            let generator = UINotificationFeedbackGenerator()
                                            generator.notificationOccurred(.success)
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Number \(item.number)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
