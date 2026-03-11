//
//  GIFView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

//
//  GIFView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI
import UIKit
import ImageIO

struct GIFView: View {
    let gifName: String?
    var width: CGFloat = 100
    var height: CGFloat = 100
    var shouldLoop: Bool = true
    
    @State private var isAnimating = true
    
    var body: some View {
        if let gifName = gifName, !gifName.isEmpty {
            // Try to load and display GIF
            if let gifData = loadGIF(name: gifName) {
                GIFImage(data: gifData, isAnimating: $isAnimating, shouldLoop: shouldLoop)
                    .frame(width: width, height: height)
                    .onAppear {
                        isAnimating = true
                    }
                    .onDisappear {
                        isAnimating = false
                    }
            } else {
                // Fallback to placeholder if GIF not found
                VStack {
                    Image(systemName: "photo.fill")
                        .font(.system(size: width * 0.4))
                        .foregroundColor(.gray)
                    Text("GIF not found")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(width: width, height: height)
            }
        } else {
            // No GIF specified
            EmptyView()
        }
    }
    
    private func loadGIF(name: String) -> Data? {
        // First try with .gif extension
        if let path = Bundle.main.path(forResource: name, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        
        // Try without extension
        if let path = Bundle.main.path(forResource: name, ofType: nil),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        
        print("⚠️ GIF not found: \(name).gif")
        return nil
    }
}

// UIKit wrapper for GIF display
struct GIFImage: UIViewRepresentable {
    let data: Data
    @Binding var isAnimating: Bool
    var shouldLoop: Bool = true
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Create animated image from GIF data
        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
            var images: [UIImage] = []
            var totalDuration: TimeInterval = 0
            
            let count = CGImageSourceGetCount(source)
            
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let image = UIImage(cgImage: cgImage)
                    images.append(image)
                    
                    // Get frame duration
                    if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                       let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                       let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                        totalDuration += delayTime
                    }
                }
            }
            
            if !images.isEmpty {
                uiView.animationImages = images
                uiView.animationDuration = totalDuration > 0 ? totalDuration : Double(count) * 0.1
                uiView.animationRepeatCount = shouldLoop ? 0 : 1
                
                if isAnimating {
                    uiView.startAnimating()
                } else {
                    uiView.stopAnimating()
                }
            }
        }
    }
}

// MARK: - GIF Preloader
class GIFPreloader {
    static let shared = GIFPreloader()
    private var cache: [String: Data] = [:]
    
    func preloadGIF(named name: String) {
        guard cache[name] == nil else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let path = Bundle.main.path(forResource: name, ofType: "gif"),
               let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                DispatchQueue.main.async {
                    self.cache[name] = data
                }
            }
        }
    }
    
    func getGIF(named name: String) -> Data? {
        return cache[name]
    }
}
