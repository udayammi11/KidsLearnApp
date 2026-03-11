//
//  Models.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation

struct LetterItem: Identifiable, Hashable {
    let id = UUID()
    let symbol: String      // e.g., "A", "అ", "अ"
    let exampleWord: String // e.g., "Apple", "అమ్మ", "अनार"
    let exampleEmoji: String // quick placeholder instead of images
    let audioName: String?  // optional: "en_A", "te_అ", etc.
}

struct NumberItem: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let display: String     // e.g., "1", "౧", "१"
    let word: String        // e.g., "One", "ఒకటి", "एक"
    let audioName: String?  // optional
}
