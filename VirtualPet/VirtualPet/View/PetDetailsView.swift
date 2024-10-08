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
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.mint.opacity(0.2),
                        Color.white.opacity(0.3),
                        Color.pink.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()


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

                    Text("Characteristic: \(viewModel.pet.uniqueCharacteristic)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        InfoBadgeView(text: "Mood: " + viewModel.pet.mood.getEmoji(), backgroundColor: Color.yellow.opacity(0.3))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Energy Level")
                            .font(.headline)
                            .foregroundColor(.primary)

                        ZStack(alignment: .leading) {
                            ProgressView(value: Double(viewModel.pet.energyLevel), total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: viewModel.energyLevelColor(for: viewModel.pet.energyLevel)))
                                .scaleEffect(x: 1, y: 4, anchor: .center)
                                .frame(height: 20)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
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
                .shadow(color: Color.white.opacity(0.5),radius: 50)
            }
            .padding(.top, 350)
        }
        .padding(.bottom, 24)
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
            id: UUID().uuidString,
            name: "Claudio",
            uniqueCharacteristic: "Fluffy tail",
            energyLevel: 100,
            type: .lightGrayCat,
            mood: .happy,
            needs: [.full, .loved]
        ), token: ""))
    }
}
