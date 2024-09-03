//
//  HomeView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showCreatePetView = false

    @Binding var pets: [Pet]

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("VirtualPetIconPng")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)

                if pets.isEmpty {
                    Text("No pets created yet.")
                        .font(.headline)
                        .padding(.top, 20)

                    Spacer()
                    Button(action: {
                        showCreatePetView = true
                    }) {
                        Text("Create New Pet")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(25)
                } else {
                    List(pets) { pet in
                        NavigationLink(destination: PetDetailsView(pet: pet)) {
                            HStack {
                                Image(pet.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(.trailing, 10)

                                VStack(alignment: .leading) {
                                    Text(pet.name)
                                        .font(.headline)
                                    Text(pet.type.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.bottom, -10)
                }
                Spacer()
            }
            .navigationTitle("Virtual Pet")
            .sheet(isPresented: $showCreatePetView) {
                CreatePetView(isPresented: $showCreatePetView, pets: $pets)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(pets: .constant([
            Pet(name: "Claudio", type: .lightGrayCat, imageName: "Pet-Claudio", color: .orange, uniqueCharacteristic: "Fluffy tail"),
            Pet(name: "Fluffy", type: .blackCat, imageName: "Pet-Claudio", color: .orange, uniqueCharacteristic: "Fluffy tail"),

        ]))
    }
}
