//
//  Models.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import Foundation

struct LetterItem: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let exampleWord: String
    let exampleEmoji: String
    let gifName: String?  // New: GIF name
    let audioName: String?
    
    init(symbol: String, exampleWord: String, exampleEmoji: String, gifName: String? = nil, audioName: String?) {
        self.symbol = symbol
        self.exampleWord = exampleWord
        self.exampleEmoji = exampleEmoji
        self.gifName = gifName
        self.audioName = audioName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LetterItem, rhs: LetterItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct NumberItem: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let display: String
    let word: String
    let gifName: String?  // New: GIF name
    let audioName: String?
    
    init(number: Int, display: String, word: String, gifName: String? = nil, audioName: String?) {
        self.number = number
        self.display = display
        self.word = word
        self.gifName = gifName
        self.audioName = audioName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NumberItem, rhs: NumberItem) -> Bool {
        lhs.id == rhs.id
    }
}
