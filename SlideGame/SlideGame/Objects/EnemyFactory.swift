//
//  Enemy.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation
import SpriteKit

class EnemyFactory {
    static func createEnemy() -> SKSpriteNode {
        let enemy = SKSpriteNode()
        enemy.size = .init(width: 80, height: 80)
        enemy.zPosition = 0
        enemy.physicsBody = .init(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.categoryBitMask = PhysicCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicCategory.player
        enemy.physicsBody?.collisionBitMask = .zero
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        return enemy
    }
}
