//
//  AppState.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation
import Combine

/// Global app state for language selection and progress tracking.
/// Persists the selected language in UserDefaults.
final class AppState: ObservableObject {
    
    /// The currently selected app language.
    @Published var selectedLanguage: AppLanguage {
        didSet { saveLanguage() }
    }
    
    /// Progress tracking for completed letters and scores
    @Published var progress = ProgressManager()
    
    // MARK: - Init
    init() {
        self.selectedLanguage = Self.loadLanguage()
    }
    
    // MARK: - Persistence
    private func saveLanguage() {
        UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Self.udKey)
    }
    
    private static func loadLanguage() -> AppLanguage {
        if let raw = UserDefaults.standard.string(forKey: Self.udKey),
           let lang = AppLanguage(rawValue: raw) {
            return lang
        }
        return .english
    }
    
    private static let udKey = "selectedLanguage"
}
