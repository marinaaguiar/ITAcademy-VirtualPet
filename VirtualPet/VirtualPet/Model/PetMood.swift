//
//  PetMood.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/30/24.
//

import Foundation

enum PetMood: String, Codable {
    case happy = "HAPPY"
    case sad = "SAD"
    case excited = "EXCITED"
    case tired = "TIRED"

    func getEmoji() -> String {
        switch self {
        case .happy:
            return "😸"
        case .sad:
            return "😿"
        case .excited:
            return "😻"
        case .tired:
            return "😴"
        }
    }

}
