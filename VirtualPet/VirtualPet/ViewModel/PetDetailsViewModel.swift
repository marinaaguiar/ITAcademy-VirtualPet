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
    private var hungerTimer: Timer?
    private var thirstTimer: Timer?
    private var careTimer: Timer?

    init(pet: Pet) {
        self.pet = pet
        startTimers()
    }

    deinit {
        stopTimers()
    }

    func startTimers() {
        // Schedule the hunger update after 30 minutes
        hungerTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.updateNeeds(need: .hungry)
        }

        // Schedule the thirst update after 15 minutes
        thirstTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            self.updateNeeds(need: .thirsty)
        }

        // Schedule the care update after 10 minutes
        careTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
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
        pet.mood = .happy
    }

    func giveWaterToPet() {
        updateNeeds(need: .hydrated)
        pet.mood = .happy
    }

    func playWithPet() {
        pet.mood = .excited
        updateNeeds(need: .loved)
        pet.energyLevel = max(0, pet.energyLevel - 10)
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
}
