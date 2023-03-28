//
//  vibrationManager.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/6/23.
//

import UIKit
class VibrationManager {
    
    static let shared = VibrationManager()
    private init() {}
    
    func vibrate(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if UserDefaultsManager.shared.isVibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
