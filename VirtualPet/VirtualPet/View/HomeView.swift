//
//  HomeView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showCreatePetView = false
    @State private var hasFetchedPets = false
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BackgroundGradient()

            VStack {
                if homeViewModel.isLoading {
                    LoadingView()
                } else if homeViewModel.pets.isEmpty {
                    EmptyStateView(showCreatePetView: $showCreatePetView)
                } else {
                    PetListView(homeViewModel: homeViewModel)
                }
                Spacer()
            }
            .background(Color.clear)
            .navigationTitle("Virtual Pet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        authViewModel.logOutUser()
                    }
                    .foregroundColor(.red)
                }
            }

        }
        .onAppear {
            if !hasFetchedPets {
                fetchPets()
            }
        }
    }

    private func fetchPets() {
        if let user = authViewModel.loggedInUser,
           let token = authViewModel.authToken {
            hasFetchedPets = true
            homeViewModel.fetchUserPets(userId: user.id, token: token)
        } else {
            print("User or token is missing!")
        }
    }
}

// MARK: - Background Gradient View
struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.mint.opacity(0.2),
                Color.white.opacity(0.8),
                Color.pink.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading Pets...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    @Binding var showCreatePetView: Bool

    var body: some View {
        VStack {
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
            .sheet(isPresented: $showCreatePetView) {
                CreatePetView(viewModel: CreatePetViewModel(pets: [], userId: "userId"), isPresented: $showCreatePetView)
            }
        }
    }
}

// MARK: - Pet List View
struct PetListView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @State private var showCreatePetView = false

    var body: some View {
        ZStack {
            Color.white

            VStack {
                List(homeViewModel.pets) { pet in
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
                                Text(pet.type.getString())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                FloatingActionButton(showCreatePetView: $showCreatePetView)
                    .padding(.bottom, 30)
            }
        }
        .padding(.bottom, -40)
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    @Binding var showCreatePetView: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Button(action: {
                showCreatePetView = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                    Text("Create a New Pet")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.mint)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
            .sheet(isPresented: $showCreatePetView) {
                CreatePetView(viewModel: CreatePetViewModel(pets: [], userId: "userId"), isPresented: $showCreatePetView)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            homeViewModel: HomeViewModel(),
            authViewModel: AuthViewModel(users: []))
    }
}
