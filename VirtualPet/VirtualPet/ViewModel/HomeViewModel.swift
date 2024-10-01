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
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let userService = UserService()

    func fetchPets(userId: String, token: String, isAdmin: Bool) {
        if isAdmin {
            userService.getAllPets(userId: userId, token: token) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pets):
                        self.pets = pets
                    case .failure(let error):
                        self.alertMessage = error.message
                        self.showAlert = true
                    }
                }
            }
        } else {
            userService.getUserPets(userId: userId, token: token) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pets):
                        self.pets = pets
                    case .failure(let error):
                        self.alertMessage = error.message
                        self.showAlert = true
                    }
                }
            }
        }
    }

    func initializeCreatePetViewModel(userId: String) {
        createPetViewModel = CreatePetViewModel(pets: pets, userId: userId)
        showCreatePetView = true
    }

    func handlePetCreationSuccess(userId: String, token: String, isAdmin: Bool) {
        fetchPets(userId: userId, token: token, isAdmin: isAdmin)
    }
}
