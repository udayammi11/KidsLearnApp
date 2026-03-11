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
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(.white)
                
                if let progress = progress, !disabled {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .opacity(0.7)
                }
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            if disabled {
                Text("Coming Soon")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, minHeight: 170)
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
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: (disabled ? .clear : color.opacity(0.4)), radius: 12, x: 0, y: 6)
        .opacity(disabled ? 0.7 : 1.0)
    }
}
