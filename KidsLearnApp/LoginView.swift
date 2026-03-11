//
//  LoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateAccount = false
    @State private var showReturning = false
    @State private var pin = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to Kids Learn")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                // New Learner button
                Button {
                    showCreateAccount = true
                } label: {
                    Label("New Learner", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                // Returning Learner button
                Button {
                    showReturning = true
                } label: {
                    Label("Returning Learner", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                // Guest button
                Button {
                    appState.currentUser = User(name: "Guest", pin: nil)
                } label: {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .padding(.horizontal)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
        .sheet(isPresented: $showReturning) {
            ReturningLoginView(pin: $pin, errorMessage: $errorMessage) { success in
                if success {
                    showReturning = false
                }
            }
        }
    }
}

struct ReturningLoginView: View {
    @EnvironmentObject var appState: AppState
    @Binding var pin: String
    @Binding var errorMessage: String
    var onComplete: (Bool) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter your PIN") {
                    SecureField("4-digit PIN", text: $pin)
                        .keyboardType(.numberPad)
                        .onChange(of: pin) { newValue in
                            if newValue.count > 4 {
                                pin = String(newValue.prefix(4))
                            }
                        }
                }
                
                Section {
                    Button("Login") {
                        if let user = appState.currentUser {
                            if user.validate(pin: pin) {
                                onComplete(true)
                                dismiss()
                            } else {
                                errorMessage = "Incorrect PIN"
                            }
                        } else {
                            errorMessage = "No saved user. Please create an account."
                        }
                    }
                    .frame(maxWidth: .infinity)
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
