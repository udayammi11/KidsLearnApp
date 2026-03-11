//
//  User.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var username: String  // Unique identifier for login
    var name: String       // Display name
    var pinHash: String?   // nil for guest
    
    init(username: String, name: String, pin: String? = nil) {
        self.id = UUID()
        self.username = username.lowercased().trimmingCharacters(in: .whitespaces)
        self.name = name.trimmingCharacters(in: .whitespaces)
        if let pin = pin {
            // Simple hash for demo (not secure, but fine for kids app)
            self.pinHash = String(pin.hash)
        } else {
            self.pinHash = nil
        }
    }
    
    var isGuest: Bool { pinHash == nil }
    
    func validate(pin: String) -> Bool {
        guard let hash = pinHash else { return false }
        return hash == String(pin.hash)
    }
}
