//
//  CreateAccountView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var name = ""
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var usePin = true
    @State private var errorMessage = ""
    
    var body: some View {
        Form {
            Section("Account Information") {
                TextField("Username (for login)", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Child's Name (display name)", text: $name)
                    .autocapitalization(.words)
            }
            
            Section {
                Toggle("Protect with PIN", isOn: $usePin.animation())
            }
            
            if usePin {
                Section("Set a 4-digit PIN") {
                    SecureField("PIN", text: $pin)
                        .keyboardType(.numberPad)
                        .onChange(of: pin) { newValue in
                            if newValue.count > 4 {
                                pin = String(newValue.prefix(4))
                            }
                        }
                    
                    SecureField("Confirm PIN", text: $confirmPin)
                        .keyboardType(.numberPad)
                        .onChange(of: confirmPin) { newValue in
                            if newValue.count > 4 {
                                confirmPin = String(newValue.prefix(4))
                            }
                        }
                }
            }
            
            Section {
                Button("Create Account") {
                    createAccount()
                }
                .frame(maxWidth: .infinity)
                .disabled(username.isEmpty || name.isEmpty)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
        }
        .navigationTitle("New Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private func createAccount() {
        let trimmedUsername = username.lowercased().trimmingCharacters(in: .whitespaces)
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedUsername.isEmpty else {
            errorMessage = "Please enter a username"
            return
        }
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a name"
            return
        }
        
        if usePin {
            guard pin.count == 4, pin.allSatisfy({ $0.isNumber }) else {
                errorMessage = "PIN must be 4 digits"
                return
            }
            guard pin == confirmPin else {
                errorMessage = "PINs do not match"
                return
            }
        }
        
        if appState.createUser(username: trimmedUsername, name: trimmedName, pin: usePin ? pin : nil) {
            dismiss()
        } else {
            errorMessage = "Username already exists. Please choose another."
        }
    }
}
