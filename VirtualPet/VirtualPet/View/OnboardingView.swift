//
//  OnboardingView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showRegistration = false
    @State private var showLogin = false
    @State private var navigateToHome = false

    @Binding var users: [User]
    @State private var pets: [Pet] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Spacer()
                Image("VirtualPetIconPng")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Spacer()
                NavigationLink(destination: HomeView(pets: $pets), isActive: $navigateToHome) {
                    EmptyView()
                }

                Button(action: {
                    showRegistration = true
                }) {
                    Text("Register")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showRegistration) {
                    RegistrationView(users: $users, navigateToHome: $navigateToHome)
                }

                Button(action: {
                    showLogin = true
                }) {
                    Text("Login")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showLogin) {
                    LoginView(users: $users)
                }
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
