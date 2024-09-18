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
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {

        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.mint.opacity(0.2),
                    Color.white.opacity(0.8),
                    Color.pink.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                if pets.isEmpty {
                    Spacer()
                    Image("VirtualPetIconPng")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
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
                                Image("Pet-Claudio")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        authViewModel.logOutUser() // Call the logout method
                    }
                }
            }
            .sheet(isPresented: $showCreatePetView) {
                CreatePetView(viewModel: CreatePetViewModel(pets: pets, userId: "userId"), isPresented: $showCreatePetView)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(pets: .constant([]), authViewModel: AuthViewModel(users: []))
    }
}
