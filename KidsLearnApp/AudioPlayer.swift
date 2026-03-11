//
//  AudioPlayer.swift
//  KidsLearnApp
//
//  Created by Uday Kumar on 10/03/2026.
//

import Foundation
import AVFoundation
import UIKit

/// A tiny helper to play short local audio files (e.g., letter pronunciations).
final class SimpleAudioPlayer: NSObject {
    
    // MARK: - Singleton
    static let shared = SimpleAudioPlayer()
    
    // MARK: - Private Properties
    private var player: AVAudioPlayer?
    private var audioSession: AVAudioSession?
    
    // MARK: - Public Properties
    var volume: Float = 1.0 {
        didSet { player?.volume = volume }
    }
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return player?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        return player?.duration ?? 0
    }
    
    // MARK: - Initialization
    override private init() {
        super.init()
        setupAudioSession()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession?.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession?.setActive(true)
        } catch {
            print("Audio session setup error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Public Methods
    
    /// Play an audio resource from the app bundle.
    func play(named name: String?, ext: String = "mp3", interrupt: Bool = true) {
        guard let name = name, !name.isEmpty else {
            print("Audio name is nil or empty")
            return
        }
        
        do {
            try audioSession?.setActive(true)
        } catch {
            print("Failed to activate audio session: \(error.localizedDescription)")
        }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Audio file not found: \(name).\(ext)")
            return
        }
        
        do {
            if interrupt {
                stop()
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            
            // Add haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        } catch {
            print("Audio play error for \(name).\(ext): \(error.localizedDescription)")
        }
    }
    
    /// Stop current playback
    func stop() {
        player?.stop()
        player?.currentTime = 0
    }
    
    /// Pause playback
    func pause() {
        player?.pause()
    }
    
    /// Resume playback
    func resume() {
        player?.play()
    }
    
    // MARK: - Private Methods
    @objc private func handleAudioInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            if player?.isPlaying == true {
                pause()
            }
            
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    try? audioSession?.setActive(true)
                    resume()
                }
            }
            
        @unknown default:
            break
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension SimpleAudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in
            if flag {
                self?.player = nil
            }
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio decode error: \(error.localizedDescription)")
        }
        self.player = nil
    }
}
