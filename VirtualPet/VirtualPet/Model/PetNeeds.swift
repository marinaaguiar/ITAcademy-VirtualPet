//
//  PetNeeds.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/3/24.
//

import Foundation

enum PetNeeds: String, CaseIterable, Codable {
    case full = "Full"
    case hydrated = "Hydrated"
    case loved = "Loved"
    case hungry = "Hungry"
    case thirsty = "Thirsty"
    case care = "Care"

    func opposite() -> PetNeeds? {
        switch self {
        case .full: return .hungry
        case .hydrated: return .thirsty
        case .loved: return .care
        case .hungry: return .full
        case .thirsty: return .hydrated
        case .care: return .loved
        }
    }
}
