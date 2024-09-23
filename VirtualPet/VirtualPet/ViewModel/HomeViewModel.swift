//
//  Untitled.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/18/24.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var showCreatePetView: Bool = false
    @Published var createPetViewModel: CreatePetViewModel? = nil

    private let userService = UserService()

    func fetchUserPets(userId: String, token: String) {
        print("Fetching pets for user ID: \(userId)")
        isLoading = true

        userService.getUserPets(userId: userId, token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let pets):
                    self.pets = pets
                case .failure(let error):
                    print("Error fetching pets: \(error.message)")
                    self.errorMessage = error.message
                }
            }
        }
    }

    func initializeCreatePetViewModel(userId: String) {
        createPetViewModel = CreatePetViewModel(pets: pets, userId: userId)
        showCreatePetView = true
    }

    func handlePetCreationSuccess(userId: String, token: String) {
        fetchUserPets(userId: userId, token: token)
    }
}
