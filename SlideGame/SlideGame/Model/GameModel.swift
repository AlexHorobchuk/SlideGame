//
//  GameModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation

protocol GameLogic: AnyObject {
    
    func failedToMakeToANewSpot(identifier: Int)
    
    func deleteLevels(levels: [LevelModel])
    
    func goToNextSpot(identifier: Int, speed: Int)

    func activatedBonus(bonus: Bonus?)
}

protocol UpdatePlayersInfo: AnyObject {
    func updateScore(score: Int)
    func updateBonus()
    
}

class SlideGame {
    var player = PlayerModel()
    var activeBonus: Bonus? {
        didSet {
            updatePlayersInfo?.updateBonus()
            logic?.activatedBonus(bonus: activeBonus)
        }
    }
    var score = 1 {
        didSet {
            updatePlayersInfo?.updateScore(score: score)
        }
    }
    var bonuses = [Bonus: Int]() {
        didSet {
            if let bonus = activeBonus, bonuses[bonus]! <= 0 {
                self.activeBonus = nil
            }
            updatePlayersInfo?.updateBonus()
        }
    }
    var currentLevel = 1
    var currentSavedLevel = 1
    var gameLevels = [LevelModel]()
    weak var logic: GameLogic?
    weak var updatePlayersInfo: UpdatePlayersInfo?
    
    init () {
        createLevels()
        for bonus in Bonus.allCases {
            bonuses[bonus] = 0
        }
    }
    
    enum DidCameToNextSpot {
        case Success, Fail
    }
    
    func cameToNextSpot(nextSpot : DidCameToNextSpot) {
        switch nextSpot {
        case .Success:
            if var level = gameLevels.first(where: { $0.identifier == currentLevel + 1 } ) {
                if level.primeLevel == true {
                    score += 1
                    currentSavedLevel = level.identifier
                    checkLevel(&level)
                    deleteOldLevels(identifier: level.identifier)
                    createLevels()
                }
                checkLevel(&level)
                currentLevel = level.identifier }
        case .Fail:
            if activeBonus == .shield {
                self.bonuses[Bonus.shield]! -= 1
                SoundManager.shared.playSound(for: .hit)
            } else {
                currentLevel = currentSavedLevel
            }
            logic?.failedToMakeToANewSpot(identifier: currentLevel)
        }
        if activeBonus == .speedUp {
            self.bonuses[.speedUp]! -= 1
        }
    }
    
    func deleteOldLevels(identifier: Int) {
        let oldLevels = gameLevels.filter { $0.identifier < identifier }
        gameLevels.removeAll(where: { $0.identifier < identifier })
        logic?.deleteLevels(levels: oldLevels)
    }
    
    func moveToNextSpot() {
        let newIdentifier = currentLevel + 1
        var speed = player.speed
        if self.activeBonus == .speedUp {
            speed += 900
        }
        logic?.goToNextSpot(identifier: newIdentifier, speed: speed)
    }
    
    func checkLevel(_ level: inout LevelModel ) {
        if level.bonus != nil {
            self.bonuses[level.bonus!]! += level.bonusQouantity
            level.bonus = nil
        }
    }
    
    func createLevels() {
        let maxRangeNumber = gameLevels.isEmpty ? 10 : 5
        for _ in 1...maxRangeNumber {
            let level = LevelModel()
            self.gameLevels.append(level)
        }
    }
    
    func activateBonus(bonus: Bonus) {
        if bonuses[bonus]! > 0 {
            if activeBonus != bonus {
                activeBonus = bonus
            } else {
                activeBonus = nil
            }
            logic?.activatedBonus(bonus: activeBonus)
        }
    }
}
