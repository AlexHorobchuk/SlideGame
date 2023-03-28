//
//  UserDefaultsManager.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/6/23.
//

import Foundation

class UserDefaultsManager {
    static var shared = UserDefaultsManager()
    private let musicKey = "music"
    private let vibrationKey = "vibration"
    private let soundKey = "sound"
    
    private init() {
        UserDefaults.standard.register(defaults: [
            musicKey : true,
            vibrationKey : true,
            soundKey : true
        ])
    }
    
    var isMusicEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: musicKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: musicKey)
            MusicManager.shared.playBackgroundMusic()
        }
    }
    
    var isVibrationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: vibrationKey) }
        set { UserDefaults.standard.set(newValue, forKey: vibrationKey) }
    }
    
    var isSoundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: soundKey) }
        set { UserDefaults.standard.set(newValue, forKey: soundKey) }
    }
}
