//
//  StrokeMap.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 11/03/2026.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Accelerate

/// StrokeMap: Generates binary masks and scoring helpers for strict letter tracing.
struct StrokeMap {
    
    // Shared CIContext with optimized settings
    private static let ciContext = CIContext(options: [
        .cacheIntermediates: false,
        .priorityRequestLow: true
    ])
    
    // MARK: - Public API
    
    /// Build a filled letter mask (white = inside letter, transparent = outside)
    static func filledMask(letter: String, size: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        return renderer.image { context in
            let ctx = context.cgContext
            ctx.clear(CGRect(origin: .zero, size: size))
            
            let fontSize = min(size.width, size.height) * 0.62
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .heavy),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]
            
            let attString = NSAttributedString(string: letter, attributes: attributes)
            let textSize = attString.size()
            let drawRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            attString.draw(in: drawRect)
        }
    }
    
    /// Dilate mask (padding inside region)
    static func dilate(mask: UIImage, radius: Int) -> UIImage? {
        guard let cg = mask.cgImage, radius > 0 else { return mask }
        
        let input = CIImage(cgImage: cg)
        let filter = CIFilter.morphologyMaximum()
        filter.inputImage = input
        filter.radius = Float(radius)
        
        guard let output = filter.outputImage else { return mask }
        
        if let cgOut = ciContext.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgOut, scale: mask.scale, orientation: .up)
        }
        return mask
    }
    
    /// Resize for analysis (reduce CPU)
    static func resize(_ image: UIImage, to size: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// Compute precision (how much drawing is inside the mask)
    static func precision(draw: UIImage, insideMask: UIImage) -> Double {
        let stats = insideOutsideStats(draw: draw, mask: insideMask)
        guard stats.total > 0 else { return 0 }
        return Double(stats.inside) / Double(stats.total)
    }
    
    /// Compute coverage (how much of the letter has been traced)
    static func coverage(mask: UIImage, draw: UIImage) -> Double {
        guard let mCG = mask.cgImage, let dCG = draw.cgImage else { return 0 }
        
        let width = min(mCG.width, dCG.width)
        let height = min(mCG.height, dCG.height)
        let thr: UInt8 = 10
        
        guard let mData = extractAlphaData(from: mCG, width: width, height: height),
              let dData = extractAlphaData(from: dCG, width: width, height: height) else {
            return 0
        }
        
        var maskTotal = 0
        var covered = 0
        
        for i in 0..<min(mData.count, dData.count) {
            if mData[i] > thr {
                maskTotal += 1
                if dData[i] > thr {
                    covered += 1
                }
            }
        }
        
        guard maskTotal > 0 else { return 0 }
        return Double(covered) / Double(maskTotal)
    }
    
    /// Compute F1 score combining precision and coverage
    static func f1Score(precision: Double, coverage: Double) -> Double {
        guard precision + coverage > 0 else { return 0 }
        return 2 * (precision * coverage) / (precision + coverage)
    }
    
    // MARK: - Inside/outside stroke classification
    
    static func insideOutsideStats(draw: UIImage, mask: UIImage) -> (total: Int, inside: Int) {
        guard let drCG = draw.cgImage, let mCG = mask.cgImage else { return (0, 0) }
        
        let width = min(drCG.width, mCG.width)
        let height = min(drCG.height, mCG.height)
        let thr: UInt8 = 10
        
        guard let drData = extractAlphaData(from: drCG, width: width, height: height),
              let mData = extractAlphaData(from: mCG, width: width, height: height) else {
            return (0, 0)
        }
        
        var total = 0
        var inside = 0
        
        for i in 0..<min(drData.count, mData.count) {
            if drData[i] > thr {
                total += 1
                if mData[i] > thr {
                    inside += 1
                }
            }
        }
        
        return (total, inside)
    }
    
    // MARK: - Helper
    
    private static func extractAlphaData(from cgImage: CGImage, width: Int, height: Int) -> [UInt8]? {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.alphaOnly.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height)
        return Array(UnsafeBufferPointer(start: buffer, count: width * height))
    }
    
    // MARK: - Overlay building
    
    /// Build tinted overlay only on drawn pixels inside/outside mask.
    static func makeOverlay(draw: UIImage, mask: UIImage, inside: Bool, color: UIColor) -> UIImage? {
        guard let drCG = draw.cgImage, let mCG = mask.cgImage else { return nil }
        
        let width = min(drCG.width, mCG.width)
        let height = min(drCG.height, mCG.height)
        let thr: UInt8 = 10
        
        guard let drData = extractAlphaData(from: drCG, width: width, height: height),
              let mData = extractAlphaData(from: mCG, width: width, height: height) else {
            return nil
        }
        
        let colorComponents = color.cgColor.components ?? [0, 0, 0, 1]
        let R = UInt8(colorComponents[0] * 255)
        let G = UInt8(colorComponents[1] * 255)
        let B = UInt8(colorComponents[2] * 255)
        let A = UInt8(colorComponents[3] * 255)
        
        // Create output context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        guard let outData = context.data else { return nil }
        let outPtr = outData.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Clear context
        context.clear(CGRect(x: 0, y: 0, width: width, height: height))
        
        for i in 0..<min(drData.count, mData.count) {
            if drData[i] > thr {
                let isInside = mData[i] > thr
                let shouldColor = inside ? isInside : !isInside
                
                if shouldColor {
                    let pixelIndex = i * 4
                    outPtr[pixelIndex] = R
                    outPtr[pixelIndex + 1] = G
                    outPtr[pixelIndex + 2] = B
                    outPtr[pixelIndex + 3] = A
                }
            }
        }
        
        guard let outputCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage, scale: draw.scale, orientation: .up)
    }
}
