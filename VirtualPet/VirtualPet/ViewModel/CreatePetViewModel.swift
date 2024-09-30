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
    @Published var needs: [PetNeeds] = [.loved]
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    @Published var pets: [Pet]
    private let userService = UserService()
    private let userId: String

    init(pets: [Pet], userId: String) {
        self.pets = pets
        self.userId = userId
    }

    func createPet(completion: @escaping (Bool) -> Void) {
        let newPet = Pet(
            name: petName,
            uniqueCharacteristic: uniqueCharacteristic,
            energyLevel: energyLevel,
            type: selectedCreature,
            mood: mood,
            needs: needs
        )

        userService.addPetToUser(userId: userId, pet: newPet) { result in
            switch result {
            case .success(let updatedPets):
                DispatchQueue.main.async {
                    self.pets = updatedPets
                    completion(true)
                }
            case .failure(let errorResponse):
                self.alertMessage = errorResponse.message
                self.showAlert = true
                print("Error creating pet: \(errorResponse.message)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
