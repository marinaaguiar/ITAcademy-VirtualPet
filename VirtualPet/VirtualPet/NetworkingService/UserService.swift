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

    func addPetToUser(userId: String, pet: Pet, completion: @escaping (Result<User, ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(userId)/pets") else {
            let errorResponse = ErrorResponse(message: "Invalid URL", statusCode: 400)
            completion(.failure(errorResponse))
            return
        }

        do {
            let jsonData = try JSONEncoder().encode(pet)
            networkingService.postRequest(url: url, body: jsonData, completion: completion)
        } catch {
            let errorResponse = ErrorResponse(message: "Failed to encode pet", statusCode: 400)
            completion(.failure(errorResponse))
        }
    }
}
