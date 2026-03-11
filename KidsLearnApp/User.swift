//
//  User.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//


import Foundation

struct User: Codable {
    let id: UUID
    var name: String
    var pinHash: String? // nil for guest
    
    init(name: String, pin: String? = nil) {
        self.id = UUID()
        self.name = name
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
