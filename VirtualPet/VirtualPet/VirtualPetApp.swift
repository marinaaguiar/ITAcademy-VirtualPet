//
//  VirtualPetApp.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

@main
struct VirtualPetApp: App {
    @StateObject var router = Router()
    @StateObject var authViewModel = AuthViewModel(users: [User(id: UUID().uuidString, username: "Marina", password: "***", petIds: [], admin: false)])

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch router.currentRoute {
                case .onboarding:
                    OnboardingView(authViewModel: authViewModel)
                case .login:
                    LoginView(viewModel: authViewModel) {
                      router.navigate(to: .home)
                    }
                case .registration:
                    RegistrationView(viewModel: authViewModel) {
                      router.navigate(to: .home)
                    }

                case .home:
                    HomeView(authViewModel: authViewModel)
                }
            }
            .environmentObject(router)
        }
    }
}
