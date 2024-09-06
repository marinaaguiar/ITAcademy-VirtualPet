//
//  PetMood.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/30/24.
//

import Foundation

enum PetMood: String, Codable {
    case happy = "Happy"
    case sad = "Sad"
    case excited = "Excited"
    case tired = "Tired"

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
