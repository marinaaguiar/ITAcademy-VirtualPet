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
        pet: Pet,
        token: String,
        completion: @escaping (Result<Pet, ErrorResponse>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(pet.id!)") else {
            print("Error 400: Invalid URL for updating pet state.")
            completion(.failure(ErrorResponse(message: "Invalid URL", statusCode: 400)))
            return
        }

        let petUpdateRequest = PetUpdate(
            energyLevel: pet.energyLevel,
            mood: pet.mood.rawValue.uppercased(),
            needs: pet.needs.map { $0.rawValue.uppercased() },
            type: pet.type.rawValue.uppercased()
        )

        do {
            let body = try JSONEncoder().encode(petUpdateRequest)

            networkingService.putRequest(url: url, body: body, addAuthToken: true) { (result: Result<Pet, ErrorResponse>) in
                switch result {
                case .success(let updatedPetState):
                    print("Pet updated successfully!")
                    completion(.success(updatedPetState))
                case .failure(let error):
                    print("Error updating pet: \(error.message)")
                    completion(.failure(error))
                }
            }
        } catch {
            print("Error encoding pet update data: \(error)")
            completion(.failure(ErrorResponse(message: "Failed to encode pet data", statusCode: 400)))
        }
    }

    func deletePet(petId: String, token: String, completion: @escaping (Result<Void, ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(petId)") else {
            completion(.failure(ErrorResponse(message: "Invalid URL", statusCode: 400)))
            return
        }

        networkingService.deleteRequest(url: url, addAuthToken: true) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
