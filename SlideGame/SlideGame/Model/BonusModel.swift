//
//  BonusModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation

enum Bonus: CaseIterable {
    case money, shield, speedUp, kill
    
    func getBonusPrice() -> Int {
        switch self {
        case .money:
            return 0
        case .shield:
            return 20
        case .speedUp:
            return 30
        case .kill:
            return 25
        }
    }
    
    func getBonusDescription() -> String {
        switch self {
        case .money:
            return ""
        case .shield:
            return "If you happen to hit an enemy, the shield bonus will prevent you from going all the way back to a home station."
        case .speedUp:
            return "This bonus will increase your moving speed, so it will increase your chances make it to the station."
        case .kill:
            return "This bonus will kill one of your enemy. Once you hit you enemy it will be removed"
        }
    }
}
