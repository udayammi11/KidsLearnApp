//
//  ReturningLoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct ReturningLoginView: View {
    @EnvironmentObject var appState: AppState
    @Binding var username: String
    @Binding var pin: String
    @Binding var errorMessage: String
    var onComplete: (Bool) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Login") {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("PIN", text: $pin)
                        .keyboardType(.numberPad)
                        .onChange(of: pin) { newValue in
                            if newValue.count > 4 {
                                pin = String(newValue.prefix(4))
                            }
                        }
                }
                
                Section {
                    Button("Login") {
                        if appState.login(username: username, pin: pin) {
                            onComplete(true)
                            dismiss()
                        } else {
                            errorMessage = "Invalid username or PIN"
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(username.isEmpty || pin.count != 4)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Returning Learner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
