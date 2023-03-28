//
//  Level.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import UIKit
import SpriteKit

class Level: SKSpriteNode {
    static func createLevel(_ levelModel: LevelModel) -> Level {
        let level = Level()
        level.name = "\(levelModel.identifier)"
        level.texture = levelModel.primeLevel ? .getTextureFor(textureType: .primeLevel) :
            .getTextureFor(textureType: .achivedRegularlevel)
        level.size = .init(width: 120, height: 120)
        level.zPosition = -2
        level.physicsBody = .init(circleOfRadius: level.size.width / 2)
        level.physicsBody?.categoryBitMask = PhysicCategory.level
        level.physicsBody?.contactTestBitMask = PhysicCategory.player
        level.physicsBody?.collisionBitMask = .zero
        level.physicsBody?.usesPreciseCollisionDetection = true
        level.run(.repeatForever(.rotate(byAngle: .pi, duration: 3)))
        level.createEnemys(for: levelModel)
        if !levelModel.primeLevel {
            level.createBonus(for: levelModel) }
        return level
    }
    
    func createBonus(for model: LevelModel) {
        if let bonus = model.bonus {
            let bonusNode = SKSpriteNode()
            bonusNode.name = "bonus"
            bonusNode.texture = .getBonusTexture(bonus: bonus)
            bonusNode.size = .init(width: 60, height: 60)
            self.addChild(bonusNode)
        }
    }
    
    func createEnemys(for model: LevelModel) {
        let enemys = model.enemys.map { _ in EnemyFactory.createEnemy() }
        var count = enemys.count
        guard let enemyModel = model.enemys.first else { return }
        guard let enemyUI = enemys.first else { return }
        var lap = 1
        while count > 0 {
            let maxAmount = foundMaxAmountOfEnemys(enemySize: enemyUI.size.width, lap: lap)
            let minAmount = maxAmount > 3 ? maxAmount - 3 : 1
            let random = Int.random(in: minAmount...maxAmount)
            let timeForOneCirlce = (self.size.width + enemyUI.size.width * CGFloat(lap)) * .pi / CGFloat(enemyModel.speed)
            for i in 1...random {
                if count > 0 {
                    let direction = Bool.random()
                    let node = enemys[count - 1]
                    let offset = CGFloat(i) / CGFloat(maxAmount) * 2.2
                    let nodePath = createPath(lap: lap, enemySize: enemyUI.size.width, startAngle: offset, direction: direction)
                    let followPath = SKAction.follow(nodePath.cgPath, asOffset: false, orientToPath: true, duration: timeForOneCirlce)
                    node.run(.repeatForever(followPath))
                    node.texture = SKTexture.getEnemyTexture(direction: direction)
                    self.addChild(node)
                }
                count -= 1
            }
            lap += 1
        }
    }
    
    func foundMaxAmountOfEnemys(enemySize: Double, lap: Int) -> Int {
        return Int((self.size.width + enemySize * CGFloat(lap)) / enemySize) * 2
    }
    
    func createPath(lap: Int, enemySize: CGFloat, startAngle: CGFloat, direction: Bool) -> UIBezierPath {
        let endAngle = direction ? startAngle + .pi * 2 : startAngle - .pi * 2
        return UIBezierPath(arcCenter: self.position, radius: (self.size.width / 2 + (enemySize * CGFloat(lap)))  , startAngle: startAngle, endAngle: endAngle, clockwise: direction)
    }
    
    func checkIfwasVisited( level: LevelModel) {
        if level.bonus == nil {
            self.childNode(withName: "bonus")?.removeFromParent()
        }
        self.texture = .getTextureFor(textureType: .achivedRegularlevel)
    }
    
    func checkIfprimeWasVisited( level: LevelModel) {
        if level.bonus == nil {
            self.texture = .getTextureFor(textureType: .achivedPrimeLevel)
        } else {
            self.texture = .getTextureFor(textureType: .primeLevel)
        }
    }
}
