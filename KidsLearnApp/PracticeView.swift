//
//  PracticeView.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import SwiftUI
import PencilKit
import UIKit

struct PracticeView: View {
    let letter: String
    
    @State private var drawing = PKDrawing()
    @State private var canvasSize: CGSize = .zero
    @State private var score: Int = 0
    @State private var previousScore: Int = 0
    @State private var showFeedback = true
    @State private var showHint = false
    @State private var showCelebration = false
    @State private var strokeCount = 0
    @State private var isEvaluating = false
    
    // Overlays
    @State private var greenOverlay: UIImage?
    @State private var redOverlay: UIImage?
    @State private var hintOverlay: UIImage?
    
    @EnvironmentObject var appState: AppState
    
    // Evaluation timer
    @State private var evaluationTask: DispatchWorkItem?
    
    var body: some View {
        VStack(spacing: 16) {
            // Top bar with score, stroke count, and clear button
            HStack {
                ScoreView(score: score)
                
                Spacer()
                
                if strokeCount > 0 {
                    Text("\(strokeCount) stroke\(strokeCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                
                Button(action: clearDrawing) {
                    Image(systemName: "trash")
                        .font(.headline)
                        .padding(8)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            // Canvas
            ZStack {
                // Background with letter template
                GeometryReader { geometry in
                    Color(.secondarySystemBackground)
                        .onAppear { canvasSize = geometry.size }
                    
                    let fontSize = min(geometry.size.width, geometry.size.height) * 0.6
                    Text(letter)
                        .font(.system(size: fontSize, weight: .heavy))
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                )
                
                // Drawing canvas
                DrawingCanvas(drawing: $drawing, strokeCount: $strokeCount)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onChange(of: drawing) { _ in
                        if showFeedback {
                            debouncedEvaluate()
                        }
                    }
                
                // Feedback overlays (always visible when set)
                if let green = greenOverlay {
                    Image(uiImage: green)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
                if let red = redOverlay {
                    Image(uiImage: red)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
                
                // Hint overlay (temporary)
                if showHint, let hint = hintOverlay {
                    Image(uiImage: hint)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
                
                // Celebration overlay
                if showCelebration {
                    ConfettiView()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .allowsHitTesting(false)
                }
                
                // Loading indicator
                if isEvaluating {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .frame(height: 350)
            
            // Control buttons
            HStack(spacing: 20) {
                // Hint button
                Button(action: toggleHint) {
                    Label("Hint", systemImage: "lightbulb")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                
                // Live feedback toggle
                Toggle("Live", isOn: $showFeedback)
                    .toggleStyle(.button)
                    .tint(showFeedback ? .green : .gray)
                
                // Manual check (appears when live feedback is off)
                if !showFeedback {
                    Button(action: manualCheck) {
                        Label("Check", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(drawing.strokes.isEmpty || isEvaluating)
                }
            }
            .padding(.horizontal)
            
            // Score feedback message
            if score > 0 && score < 30 {
                Text("Try to stay inside the letter!")
                    .font(.caption)
                    .foregroundColor(.orange)
            } else if score >= 80 && score < 100 {
                Text("Great! Almost perfect!")
                    .font(.caption)
                    .foregroundColor(.blue)
            } else if score == 100 {
                Text("Perfect! 🎉")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("Draw inside the letter. Green = good, Red = outside.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
        .onChange(of: score) { newScore in
            if newScore >= 100 && previousScore < 100 {
                withAnimation {
                    showCelebration = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showCelebration = false
                    }
                }
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            previousScore = newScore
        }
    }
    
    // MARK: - Actions
    private func clearDrawing() {
        drawing = PKDrawing()
        greenOverlay = nil
        redOverlay = nil
        hintOverlay = nil
        score = 0
        strokeCount = 0
        showHint = false
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func toggleHint() {
        showHint = true
        if hintOverlay == nil, canvasSize.width > 0 {
            DispatchQueue.global(qos: .userInitiated).async {
                let hint = StrokeAnalyzer.generateHintOverlay(letter: letter, canvasSize: canvasSize)
                DispatchQueue.main.async {
                    hintOverlay = hint
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showHint = false
            }
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func debouncedEvaluate() {
        evaluationTask?.cancel()
        let task = DispatchWorkItem { performEvaluation() }
        evaluationTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    private func manualCheck() {
        evaluationTask?.cancel()
        performEvaluation()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func performEvaluation() {
        guard !drawing.strokes.isEmpty, canvasSize.width > 0 else {
            score = 0
            greenOverlay = nil
            redOverlay = nil
            return
        }
        
        withAnimation { isEvaluating = true }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = StrokeAnalyzer.analyze(drawing: drawing, letter: letter, canvasSize: canvasSize)
            
            DispatchQueue.main.async {
                withAnimation {
                    self.score = result.score
                    self.greenOverlay = result.greenOverlay
                    self.redOverlay = result.redOverlay
                    self.isEvaluating = false
                }
                
                // Update progress if score improved
                if result.score > (appState.progress.getScore(for: letter) ?? 0) {
                    appState.progress.updateScore(for: letter, score: result.score)
                    
                    // Haptic for improvement
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                }
            }
        }
    }
}

// MARK: - Score View
struct ScoreView: View {
    let score: Int
    
    var color: Color {
        switch score {
        case 0..<30: return .red
        case 30..<60: return .orange
        case 60..<80: return .yellow
        case 80..<100: return .blue
        case 100: return .green
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.subheadline)
            Text("\(score)%")
                .font(.title3.bold())
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - Drawing Canvas
struct DrawingCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var strokeCount: Int
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingCanvas
        private var lastStrokeCount = 0
        
        init(_ parent: DrawingCanvas) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
            let newCount = canvasView.drawing.strokes.count
            if newCount != lastStrokeCount {
                parent.strokeCount = newCount
                lastStrokeCount = newCount
            }
        }
    }
}

// MARK: - Stroke Analyzer
struct StrokeAnalyzer {
    // Minimum number of drawn pixels to consider a valid attempt
    private static let minDrawnPixels = 100
    
    static func analyze(drawing: PKDrawing, letter: String, canvasSize: CGSize) -> (score: Int, greenOverlay: UIImage?, redOverlay: UIImage?) {
        let scale = UIScreen.main.scale
        let rect = CGRect(origin: .zero, size: canvasSize)
        
        let drawingImage = drawing.image(from: rect, scale: scale)
        
        guard let maskImage = generateLetterMask(letter: letter, size: canvasSize) else {
            return (0, nil, nil)
        }
        
        // Downsample for faster analysis
        let analysisSize = CGSize(width: 200, height: 200 * (canvasSize.height / canvasSize.width))
        guard let drawSmall = resizeImage(drawingImage, to: analysisSize),
              let maskSmall = resizeImage(maskImage, to: analysisSize) else {
            return (0, nil, nil)
        }
        
        let (inside, outside) = countPixels(draw: drawSmall, mask: maskSmall)
        let total = inside + outside
        
        // If very few pixels drawn, consider it a low-effort attempt
        let effectiveTotal = max(total, minDrawnPixels)
        let rawScore = total > 0 ? Int((Double(inside) / Double(total)) * 100) : 0
        // Penalize if total pixels are too few
        let finalScore = total < minDrawnPixels ? min(rawScore, 30) : rawScore
        
        // Generate overlays at full resolution
        let greenOverlay = generateOverlay(drawing: drawingImage, mask: maskImage, inside: true, color: .green.withAlphaComponent(0.5))
        let redOverlay = generateOverlay(drawing: drawingImage, mask: maskImage, inside: false, color: .red.withAlphaComponent(0.5))
        
        return (finalScore, greenOverlay, redOverlay)
    }
    
    static func generateHintOverlay(letter: String, canvasSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        return renderer.image { ctx in
            let context = ctx.cgContext
            context.setFillColor(UIColor.blue.withAlphaComponent(0.3).cgColor)
            
            let fontSize = min(canvasSize.width, canvasSize.height) * 0.6
            let font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.blue.withAlphaComponent(0.3)
            ]
            
            let attributedString = NSAttributedString(string: letter, attributes: attributes)
            let textSize = attributedString.size()
            let point = CGPoint(
                x: (canvasSize.width - textSize.width) / 2,
                y: (canvasSize.height - textSize.height) / 2
            )
            attributedString.draw(at: point)
        }
    }
    
    private static func generateLetterMask(letter: String, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext
            // Clear background (transparent)
            context.clear(CGRect(origin: .zero, size: size))
            
            let fontSize = min(size.width, size.height) * 0.6
            let font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white // Opaque white for the letter
            ]
            
            let attributedString = NSAttributedString(string: letter, attributes: attributes)
            let textSize = attributedString.size()
            let point = CGPoint(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2
            )
            attributedString.draw(at: point)
        }
    }
    
    private static func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    private static func countPixels(draw: UIImage, mask: UIImage) -> (inside: Int, outside: Int) {
        guard let drawCG = draw.cgImage, let maskCG = mask.cgImage else { return (0,0) }
        
        let width = min(drawCG.width, maskCG.width)
        let height = min(drawCG.height, maskCG.height)
        let bytesPerRow = width * 4
        var drawPixels = [UInt8](repeating: 0, count: width * height * 4)
        var maskPixels = [UInt8](repeating: 0, count: width * height * 4)
        
        // Draw drawing image into pixel buffer
        let drawContext = CGContext(data: &drawPixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        drawContext.draw(drawCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Draw mask image into pixel buffer
        let maskContext = CGContext(data: &maskPixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        maskContext.draw(maskCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var inside = 0
        var outside = 0
        let threshold: UInt8 = 10
        
        for i in stride(from: 0, to: drawPixels.count, by: 4) {
            let drawAlpha = drawPixels[i+3]
            if drawAlpha > threshold {
                let maskAlpha = maskPixels[i+3]
                if maskAlpha > threshold {
                    inside += 1
                } else {
                    outside += 1
                }
            }
        }
        
        return (inside, outside)
    }
    
    private static func generateOverlay(drawing: UIImage, mask: UIImage, inside: Bool, color: UIColor) -> UIImage? {
        guard let drawCG = drawing.cgImage, let maskCG = mask.cgImage else { return nil }
        
        let width = min(drawCG.width, maskCG.width)
        let height = min(drawCG.height, maskCG.height)
        let bytesPerRow = width * 4
        var drawPixels = [UInt8](repeating: 0, count: width * height * 4)
        var maskPixels = [UInt8](repeating: 0, count: width * height * 4)
        
        let drawContext = CGContext(data: &drawPixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        drawContext.draw(drawCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let maskContext = CGContext(data: &maskPixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        maskContext.draw(maskCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var outPixels = [UInt8](repeating: 0, count: width * height * 4)
        let threshold: UInt8 = 10
        
        let components = color.cgColor.components ?? [0,0,0,1]
        let r = UInt8(components[0] * 255)
        let g = UInt8(components[1] * 255)
        let b = UInt8(components[2] * 255)
        let a = UInt8(components[3] * 255)
        
        for i in stride(from: 0, to: drawPixels.count, by: 4) {
            let drawAlpha = drawPixels[i+3]
            if drawAlpha > threshold {
                let maskAlpha = maskPixels[i+3]
                let isInside = maskAlpha > threshold
                if (inside && isInside) || (!inside && !isInside) {
                    outPixels[i] = r
                    outPixels[i+1] = g
                    outPixels[i+2] = b
                    outPixels[i+3] = a
                }
            }
        }
        
        let outContext = CGContext(data: &outPixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        return outContext.makeImage().map { UIImage(cgImage: $0, scale: drawing.scale, orientation: .up) }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<30) { i in
                Circle()
                    .fill(Color.random)
                    .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
                    .offset(x: animate ? CGFloat.random(in: -200...200) : 0,
                            y: animate ? CGFloat.random(in: -200...200) : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        Animation.easeOut(duration: 1.5)
                            .delay(Double(i) * 0.03),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

extension Color {
    static var random: Color {
        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}
