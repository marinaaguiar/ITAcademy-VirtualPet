//
//  PetDetailsView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/30/24.
//

import SwiftUI

struct PetDetailsView: View {
    @StateObject var viewModel: PetDetailsViewModel

    var body: some View {
        ZStack(alignment: .top) {

            LottieView(filename: viewModel.pet.type.getLottieFileName())
                .frame(height: 500)
                .clipped()

            VStack(alignment: .leading, spacing: 22) {
                Spacer()

                Text(viewModel.pet.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading)
                    .padding(.top, 22)

                VStack(alignment: .leading, spacing: 22) {

                    HStack {
                        InfoBadgeView(text: "Mood: " + viewModel.pet.mood.getEmoji(), backgroundColor: Color.yellow.opacity(0.3))
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
                                .fill(viewModel.energyLevelColor(for: viewModel.pet.energyLevel))
                                .frame(width: CGFloat(viewModel.pet.energyLevel) / 100 * UIScreen.main.bounds.width * 0.8, height: 20)
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Needs")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack(spacing: 16) {
                            ForEach(viewModel.pet.needs, id: \.self) { need in
                                NeedItemView(iconName: viewModel.iconName(for: need), description: viewModel.description(for: need))
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        ActionButtonView(action: {
                            viewModel.feedPet()
                        }, title: "Feed", icon: "fish.fill")

                        ActionButtonView(action: {
                            viewModel.giveWaterToPet()
                        }, title: "Water", icon: "drop.fill")

                        ActionButtonView(action: {
                            viewModel.playWithPet()
                        }, title: "Play", icon: "pawprint.fill")

                        ActionButtonView(action: {
                            viewModel.petThePet()
                        }, title: "Pet", icon: "hand.raised.fill")
                    }
                    Spacer()
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.gray.opacity(0.5),radius: 50)
                .edgesIgnoringSafeArea(.bottom)
            }
            .padding(.top, 350)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.startTimers()
        }
        .onDisappear {
            viewModel.stopTimers()
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
        PetDetailsView(viewModel: PetDetailsViewModel(pet: Pet(
            name: "Claudio",
            type: .lightGrayCat,
            imageName: "Pet-Claudio",
            uniqueCharacteristic: "Fluffy tail",
            mood: .happy,
            energyLevel: 80,
            needs: [.full, .loved]
        )))
    }
}
