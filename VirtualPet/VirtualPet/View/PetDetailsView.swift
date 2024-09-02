//
//  PetDetailsView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/30/24.
//

import SwiftUI

struct PetDetailsView: View {
    @State var pet: Pet

    var body: some View {
        ZStack(alignment: .top) {

            Image("PetClaudio")
                .resizable()
                .scaledToFill()
                .frame(height: 500)
                .clipped()
                .overlay(Color.black.opacity(0.3))


            VStack(alignment: .leading, spacing: 22) {
                Spacer()

                // Pet Name
                Text(pet.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)

                // Pet Information Section
                VStack(alignment: .leading, spacing: 22) {

                    HStack {
                        InfoBadgeView(text: "Mood: " +  moodEmoji(for: pet.mood), backgroundColor: Color.yellow.opacity(0.3))
                    }

                    // Energy Level Bar
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

                    // Needs Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Needs")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 16) {
                            NeedItemView(iconName: "heart.fill", description: pet.needs)
                            NeedItemView(iconName: "drop.fill", description: "Water")
                            NeedItemView(iconName: "leaf.fill", description: "Care")
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
    }

    // Helper function to get the mood emoji
    private func moodEmoji(for mood: PetMood) -> String {
        switch mood {
        case .happy: return "😄"
        case .sad: return "😢"
        case .excited: return "😺"
        case .tired: return "😴"
        }
    }

    // Helper function to get the color based on energy level
    private func energyLevelColor(for level: Int) -> Color {
        switch level {
        case 80...100: return .mint
        case 50..<80: return .yellow
        case 20..<50: return .orange
        default: return .red
        }
    }

    // Functions to perform actions on the pet
    private func feedPet() {
        pet.energyLevel = min(100, pet.energyLevel + 20)
        pet.needs = "Full"
        pet.mood = .happy
    }

    private func giveWaterToPet() {
        pet.needs = "Hydrated"
        pet.mood = .happy
    }

    private func playWithPet() {
        pet.mood = .excited
        pet.energyLevel = max(0, pet.energyLevel - 10)
    }

    private func petThePet() {
        pet.mood = .happy
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
            type: .cat,
            color: .orange,
            uniqueCharacteristic: "Fluffy tail",
            mood: .happy,
            energyLevel: 80,
            needs: "Food"
        ))
    }
}
