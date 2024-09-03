//
//  CreatePetView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct CreatePetView: View {
    @State private var selectedCreature: PetType = .cat
    @State private var petName = ""
    @State private var petColor = Color.blue
    @State private var uniqueCharacteristic = ""
    @State private var mood: PetMood = .happy
    @State private var energyLevel: Int = 100
    @State private var needs: String = "None"

    @Binding var isPresented: Bool
    @Binding var pets: [Pet]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Your Creature")) {
                    Picker("Creature", selection: $selectedCreature) {
                        ForEach(PetType.allCases) { creature in
                            Text(creature.rawValue).tag(creature)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Pet Details")) {
                    TextField("Pet Name", text: $petName)

                    ColorPicker("Pick Pet Color", selection: $petColor)

                    TextField("Unique Characteristic", text: $uniqueCharacteristic)
                }

                Section {
                    Button(action: {
                        let newPet = Pet(
                            name: petName,
                            type: selectedCreature, 
                            imageName: "Pet-Claudio",
                            color: petColor,
                            uniqueCharacteristic: uniqueCharacteristic,
                            mood: mood,
                            energyLevel: energyLevel,
                            needs: needs
                        )
                        pets.append(newPet)
                        isPresented = false
                    }) {
                        Text("Create Pet")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Create a Pet")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct CreatePetView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePetView(isPresented: .constant(true), pets: .constant([]))
    }
}
