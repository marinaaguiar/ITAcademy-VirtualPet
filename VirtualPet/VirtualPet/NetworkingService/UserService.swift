//
//  UserService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/9/24.
//

import Foundation

class UserService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://10.0.0.148:8080/api/users"

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

    func addPetToUser(userId: String, pet: Pet, completion: @escaping (Result<UserResponse, ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(userId)/addPet") else {
            completion(.failure(ErrorResponse(message: "Invalid URL", statusCode: 400)))
            return
        }

        do {
            let body = try JSONEncoder().encode(pet)

            networkingService.postRequest(url: url, body: body, addAuthToken: true) { (result: Result<UserResponse, ErrorResponse>) in
                switch result {
                case .success(let updatedUser):
                    completion(.success(updatedUser))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            print(error)
            completion(.failure(ErrorResponse(message: "Failed to encode pet data", statusCode: 400)))
        }
    }
}
