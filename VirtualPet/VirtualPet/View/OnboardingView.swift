//
//  OnboardingView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var users: [User]
    @State private var pets: [Pet] = []
    @StateObject private var authViewModel: AuthViewModel

    @State private var navigateToHome = false // Control navigation here

    init(users: Binding<[User]>) {
        _users = users
        _authViewModel = StateObject(wrappedValue: AuthViewModel(users: users.wrappedValue))
    }

    var body: some View {
        NavigationStack {

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.mint.opacity(0.2),
                        Color.white.opacity(0.3),
                        Color.pink.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()
                    Image("VirtualPetIconPng")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)

                    Spacer()

                    // Navigation to Home when user logs in or registers
                    NavigationLink(destination: HomeView(pets: $pets, authViewModel: AuthViewModel(users: users))
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true),
                                   isActive: $navigateToHome) {
                        EmptyView()
                    }

                    NavigationLink(destination: RegistrationView(viewModel: authViewModel, onSuccess: {
                        navigateToHome = true // Trigger navigation on success
                    })) {
                        Text("Register")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: LoginView(viewModel: authViewModel, onSuccess: {
                        navigateToHome = true // Trigger navigation on success
                    })) {
                        Text("Login")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(32)
                .navigationTitle("Virtual Pet")
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(users: .constant([User(id: UUID().uuidString, username: "SampleUser", password: "*****", pets: [])]))
    }
}
