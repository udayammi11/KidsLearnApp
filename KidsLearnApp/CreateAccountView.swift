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
    @State private var name = ""
    @State private var pin = ""
    @State private var confirmPin = ""
    @State private var usePin = false
    @State private var errorMessage = ""
    
    var body: some View {
        Form {
            Section("Learner Information") {
                TextField("Child's Name", text: $name)
                    .autocapitalization(.words)
            }
            
            Section {
                Toggle("Use PIN for returning", isOn: $usePin.animation())
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
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("New Learner")
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
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
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
            appState.currentUser = User(name: trimmedName, pin: pin)
        } else {
            appState.currentUser = User(name: trimmedName, pin: nil)
        }
        dismiss()
    }
}
