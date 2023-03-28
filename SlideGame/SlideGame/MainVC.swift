//
//  ViewController.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import UIKit
import SpriteKit

class MainVC: UIViewController {
    
    var game = SlideGame()
    var scoreLevelLabel: UILabel!
    var bonusStack: UIStackView!
    var settingsButton: UIButton!
    var settingsStack = UIStackView()
    var storeButton: UIButton!
    var scene: SKScene!
    var topConteiner: UIView!
    var bottomContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(game: game, size: view.bounds.size)
        let skView = SKView()
        skView.ignoresSiblingOrder = false
        view = skView
        game.updatePlayersInfo = self
        skView.presentScene(scene)
        topConteiner = setupTopContainer()
        bottomContainer = setupBottomContainer()
        scoreLevelLabel = setupLevelLabel()
        storeButton = setupStoreButton()
        bonusStack = createBonusStack()
        updateBonusStack()
        settingsButton = setupSettingsButton()
        MusicManager.shared.playBackgroundMusic()
        setupSettingsStack()
        
    }
    
    
    //MARK: Store
    func setupStoreButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "cart.circle"), for: .normal)
        topConteiner.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: topConteiner.bottomAnchor, constant: -5),
            button.leftAnchor.constraint(equalTo: topConteiner.leftAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
        button.addTarget(self, action: #selector(storeButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc func storeButtonTapped() {
        SoundManager.shared.playSound(for: .click)
        let vc = ShopVC(game: game)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    //MARK: Score
    func setupLevelLabel() -> UILabel {
        let label = UILabel()
        label.text = "Level: \(game.score)"
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        topConteiner.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: topConteiner.bottomAnchor, constant: -5),
            label.centerXAnchor.constraint(equalTo: topConteiner.centerXAnchor),
            label.widthAnchor.constraint(equalTo: topConteiner.widthAnchor, multiplier: 0.5)
        ])
        return label
    }
    
    //MARK: Creating and updating bonus stack
    func createBonusStack() -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        bottomContainer.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 15),
            hStack.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor, constant: -5),
            hStack.topAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: 5)
        ])
        updateBonusStack()
        return hStack
    }
    
    func updateBonusStack() {
        if bonusStack != nil {
            bonusStack.subviews.forEach { $0.removeFromSuperview() }
            for bonus in Bonus.allCases {
                var bonusView = UIView()
                let image = UIImage.createImageForBonus(bonus: bonus)
                if bonus != .money {
                    let isActive = game.activeBonus == bonus
                    let action = { self.game.activateBonus(bonus: bonus) }
                    bonusView = BonusButton(image: image, isActive: isActive, action: action)
                } else {
                    bonusView = UIImageView(image: image)
                    
                }
                let label = UILabel()
                label.text = String(game.bonuses[bonus]!)
                label.textColor = .systemBlue
                label.font = .systemFont(ofSize: 24, weight: .medium)
                label.textAlignment = .left
                label.minimumScaleFactor = 0.5
                label.adjustsFontSizeToFitWidth = true
                label.translatesAutoresizingMaskIntoConstraints = false
                bonusStack.addArrangedSubview(bonusView)
                bonusStack.addArrangedSubview(label)
                NSLayoutConstraint.activate([
                    bonusView.widthAnchor.constraint(equalToConstant: 45),
                    bonusView.heightAnchor.constraint(equalToConstant: 45),
                    label.widthAnchor.constraint(equalToConstant: 45)
                ])
            }
        }
    }
    
    //MARK: Creating and updating settings stack
    func setupSettingsButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gear.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        topConteiner.addSubview(button)
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: topConteiner.bottomAnchor, constant: -5),
            button.trailingAnchor.constraint(equalTo: topConteiner.trailingAnchor, constant: -10)])
        
        return button
    }
    
    func setupSettingsStack() {
        settingsStack.axis = .vertical
        settingsStack.alignment = .center
        settingsStack.distribution = .equalSpacing
        settingsStack.spacing = 10
        view.addSubview(settingsStack)
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsStack.rightAnchor.constraint(equalTo: settingsButton.rightAnchor),
            settingsStack.centerXAnchor.constraint(equalTo: settingsButton.centerXAnchor),
            settingsStack.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 5),
            settingsStack.leftAnchor.constraint(equalTo: settingsButton.leftAnchor)
        ])
        updateSettingsStack()
        settingsStack.subviews.forEach { button in
            button.isHidden = true
            button.alpha = 0
        }
    }
    
    func updateSettingsStack() {
        settingsStack.subviews.forEach { $0.removeFromSuperview() }
        let musicButton = SettingsButtonFactory.createSettingsButton(type: .music)
        let soundButton = SettingsButtonFactory.createSettingsButton(type: .sound)
        let vibrationButton = SettingsButtonFactory.createSettingsButton(type: .vibration)
        [musicButton, soundButton, vibrationButton].forEach { button in
            settingsStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(managerButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func showSettings() {
        settingsStack.subviews.forEach { button in
            UIView.animate(withDuration: 0.7) {
                button.isHidden = !button.isHidden
                button.alpha = button.alpha == 0 ? 1 : 0
            }
        }
        SoundManager.shared.playSound(for: .click)
    }
    
    @objc func managerButtonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case Settings.music.rawValue:
            UserDefaultsManager.shared.isMusicEnabled.toggle()
        case Settings.sound.rawValue:
            UserDefaultsManager.shared.isSoundEnabled.toggle()
        case Settings.vibration.rawValue:
            UserDefaultsManager.shared.isVibrationEnabled.toggle()
        default:
            print("no action")
        }
        updateSettingsStack()
        SoundManager.shared.playSound(for: .click)
    }
    
    //MARK: SettingUp top and botton containers
    func setupTopContainer() -> UIView{
        let container = UIView()
        container.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        return container
    }
    
    func setupBottomContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 65)
        ])
        return container
    }
    

}
    

extension MainVC: UpdatePlayersInfo {
    func updateScore(score: Int) {
        scoreLevelLabel.text = "Level: \(score)"
    }
    
    func updateBonus() {
        updateBonusStack()
    }
}

