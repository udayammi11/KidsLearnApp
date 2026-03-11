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
    @State private var username = ""
    @State private var pin = ""
    @State private var errorMessage = ""
    @State private var isAnimating = false
    @State private var showingPin = false
    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.purple.opacity(0.4),
                    Color.pink.opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating bubbles
            ZStack {
                ForEach(0..<6) { i in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.2),
                                    Color.purple.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: CGFloat.random(in: 100...200))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .blur(radius: 30)
                        .offset(y: isAnimating ? -20 : 20)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...5))
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    // Animated logo section with floating characters
                    VStack(spacing: 15) {
                        // Animated characters
                        HStack(spacing: 20) {
                            ForEach(["📚", "✏️", "🎨"], id: \.self) { emoji in
                                Text(emoji)
                                    .font(.system(size: 50))
                                    .offset(y: isAnimating ? -15 : 15)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(emoji.hashValue) * 0.2),
                                        value: isAnimating
                                    )
                            }
                        }
                        
                        // App logo
                        AppLogo(size: 120, animate: true)
                            .padding(.vertical, 10)
                        
                        // Welcome text with gradient
                        Text("Welcome to")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Kids Learn")
                            .font(.system(size: 45, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Language pills
                        HStack(spacing: 12) {
                            LanguagePill(text: "English", emoji: "🇬🇧", color: .blue)
                            LanguagePill(text: "తెలుగు", emoji: "🇮🇳", color: .purple)
                            LanguagePill(text: "हिंदी", emoji: "🇮🇳", color: .pink)
                        }
                    }
                    
                    // Login card with glass morphism
                    VStack(spacing: 20) {
                        // Welcome back message
                        HStack {
                            Image(systemName: "hand.wave.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            Text("Welcome Back!")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        // Username field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                
                                TextField("Enter your username", text: $username)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                        
                        // PIN field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PIN")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.purple)
                                    .frame(width: 30)
                                
                                if showingPin {
                                    TextField("Enter 4-digit PIN", text: $pin)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                } else {
                                    SecureField("Enter 4-digit PIN", text: $pin)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                                
                                Button {
                                    showingPin.toggle()
                                } label: {
                                    Image(systemName: showingPin ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.purple.opacity(0.5), .pink.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                        
                        // Error message
                        if !errorMessage.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Login button
                        Button(action: login) {
                            HStack {
                                Text("Login")
                                    .font(.headline)
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(username.isEmpty || pin.count != 4)
                        .opacity((username.isEmpty || pin.count != 4) ? 0.5 : 1.0)
                        .scaleEffect(isAnimating ? 1.02 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    }
                    .padding(25)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                    .padding(.horizontal)
                    
                    // Alternative options
                    VStack(spacing: 12) {
                        // Divider with text
                        HStack {
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("New here?")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal)
                        
                        // Create account button
                        Button {
                            showCreateAccount = true
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Create New Account")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.green.opacity(0.5), .blue.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                            )
                            .foregroundColor(.green)
                        }
                        
                        // Guest button
                        Button {
                            createGuestAccount()
                        } label: {
                            HStack {
                                Image(systemName: "person")
                                Text("Continue as Guest")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Footer with learning icons
                    HStack(spacing: 25) {
                        ForEach(["star.fill", "heart.fill", "book.fill"], id: \.self) { icon in
                            Image(systemName: icon)
                                .foregroundColor(.yellow)
                                .font(.title3)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                .padding(.top, 40)
                .offset(y: -keyboardOffset)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showCreateAccount) {
            CreateAccountView()
        }
        .onAppear {
            isAnimating = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    keyboardOffset = keyboardFrame.height * 0.3
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                keyboardOffset = 0
            }
        }
    }
    
    private func login() {
        if appState.login(username: username, pin: pin) {
            username = ""
            pin = ""
            errorMessage = ""
        } else {
            withAnimation {
                errorMessage = "Invalid username or PIN"
                pin = ""
            }
        }
    }
    
    private func createGuestAccount() {
        let guestNumber = Int.random(in: 1000...9999)
        _ = appState.createUser(
            username: "guest\(guestNumber)",
            name: "Guest",
            pin: nil
        )
    }
}

// MARK: - Language Pill Component
struct LanguagePill: View {
    let text: String
    let emoji: String
    let color: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Text(emoji)
                .font(.caption)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
        .scaleEffect(isAnimating ? 1.1 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
    }
}
