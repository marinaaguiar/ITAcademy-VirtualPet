//
//  PetService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/26/24.
//

import Foundation

class PetService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://localhost:8080/api/pets"

    func updatePetState(
        petId: String,
        token: String,
        completion: @escaping (Result<Pet, ErrorResponse>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(petId)/pets") else {
            print("Error 400: Invalid URL for updating pet state. Check URL: \(URL(string: "\(baseURL)/\(petId)/pets"))" )
            completion(.failure(ErrorResponse(message: "Invalid URL", statusCode: 400)))
            return
        }

        networkingService.request(url: url, method: .put, addAuthToken: true) { (result: Result<Pet, ErrorResponse>) in
            switch result {
            case .success(let updatedPetState):
                print(updatedPetState)
                completion(.success(updatedPetState))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
