//
//  CreatePetViewModel.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/3/24.
//

import SwiftUI

class CreatePetViewModel: ObservableObject {
    @Published var selectedCreature: PetType = .darkGrayCat
    @Published var petName = ""
    @Published var uniqueCharacteristic = ""
    @Published var mood: PetMood = .happy
    @Published var energyLevel: Int = 100
    @Published var needs: PetNeeds = .loved

    @Published var pets: [Pet]

    init(pets: [Pet]) {
        self.pets = pets
    }

    func createPet() {
        let newPet = Pet(
            id: UUID().uuidString, 
            name: petName,
            type: selectedCreature,
            imageName: "Pet-Claudio",
            uniqueCharacteristic: uniqueCharacteristic,
            mood: mood,
            energyLevel: energyLevel,
            needs: [needs]
        )
        pets.append(newPet)
    }
}
