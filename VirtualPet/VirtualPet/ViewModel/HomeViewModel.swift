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
    @Published var isLoading: Bool = false // Track loading state

    private let userService = UserService()

    func fetchUserPets(userId: String, token: String) {
        print("Fetching pets for user ID: \(userId)") // Log when the fetch starts
        isLoading = true

        userService.getUserPets(userId: userId, token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let pets):
                    print("Fetched pets: \(pets)") // Log the pets received from the server
                    self.pets = pets
                case .failure(let error):
                    print("Error fetching pets: \(error.message)") // Log the error if the request fails
                    self.errorMessage = error.message
                }
            }
        }
    }
}
