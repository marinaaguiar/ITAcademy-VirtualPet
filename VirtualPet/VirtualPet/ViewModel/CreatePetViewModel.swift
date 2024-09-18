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
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var pets: [Pet]
    private let userService = UserService()
    private let userId: String

    init(pets: [Pet], userId: String) {
        self.pets = pets
        self.userId = userId
    }

    func createPet() {
        let newPet = Pet(
            id: UUID().uuidString,
            name: petName,
            uniqueCharacteristic: uniqueCharacteristic,
            energyLevel: energyLevel,
            type: selectedCreature,
//            imageName: "Pet-Claudio",
            mood: mood,
            needs: [needs]
        )

        userService.addPetToUser(userId: userId, pet: newPet) { result in
            switch result {
            case .success(let updatedUser):
                DispatchQueue.main.async {
                    guard let newPets = updatedUser.pets else { return }
                    self.pets = newPets
                }
            case .failure(let errorResponse):
                self.alertMessage = errorResponse.message
                self.showAlert = true
                print("Error creating pet: \(errorResponse.message)")
            }
        }
    }
}
