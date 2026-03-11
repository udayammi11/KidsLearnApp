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
        didSet { saveCurrentUser() }
    }
    
    @Published var allUsers: [User] = [] {
        didSet { saveAllUsers() }
    }
    
    @Published var progress = ProgressManager()
    
    private let userDefaults = UserDefaults.standard
    private let languageKey = "selectedLanguage"
    private let currentUserKey = "currentUser"
    private let allUsersKey = "allUsers"
    
    init() {
        self.selectedLanguage = Self.loadLanguage()
        self.allUsers = Self.loadAllUsers()
        self.currentUser = Self.loadCurrentUser()
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
    
    private func saveCurrentUser() {
        if let user = currentUser, let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: currentUserKey)
        } else {
            userDefaults.removeObject(forKey: currentUserKey)
        }
    }
    
    private static func loadCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "currentUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    private func saveAllUsers() {
        if let data = try? JSONEncoder().encode(allUsers) {
            userDefaults.set(data, forKey: allUsersKey)
        }
    }
    
    private static func loadAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: "allUsers"),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    func login(username: String, pin: String) -> Bool {
        guard let user = allUsers.first(where: { $0.username == username.lowercased() }) else {
            return false
        }
        
        if user.validate(pin: pin) {
            currentUser = user
            return true
        }
        return false
    }
    
    func createUser(username: String, name: String, pin: String?) -> Bool {
        // Check if username already exists
        guard !allUsers.contains(where: { $0.username == username.lowercased() }) else {
            return false
        }
        
        let newUser = User(username: username, name: name, pin: pin)
        allUsers.append(newUser)
        currentUser = newUser
        return true
    }
    
    func logout() {
        currentUser = nil
    }
}
