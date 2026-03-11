//
//  AppLogo.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//


import SwiftUI

struct AppLogo: View {
    var size: CGFloat = 100
    var animate: Bool = false
    
    @State private var rotation = 0.0
    @State private var scale = 1.0
    
    var body: some View {
        ZStack {
            // Background gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
            
            // Inner white circle
            Circle()
                .fill(.white)
                .frame(width: size * 0.85, height: size * 0.85)
                .shadow(color: .white.opacity(0.5), radius: 5, x: 0, y: 2)
            
            // Book icon
            VStack(spacing: size * 0.05) {
                // ABC Design
                HStack(spacing: size * 0.08) {
                    Text("A")
                        .font(.system(size: size * 0.25, weight: .bold))
                        .foregroundColor(.blue)
                    Text("B")
                        .font(.system(size: size * 0.3, weight: .bold))
                        .foregroundColor(.green)
                    Text("C")
                        .font(.system(size: size * 0.25, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                // 123 Design
                HStack(spacing: size * 0.08) {
                    Text("1")
                        .font(.system(size: size * 0.2, weight: .bold))
                        .foregroundColor(.red)
                    Text("2")
                        .font(.system(size: size * 0.25, weight: .bold))
                        .foregroundColor(.purple)
                    Text("3")
                        .font(.system(size: size * 0.2, weight: .bold))
                        .foregroundColor(.pink)
                }
            }
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            
            // Decorative stars
            ForEach(0..<5) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.1))
                    .foregroundColor(.yellow)
                    .offset(
                        x: size * 0.35 * cos(Double(i) * .pi / 2.5),
                        y: size * 0.35 * sin(Double(i) * .pi / 2.5)
                    )
                    .opacity(0.8)
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    rotation = 5
                    scale = 1.05
                }
            }
        }
    }
}

// Alternative Logo Design 2: Cute Animal Theme
struct CuteAppLogo: View {
    var size: CGFloat = 100
    var animate: Bool = false
    
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            // Sunny background
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.yellow, .orange],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size, height: size)
            
            // Happy face
            Circle()
                .fill(.white)
                .frame(width: size * 0.7, height: size * 0.7)
                .overlay(
                    ZStack {
                        // Eyes
                        HStack(spacing: size * 0.2) {
                            Circle()
                                .fill(.black)
                                .frame(width: size * 0.1, height: size * 0.1)
                            Circle()
                                .fill(.black)
                                .frame(width: size * 0.1, height: size * 0.1)
                        }
                        .offset(y: -size * 0.05)
                        
                        // Smile
                        Path { path in
                            path.addArc(
                                center: CGPoint(x: 0, y: size * 0.1),
                                radius: size * 0.15,
                                startAngle: .degrees(0),
                                endAngle: .degrees(180),
                                clockwise: false
                            )
                        }
                        .stroke(.black, lineWidth: size * 0.03)
                        .offset(y: size * 0.05)
                        
                        // ABC on forehead
                        Text("ABC")
                            .font(.system(size: size * 0.15, weight: .bold))
                            .foregroundColor(.blue)
                            .offset(y: -size * 0.15)
                    }
                )
            
            // Floating numbers
            Text("123")
                .font(.system(size: size * 0.2, weight: .bold))
                .foregroundColor(.white)
                .offset(x: size * 0.3, y: -size * 0.2)
                .rotationEffect(.degrees(15))
            
            Text("తెలుగు")
                .font(.system(size: size * 0.1))
                .foregroundColor(.white)
                .offset(x: -size * 0.25, y: size * 0.2)
        }
        .scaleEffect(bounce ? 1.05 : 1.0)
        .onAppear {
            if animate {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    bounce.toggle()
                }
            }
        }
    }
}

// Alternative Logo Design 3: Modern Minimalist
struct ModernAppLogo: View {
    var size: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Geometric background
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(45))
            
            // Letter K (for Kids)
            Text("K")
                .font(.system(size: size * 0.6, weight: .black))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                .overlay(
                    Text("L")
                        .font(.system(size: size * 0.3, weight: .black))
                        .foregroundColor(.yellow)
                        .offset(x: size * 0.15, y: size * 0.15)
                )
            
            // Learning elements
            Image(systemName: "book.fill")
                .font(.system(size: size * 0.2))
                .foregroundColor(.white)
                .offset(x: -size * 0.2, y: size * 0.2)
            
            Image(systemName: "pencil.tip")
                .font(.system(size: size * 0.2))
                .foregroundColor(.yellow)
                .offset(x: size * 0.2, y: -size * 0.2)
        }
    }
}

// Alternative Logo Design 4: Globe Theme (Multilingual)
struct GlobeAppLogo: View {
    var size: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Globe background
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: size, height: size)
            
            // Continent shapes (simplified)
            Circle()
                .trim(from: 0.2, to: 0.3)
                .stroke(.white, lineWidth: size * 0.05)
                .frame(width: size * 0.4, height: size * 0.4)
            
            Circle()
                .trim(from: 0.6, to: 0.8)
                .stroke(.white, lineWidth: size * 0.05)
                .frame(width: size * 0.5, height: size * 0.5)
            
            // Language characters
            HStack(spacing: size * 0.1) {
                Text("A")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.yellow)
                Text("అ")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.green)
                Text("अ")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.orange)
            }
            .offset(y: size * 0.15)
            
            Text("Kids Learn")
                .font(.system(size: size * 0.12, weight: .medium))
                .foregroundColor(.white)
                .offset(y: -size * 0.2)
        }
    }
}

// Preview
struct AppLogo_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            AppLogo(size: 150, animate: true)
                .padding()
            
            CuteAppLogo(size: 150, animate: true)
                .padding()
            
            ModernAppLogo(size: 150)
                .padding()
            
            GlobeAppLogo(size: 150)
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
