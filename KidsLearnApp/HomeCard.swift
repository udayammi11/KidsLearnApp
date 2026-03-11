//
//  HomeCard.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI

struct HomeCard: View {
    let title: String
    let icon: String
    let color: Color
    var disabled: Bool = false
    var progress: Double? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with progress circle
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 50)
                
                if let progress = progress, !disabled {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))
                        .opacity(0.7)
                }
            }
            .padding(.top, 8)
            
            // Title with proper wrapping and alignment
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
            
            if disabled {
                Text("Coming Soon")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Capsule())
                    .padding(.bottom, 8)
            } else {
                // Invisible spacer for consistent height
                Color.clear
                    .frame(height: 24)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(
            Group {
                if disabled {
                    LinearGradient(colors: [.gray, .gray.opacity(0.7)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
                } else {
                    LinearGradient(colors: [color, color.opacity(0.8)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: (disabled ? .clear : color.opacity(0.3)), radius: 8, x: 0, y: 4)
        .opacity(disabled ? 0.7 : 1.0)
    }
}
