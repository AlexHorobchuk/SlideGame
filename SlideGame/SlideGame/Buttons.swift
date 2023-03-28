//
//  Settings.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/10/23.
//

import UIKit

enum Settings: String {
    case music = "music", sound = "sound", vibration = "vibration"
}

class SettingsButtonFactory {
    
    static func createButton(isON: Bool, isOnImage: UIImage, isOffImage: UIImage, title: String ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = isON ? isOnImage : isOffImage
        button.setBackgroundImage(image, for: .normal)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)])
        return button
    }
    
    static func createSettingsButton(type: Settings) -> UIButton {
        switch type {
        case .music:
            return createButton(isON: UserDefaultsManager.shared.isMusicEnabled, isOnImage: UIImage(systemName: "speaker.wave.2.circle.fill")!, isOffImage: UIImage(systemName: "speaker.slash.circle.fill")!, title: type.rawValue)
        case .sound:
            return createButton(isON: UserDefaultsManager.shared.isSoundEnabled, isOnImage: UIImage(systemName: "ear.and.waveform")!, isOffImage: UIImage(systemName: "ear")!, title: type.rawValue)
        case .vibration:
            return createButton(isON: UserDefaultsManager.shared.isVibrationEnabled, isOnImage: UIImage(systemName: "iphone.homebutton.radiowaves.left.and.right.circle")!, isOffImage: UIImage(systemName: "iphone.homebutton.circle")!, title: type.rawValue)
        }
    }
}

class BonusButton: UIButton {
    
    private let image: UIImage
    private let isActive: Bool
    private let action: (() -> Void)
    
    init(image: UIImage, isActive: Bool, action: @escaping (() -> Void)) {
        self.image = image
        self.isActive = isActive
        self.action = action
        super.init(frame: .zero)
        setBackgroundImage(image, for: .normal)
        layer.borderWidth = 2
        layer.borderColor = isActive ? UIColor.green.cgColor : UIColor.red.cgColor
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2

    }
    
    @objc private func buttonTapped() {
        action()
        SoundManager.shared.playSound(for: .click)
    }

}
