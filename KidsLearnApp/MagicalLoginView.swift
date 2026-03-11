//
//  MagicalLoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

//
//  MagicalLoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct MagicalLoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateAccount = false
    @State private var username = ""
    @State private var pin = ""
    @State private var errorMessage = ""
    @State private var sparkle = false
    
    var body: some View {
        ZStack {
            // Starry background
            Color.black.ignoresSafeArea()
            
            // Stars
            ForEach(0..<50) { i in
                Circle()
                    .fill(Color.white)
                    .frame(width: CGFloat.random(in: 2...4), height: CGFloat.random(in: 2...4))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(sparkle ? 1 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.02),
                        value: sparkle
                    )
            }
            
            // Magic circle
            Circle()
                .stroke(
                    LinearGradient(colors: [.purple, .pink, .orange], startPoint: .top, endPoint: .bottom),
                    lineWidth: 3
                )
                .frame(width: 300, height: 300)
                .blur(radius: 10)
                .scaleEffect(sparkle ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sparkle)
            
            VStack(spacing: 30) {
                // Magic wand and hat
                HStack {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 50))
                        .foregroundColor(.purple)
                        .rotationEffect(.degrees(sparkle ? 15 : -15))
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                }
                
                Text("Welcome to the")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Magic Learning")
                    .font(.system(size: 45, weight: .black))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                // Magic login form
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.purple)
                        TextField("Your magical name", text: $username)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.pink)
                        SecureField("Magic code (4 digits)", text: $pin)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Button("Cast Login Spell") {
                        // Login action
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            sparkle = true
        }
    }
}
