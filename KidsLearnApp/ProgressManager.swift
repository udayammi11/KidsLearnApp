//
//  ProgressManager.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import Foundation
import SwiftUI
import Combine

class ProgressManager: ObservableObject {
    @Published var completedLetters: Set<String> = []
    @Published var completedNumbers: Set<Int> = []
    @Published var practiceScores: [String: Int] = [:]
    
    private let defaults = UserDefaults.standard
    private let scoresKey = "practiceScores"
    private let lettersKey = "completedLetters"
    private let numbersKey = "completedNumbers"
    
    init() {
        // Use a defer block or call after initialization
        defer {
            loadProgress()
        }
    }
    
    func updateScore(for letter: String, score: Int) {
        if score > (practiceScores[letter] ?? 0) {
            practiceScores[letter] = score
            if score >= 80 {
                completedLetters.insert(letter)
            }
            saveProgress()
        }
    }
    
    func updateNumberProgress(_ number: Int, completed: Bool) {
        if completed {
            completedNumbers.insert(number)
        } else {
            completedNumbers.remove(number)
        }
        saveProgress()
    }
    
    func getScore(for letter: String) -> Int {
        return practiceScores[letter] ?? 0
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(practiceScores) {
            defaults.set(encoded, forKey: scoresKey)
        }
        defaults.set(Array(completedLetters), forKey: lettersKey)
        defaults.set(Array(completedNumbers), forKey: numbersKey)
    }
    
    private func loadProgress() {
        if let data = defaults.data(forKey: scoresKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            practiceScores = decoded
        }
        
        if let letters = defaults.array(forKey: lettersKey) as? [String] {
            completedLetters = Set(letters)
        }
        
        if let numbers = defaults.array(forKey: numbersKey) as? [Int] {
            completedNumbers = Set(numbers)
        }
    }
    
    func resetProgress() {
        completedLetters.removeAll()
        completedNumbers.removeAll()
        practiceScores.removeAll()
        saveProgress()
    }
}
