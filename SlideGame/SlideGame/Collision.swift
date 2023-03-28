//
//  Collision.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation
import SpriteKit

struct PhysicCategory {
    static let all  : UInt32 = 0xFFFFFFFF
    static let player: UInt32 = 1
    static let level: UInt32 = 2
    static let enemy: UInt32 = 4
    static let notActiveEnemy: UInt32 = 8
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node as? SKSpriteNode else { return print("nil") }
        guard let bodyB = contact.bodyB.node as? SKSpriteNode else { return print("nil") }
        let type = detectCollisionType(bodyA: bodyA, bodyB: bodyB)
        collisionActionSwitch(type: type, bodyA: bodyA, bodyB: bodyB)
    }
    
    func detectCollisionType(bodyA: SKSpriteNode, bodyB: SKSpriteNode ) -> PhysicCollisionType {
        switch (bodyA.physicsBody?.categoryBitMask, bodyB.physicsBody?.categoryBitMask) {
        case (PhysicCategory.player, PhysicCategory.level), (PhysicCategory.level, PhysicCategory.player):
            return .playerStation
        case (PhysicCategory.player, PhysicCategory.enemy), (PhysicCategory.enemy, PhysicCategory.player):
            return .playerEnemy
        case (_, _):
            return .unknown
        }
    }
    
    func collisionActionSwitch(type: PhysicCollisionType, bodyA: SKSpriteNode, bodyB: SKSpriteNode ) {
        switch type {
        case .playerStation:
            let identifier = bodyA.physicsBody?.categoryBitMask == PhysicCategory.level ? Int(bodyA.name!) : Int(bodyB.name!)
            if identifier != game.currentLevel {
                SoundManager.shared.playSound(for: .madeToStation)
                VibrationManager.shared.vibrate(for: .light)
                game.cameToNextSpot(nextSpot: .Success)
                updateUI()
            }
        case .playerEnemy:
            let enemy = bodyA.physicsBody?.categoryBitMask == PhysicCategory.enemy ? bodyA : bodyB
            if game.activeBonus == .kill {
                enemy.removeFromParent()
                game.bonuses[.kill]! -= 1
                SoundManager.shared.playSound(for: .hit)
            } else {
                game.cameToNextSpot(nextSpot: .Fail)
                SoundManager.shared.playSound(for: .faild)
            }
            let particle = SKEmitterNode(fileNamed: "Spark.sks")!
            self.addChild(particle)
            particle.position = bodyB.position
            particle.targetNode = self.scene
            let deleteParticle = SKAction.run { particle.removeFromParent() }
            self.run(.sequence([ .wait(forDuration: 0.5), deleteParticle]))
            VibrationManager.shared.vibrate(for: .heavy)
            updateUI()
        case .unknown:
            return
        }
    }
    
    enum PhysicCollisionType {
        case playerStation
        case playerEnemy
        case unknown
    }
}
