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
    var uniqueCharacteristic: String
    var energyLevel: Int
    var type: PetType
    var mood: PetMood
    var needs: [PetNeeds]
}
