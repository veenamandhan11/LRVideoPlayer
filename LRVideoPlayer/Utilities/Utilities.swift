//
//  Utilities.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import AVFoundation

class Utilities {
    static let shared = Utilities()
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
}
