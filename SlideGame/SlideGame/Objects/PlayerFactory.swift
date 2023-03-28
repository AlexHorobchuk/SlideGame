//
//  Player.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import SpriteKit

class PlayerFactory {
    static func createPlater() -> SKSpriteNode {
        let player = SKSpriteNode(texture: SKTexture.getTextureFor(textureType: .player))
        let aimWidth: CGFloat = 70
        let ratio = aimWidth  / player.size.width + 0.2
        player.setScale(ratio)
        player.physicsBody = .init(circleOfRadius: aimWidth / 2)
        player.physicsBody?.categoryBitMask = PhysicCategory.player
        player.physicsBody?.contactTestBitMask = PhysicCategory.enemy | PhysicCategory.level
        player.physicsBody?.collisionBitMask = .zero
        player.physicsBody?.usesPreciseCollisionDetection = true
        return player
    }
}
