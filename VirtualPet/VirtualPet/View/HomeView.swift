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
        VStack {
            if pets.isEmpty {
                Spacer()
                Image("VirtualPetIconPng")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)

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
                    NavigationLink(destination: PetDetailsView(viewModel: PetDetailsViewModel(pet: pet))) {
                        HStack {
                            Image(pet.imageName)
                                .resizable()
                                .scaledToFit()
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
            CreatePetView(viewModel: CreatePetViewModel(pets: pets), isPresented: $showCreatePetView)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(pets: .constant([]))
    }
}
