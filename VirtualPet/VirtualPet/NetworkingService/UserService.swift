//
//  UserService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/9/24.
//

import Foundation

class UserService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://127.0.0.1:8080/api/users"

    func getUserPets(userId: String, token: String, completion: @escaping (Result<[Pet], ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(userId)/pets") else {
            completion(.failure(ErrorResponse(message: "Invalid URL", statusCode: 400)))
            return
        }

        networkingService.request(url: url, method: .get, addAuthToken: true) { (result: Result<[Pet], ErrorResponse>) in
            switch result {
            case .success(let pets):
                completion(.success(pets))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addPetToUser(userId: String, pet: Pet, completion: @escaping (Result<User, ErrorResponse>) -> Void) {
        // Add logic for adding a new pet (Not required right now)
    }
}
