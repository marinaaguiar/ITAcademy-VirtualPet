//
//  PetUpdateRequest.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/30/24.
//

struct PetUpdate: Encodable {
    var energyLevel: Int
    var mood: String
    var needs: [String]
    var type: String
}
