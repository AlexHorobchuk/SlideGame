//
//  LevelModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation


class LevelModel {
    var primeLevel: Bool
    var identifier: Int
    var bonus: Bonus?
    var bonusQouantity: Int
    var enemys = [EnemyModel]()
    
    
    static var identifierFactory = 0
    
    static func getUnicIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    
    func createEnemys() {
        let ceil = Int(ceil(Double(identifier / 15)))
        let lowerBound = 1 + ceil
        let upperBound = 4 + ceil
        let qountity = Int.random(in: (lowerBound <= 15 ? lowerBound : 16)...(upperBound <= 16 ? upperBound : 17))
        if identifier != 1 {
            for _ in 0..<qountity {
                enemys.append(EnemyModel(speed: 200 + identifier))
            }
        }
    }
    
    init() {
        self.identifier = LevelModel.getUnicIdentifier()
        self.primeLevel = false
        if identifier % 5 == 0 || identifier == 1 {
            self.primeLevel = true
        }
            switch Int.random(in: 1...30) {
            case 1...2:
                bonus = Bonus.speedUp
                bonusQouantity = 1
                
            case 3...4:
                bonus = Bonus.shield
                bonusQouantity = 1
            case 5...6:
                bonus = Bonus.kill
                bonusQouantity = 1
            default:
                bonus = Bonus.money
                bonusQouantity = Int.random(in: 1...6)
            }
        if identifier == 1 {
            bonus = nil
        }
        createEnemys()
    }
}
