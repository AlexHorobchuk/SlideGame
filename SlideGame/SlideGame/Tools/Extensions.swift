//
//  Extensions.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/5/23.
//

import Foundation
import UIKit
import SpriteKit


extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
    func middlePosition(between point: CGPoint) -> CGPoint {
        let positionX = (point.x + x) / 2
        let positionY = (point.y + y) / 2
        return CGPoint(x: positionX, y: positionY)
    }
}

extension UIImage {
    static func createImageForBonus(bonus: Bonus) -> UIImage {
        switch bonus {
        case .money:
            return UIImage(systemName: "dollarsign.circle.fill")!
        case .shield:
            return UIImage(systemName: "shield.fill")!
        case .speedUp:
            return UIImage(systemName: "bolt.circle.fill")!
        case .kill:
            return UIImage(systemName: "flame.circle.fill")!
        }
    }
}
    
extension UIColor {
    static func randomRainbowColor() -> UIColor {
        let random = Int.random(in: 1...6)
        switch random {
        case 1:
            return .red
        case 2:
            return .orange
        case 3:
            return .yellow
        case 4:
            return .magenta
        case 5:
            return .green
        case 6:
            return .blue
        default:
            return .blue
        }
    }
}

extension SKTexture {
    enum TexturType {
        case player, primeLevel, regularLevel, achivedRegularlevel, achivedPrimeLevel
    }
    
    static func getTextureFor(textureType texture: TexturType) -> SKTexture {
        let image: UIImage
        var color = UIColor.white
        switch texture {
        case .player:
            image = UIImage(systemName: "face.smiling")!
        case .primeLevel:
            return SKTexture(imageNamed: "home.png")
        case .regularLevel:
            return SKTexture(imageNamed: "dotted.png")
        case .achivedRegularlevel:
            return SKTexture(imageNamed: "dotted.png")
        case .achivedPrimeLevel:
            return SKTexture(imageNamed: "dottedPrime.png")
        }
        let imageWithColor = image.withTintColor(color)
        let data = imageWithColor.pngData()!
        let newImage = UIImage(data: data)
        let newTexture = SKTexture(image: newImage!)
        return newTexture
    }
    
    static func getEnemyTexture(direction: Bool) -> SKTexture {
        let enemyImage = direction ? UIImage(systemName: "minus.circle.fill")! : UIImage(systemName: "plus.circle.fill")!
        let color = UIColor.randomRainbowColor()
        let image = enemyImage.withTintColor(color)
        let data = image.pngData()!
        let newImage = UIImage(data: data)
        let newTexture = SKTexture(image: newImage!)
        newTexture.filteringMode = .linear
        return newTexture
    }
    
    static func getBonusTexture(bonus: Bonus) -> SKTexture {
        let color: UIColor = .blue
        let image = UIImage.createImageForBonus(bonus: bonus)
        let imageWithColor = image.withTintColor(color)
        let data = imageWithColor.pngData()!
        let newImage = UIImage(data: data)
        let newTexture = SKTexture(image: newImage!)
        return newTexture
    }
}
