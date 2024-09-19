//
//  HomeView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showCreatePetView = false
    @State private var displayedPets: [Pet] = [
        Pet(id: "343234", name: "Claudio", uniqueCharacteristic: "fluffy", energyLevel: 80, type: .blackCat, mood: .excited, needs: [.care, .full]
    )]
    @ObservedObject var homeViewModel: HomeViewModel
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
                if homeViewModel.isLoading {
                    Spacer()
                    ProgressView("Loading Pets...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else if displayedPets.isEmpty {
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
                    List(displayedPets) { pet in
                        NavigationLink(destination: PetDetailsView(viewModel: PetDetailsViewModel(pet: pet))) {
                            HStack {
                                Image("\(pet.type.rawValue)")
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
                        authViewModel.logOutUser()
                    }
                }
            }
            .sheet(isPresented: $showCreatePetView) {
                CreatePetView(viewModel: CreatePetViewModel(pets: homeViewModel.pets, userId: "userId"), isPresented: $showCreatePetView)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                if let user = authViewModel.loggedInUser, let token = authViewModel.authToken {
                    print("User: \(user.id), Token: \(token)")
                    homeViewModel.fetchUserPets(userId: user.id, token: token)
                } else {
                    print("User or token is missing!")
                }
            }
        }
        .onChange(of: homeViewModel.pets) { newPets in
            displayedPets = newPets
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeViewModel: HomeViewModel(), authViewModel: AuthViewModel(users: []))
    }
}
