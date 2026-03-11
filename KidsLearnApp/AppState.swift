//
//  AppState.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    
    @Published var selectedLanguage: AppLanguage {
        didSet { saveLanguage() }
    }
    
    @Published var currentUser: User? {
        didSet { saveUser() }
    }
    
    @Published var progress = ProgressManager()
    
    private let userDefaults = UserDefaults.standard
    private let languageKey = "selectedLanguage"
    private let userKey = "currentUser"
    
    init() {
        self.selectedLanguage = Self.loadLanguage()
        self.currentUser = Self.loadUser()
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    // MARK: - Persistence
    private func saveLanguage() {
        userDefaults.set(selectedLanguage.rawValue, forKey: languageKey)
    }
    
    private static func loadLanguage() -> AppLanguage {
        if let raw = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let lang = AppLanguage(rawValue: raw) {
            return lang
        }
        return .english
    }
    
    private func saveUser() {
        if let user = currentUser, let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        } else {
            userDefaults.removeObject(forKey: userKey)
        }
    }
    
    private static func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "currentUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func logout() {
        currentUser = nil
    }
}
