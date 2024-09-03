//
//  PetDetailsView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/30/24.
//

import SwiftUI

import SwiftUI

struct PetDetailsView: View {
    @State var pet: Pet
    @State private var hungerTimer: Timer?
    @State private var thirstTimer: Timer?
    @State private var careTimer: Timer?

    var body: some View {
        ZStack(alignment: .top) {

            LottieView(filename: pet.type.getLottieFileName())
                .frame(height: 500)
                .clipped()

            VStack(alignment: .leading, spacing: 22) {
                Spacer()

                Text(pet.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)
                    .padding(.top, 22)

                VStack(alignment: .leading, spacing: 22) {

                    HStack {
                        InfoBadgeView(text: "Mood: " + pet.mood.getEmoji(), backgroundColor: Color.yellow.opacity(0.3))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Energy Level")
                            .font(.headline)
                            .foregroundColor(.primary)

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 20)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(energyLevelColor(for: pet.energyLevel))
                                .frame(width: CGFloat(pet.energyLevel) / 100 * UIScreen.main.bounds.width * 0.8, height: 20)
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Needs")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 16) {
                            ForEach(pet.needs, id: \.self) { need in
                                NeedItemView(iconName: iconName(for: need), description: description(for: need))
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        ActionButtonView(action: {
                            feedPet()
                        }, title: "Feed", icon: "fish.fill")

                        ActionButtonView(action: {
                            giveWaterToPet()
                        }, title: "Water", icon: "drop.fill")

                        ActionButtonView(action: {
                            playWithPet()
                        }, title: "Play", icon: "pawprint.fill")

                        ActionButtonView(action: {
                            petThePet()
                        }, title: "Pet", icon: "hand.raised.fill")
                    }
                    Spacer()
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .edgesIgnoringSafeArea(.bottom)
            }
            .padding(.top, 350)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            startTimers()
        }
        .onDisappear {
            stopTimers()
        }
    }

    private func startTimers() {
        // Schedule the hunger update after 30 minutes
        hungerTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            updateNeeds(need: .hungry)
        }

        // Schedule the thirst update after 15 minutes
        thirstTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            updateNeeds(need: .thirsty)
        }

        // Schedule the care update after 10 minutes
        careTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
            updateNeeds(need: .care)
        }
    }

    private func stopTimers() {
        hungerTimer?.invalidate()
        thirstTimer?.invalidate()
        careTimer?.invalidate()
    }

    private func energyLevelColor(for level: Int) -> Color {
        switch level {
        case 80...100: return .mint
        case 50..<80: return .yellow
        case 20..<50: return .orange
        default: return .red
        }
    }

    private func feedPet() {
        pet.energyLevel = min(100, pet.energyLevel + 20)
        updateNeeds(need: .full)
        pet.mood = .happy
    }

    private func giveWaterToPet() {
        updateNeeds(need: .hydrated)
        pet.mood = .happy
    }

    private func playWithPet() {
        pet.mood = .excited
        updateNeeds(need: .loved)
        pet.energyLevel = max(0, pet.energyLevel - 10)
    }

    private func petThePet() {
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

    private func iconName(for need: PetNeeds) -> String {
        switch need {
        case .full: return "fish.fill"
        case .hydrated: return "drop.fill"
        case .loved: return "heart.fill"
        case .hungry: return "fish"
        case .thirsty: return "drop"
        case .care: return "leaf.fill"
        }
    }

    private func description(for need: PetNeeds) -> String {
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

struct ActionButtonView: View {
    var action: () -> Void
    var title: String
    var icon: String

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .padding(4)

                Text(title)
                    .font(.headline)
            }
            .frame(width: 80, height: 90)
            .background(Color.mint.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.mint)
        }
    }
}

struct InfoBadgeView: View {
    var text: String
    var backgroundColor: Color

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(8)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

struct NeedItemView: View {
    var iconName: String
    var description: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(.mint)

            Text(description)
                .font(.headline)
        }
    }
}

struct PetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PetDetailsView(pet: Pet(
            name: "Claudio",
            type: .lightGrayCat,
            imageName: "Pet-Claudio",
            color: .orange,
            uniqueCharacteristic: "Fluffy tail",
            mood: .happy,
            energyLevel: 80,
            needs: [.full, .loved]
        ))
    }
}
