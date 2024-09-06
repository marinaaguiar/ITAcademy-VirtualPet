//
//  Pet.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation
import SwiftUI

struct Pet: Identifiable, Codable {
    let id: String
    var name: String
    var type: PetType
    var imageName: String
    var uniqueCharacteristic: String
    var mood: PetMood = .happy
    var energyLevel: Int = 50
    var needs: [PetNeeds] = [.full, .loved]
}
