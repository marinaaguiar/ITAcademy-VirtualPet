//
//  VirtualPetApp.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

@main
struct VirtualPetApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(users: .constant([User(id: UUID().uuidString, username: "Marina", password: "***", pets: [])]))
        }
    }
}
