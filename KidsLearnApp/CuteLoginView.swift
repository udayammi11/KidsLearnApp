//
//  CuteLoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

//
//  CuteLoginView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct CuteLoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateAccount = false
    @State private var username = ""
    @State private var pin = ""
    @State private var errorMessage = ""
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            // Sky background
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Clouds
            CloudShape()
                .fill(.white.opacity(0.5))
                .offset(x: -50, y: -200)
                .blur(radius: 20)
            
            CloudShape()
                .fill(.white.opacity(0.5))
                .offset(x: 100, y: -150)
                .blur(radius: 30)
            
            VStack(spacing: 30) {
                // Animal characters
                HStack(spacing: 20) {
                    AnimalIcon(animal: "🐶", color: .orange, bounce: bounce)
                    AnimalIcon(animal: "🐱", color: .gray, bounce: bounce, delay: 0.2)
                    AnimalIcon(animal: "🐼", color: .brown, bounce: bounce, delay: 0.4)
                    AnimalIcon(animal: "🐸", color: .green, bounce: bounce, delay: 0.6)
                }
                .padding(.top, 50)
                
                Text("Kids Learn")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .blue, radius: 10, x: 0, y: 5)
                
                // Login card
                VStack(spacing: 20) {
                    Text("Who's learning today?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Username field with animal
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.orange)
                        
                        TextField("Enter your name", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // PIN field
                    SecureField("Secret PIN (4 digits)", text: $pin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    Button("Login") {
                        // Login action
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                bounce.toggle()
            }
        }
    }
}

struct AnimalIcon: View {
    let animal: String
    let color: Color
    let bounce: Bool
    var delay: Double = 0
    
    var body: some View {
        Text(animal)
            .font(.system(size: 50))
            .background(
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: 70, height: 70)
            )
            .offset(y: bounce ? -10 : 0)
            .animation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: bounce
            )
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: 0, y: 0, width: rect.width * 0.5, height: rect.height))
        path.addEllipse(in: CGRect(x: rect.width * 0.3, y: -rect.height * 0.2, width: rect.width * 0.4, height: rect.height * 1.2))
        path.addEllipse(in: CGRect(x: rect.width * 0.6, y: 0, width: rect.width * 0.3, height: rect.height))
        return path
    }
}
