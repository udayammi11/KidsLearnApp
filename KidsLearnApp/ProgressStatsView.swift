//
//  ProgressStatsView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct ProgressStatsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Alphabets") {
                    let letters = ContentData.letters(for: appState.selectedLanguage)
                    ForEach(letters, id: \.symbol) { letter in
                        HStack {
                            Text(letter.symbol)
                                .font(.title2)
                                .bold()
                                .frame(width: 50)
                            
                            Text(letter.exampleWord)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            let score = appState.progress.getScore(for: letter.symbol)
                            if score > 0 {
                                Text("\(score)%")
                                    .foregroundColor(score >= 80 ? .green : .orange)
                                    .bold()
                            } else {
                                Text("Not started")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section("Numbers") {
                    let numbers = ContentData.numbers(for: appState.selectedLanguage)
                    ForEach(numbers, id: \.number) { number in
                        HStack {
                            Text(number.display)
                                .font(.title2)
                                .bold()
                                .frame(width: 50)
                            
                            Text(number.word)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if appState.progress.completedNumbers.contains(number.number) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Text("Not started")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
