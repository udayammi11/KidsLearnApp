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
    @State private var username = ""
    @State private var pin = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to Kids Learn")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            // Login form
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                
                SecureField("PIN (4 digits)", text: $pin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .onChange(of: pin) { newValue in
                        if newValue.count > 4 {
                            pin = String(newValue.prefix(4))
                        }
                    }
                
                Button("Login") {
                    login()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
                .disabled(username.isEmpty || pin.count != 4)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
                    .padding(.horizontal)
            }
            
            Divider()
                .padding(.horizontal)
            
            // Alternative options
            VStack(spacing: 12) {
                Button {
                    showCreateAccount = true
                } label: {
                    Text("Create New Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Button {
                    // Guest login
                    _ = appState.createUser(username: "guest_\(Int.random(in: 1000...9999))",
                                           name: "Guest",
                                           pin: nil)
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
            
            Spacer()
        }
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
    }
    
    private func login() {
        if appState.login(username: username, pin: pin) {
            // Success - navigation will happen automatically via appState
            username = ""
            pin = ""
            errorMessage = ""
        } else {
            errorMessage = "Invalid username or PIN"
        }
    }
}
