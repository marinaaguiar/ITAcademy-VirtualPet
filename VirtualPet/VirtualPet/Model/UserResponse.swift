//
//  UserResponse.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/19/24.
//

struct UserResponse: Identifiable, Codable {
    let id: String
    var username: String
    var password: String?
    var pet: [Pet]
    var isAdmin: Bool
}
