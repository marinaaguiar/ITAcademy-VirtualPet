//
//  CreatePetView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct CreatePetView: View {
    @State private var selectedCreature = "Cat"
    @State private var petName = ""
    @State private var petColor = Color.blue
    @State private var uniqueCharacteristic = ""

    let creatures = ["Cat", "Dog", "Rabbit", "Bear"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Your Creature")) {
                    Picker("Creature", selection: $selectedCreature) {
                        ForEach(creatures, id: \.self) {
                            Text($0)
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
                        // Handle pet creation logic here
                        print("Pet created: \(petName), \(selectedCreature), \(petColor), \(uniqueCharacteristic)")
                    }) {
                        Text("Create Pet")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Create a Pet")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the CreatePetView
            })
        }
    }
}

#Preview {
    CreatePetView()
}
