//
//  AppLanguage.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english
    case telugu
    case hindi
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .telugu:  return "తెలుగు"
        case .hindi:   return "हिंदी"
        }
    }
    
    var emoji: String {
        switch self {
        case .english: return "🇬🇧"
        case .telugu:  return "🇮🇳"
        case .hindi:   return "🇮🇳"
        }
    }
}
