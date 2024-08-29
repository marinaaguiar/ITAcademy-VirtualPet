//
//  Pet.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation
import SwiftUI

struct Pet: Identifiable {
    let id = UUID()
    var name: String
    var type: PetType
    var color: Color
    var uniqueCharacteristic: String
}
