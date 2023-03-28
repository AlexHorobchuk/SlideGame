//
//  PlayerModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation

struct PlayerModel {
    var speed: Int = 850
    var activeBonus = [Bonus]()
    
    mutating func activateBonus(bonus: Bonus) {
        if !activeBonus.contains(bonus) {
            activeBonus.append(bonus)
        }
    }
    
    mutating func deactivateBonus(bonus: Bonus) {
        let index = activeBonus.firstIndex(where: { $0 == bonus } )
        if let number = index {
            activeBonus.remove(at: Int(number))
        }
    }
    
}
