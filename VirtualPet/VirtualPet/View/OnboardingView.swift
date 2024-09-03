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

    init(users: Binding<[User]>) {
        _users = users
        _authViewModel = StateObject(wrappedValue: AuthViewModel(users: users.wrappedValue))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer()
                Image("VirtualPetIconPng")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Spacer()

                // NavigationLink for HomeView, triggered by authViewModel.navigateToHome
                NavigationLink(destination: HomeView(pets: $pets), isActive: $authViewModel.navigateToHome) {
                    EmptyView()
                }

                NavigationLink(destination: RegistrationView(viewModel: authViewModel)) {
                    Text("Register")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: LoginView(viewModel: authViewModel)) {
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(users: .constant([User(username: "SampleUser", password: "*****")]))
    }
}
