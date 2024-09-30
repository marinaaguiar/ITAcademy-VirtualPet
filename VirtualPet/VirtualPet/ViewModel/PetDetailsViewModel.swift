//
//  PetDetailsViewModel.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/3/24.
//

import SwiftUI
import Combine

class PetDetailsViewModel: ObservableObject {
    @Published var pet: Pet
    private var token: String
    private var hungerTimer: Timer?
    private var thirstTimer: Timer?
    private var careTimer: Timer?
    private let petService = PetService()

    init(pet: Pet, token: String) {
        self.pet = pet
        self.token = token
        startTimers()
    }

    deinit {
        stopTimers()
    }

    func startTimers() {
        // Schedule the hunger update after 3 minutes
        hungerTimer = Timer.scheduledTimer(withTimeInterval: 3 * 60, repeats: true) { _ in
            self.updateNeeds(need: .hungry)
        }

        // Schedule the thirst update after 1 minute
        thirstTimer = Timer.scheduledTimer(withTimeInterval: 1 * 60, repeats: true) { _ in
            self.updateNeeds(need: .thirsty)
        }

        // Schedule the care update after 2 minutes
        careTimer = Timer.scheduledTimer(withTimeInterval: 2 * 60, repeats: true) { _ in
            self.updateNeeds(need: .care)
        }
    }

    func stopTimers() {
        hungerTimer?.invalidate()
        thirstTimer?.invalidate()
        careTimer?.invalidate()
    }

    func feedPet() {
        pet.energyLevel = min(100, pet.energyLevel + 20)
        updateNeeds(need: .full)
    }

    func giveWaterToPet() {
        updateNeeds(need: .hydrated)
    }

    func playWithPet() {
        pet.energyLevel = min(100, pet.energyLevel - 10)
        updateNeeds(need: .loved)
    }

    func petThePet() {
        pet.mood = .happy
        updateNeeds(need: .loved)
    }

    private func updateNeeds(need: PetNeeds) {
        if let index = pet.needs.firstIndex(where: { $0 == need.opposite() }) {
            pet.needs[index] = need
        } else if !pet.needs.contains(need) {
            pet.needs.append(need)
        }
        updateMood()
    }

    private func updateMood() {
        if pet.energyLevel < 60 {
            pet.mood = .tired
            savePetState()
            return
        }

        if pet.needs.contains(.hungry) || pet.needs.contains(.care) {
            pet.mood = .sad
            savePetState()
            return
        }

        if pet.needs.contains(.loved)   {
            pet.mood = .excited
            savePetState()
            return
        }

        if pet.needs.contains(.full) && pet.needs.contains(.hydrated) {
            pet.mood = .happy
            savePetState()
            return
        }
    }

    func energyLevelColor(for level: Int) -> Color {
        switch level {
        case 80...100: return .mint
        case 50..<80: return .yellow
        case 20..<50: return .orange
        default: return .red
        }
    }

    func iconName(for need: PetNeeds) -> String {
        switch need {
        case .full: return "fish.fill"
        case .hydrated: return "drop.fill"
        case .loved: return "heart.fill"
        case .hungry: return "fish"
        case .thirsty: return "drop"
        case .care: return "leaf.fill"
        }
    }

    func description(for need: PetNeeds) -> String {
        switch need {
        case .full: return "Full"
        case .hydrated: return "Hydrated"
        case .loved: return "Loved"
        case .hungry: return "Hungry"
        case .thirsty: return "Thirsty"
        case .care: return "Needs Care"
        }
    }

    private func savePetState() {
        petService.updatePetState(pet: pet, token: token) { result in
            switch result {
            case .success(let updatedPet):
                DispatchQueue.main.async {
                    self.pet = updatedPet
                }
            case .failure(let error):
                print("Failed to update pet: \(error.message)")
            }
        }
    }
}
