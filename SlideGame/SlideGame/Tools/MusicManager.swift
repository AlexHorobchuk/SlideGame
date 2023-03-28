//
//  musicManager.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/6/23.
//

import Foundation
import AVFAudio

class MusicManager {
    static let shared = MusicManager()
    private init() {}
    var player: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let isMusicOn = UserDefaultsManager.shared.isMusicEnabled
        if isMusicOn {
            if let url = Bundle.main.url(forResource: "Music", withExtension: "mp3") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.numberOfLoops = -1
                    player?.play()
                    
                } catch {
                    print("mussic error")
                }
            }
        } else {
            player?.stop()
            player = nil
        }
    }
}
