//
//  UserWithResponse.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/9/24.
//

import Foundation

struct UserResponse: Codable {
    let user: User
    let token: String
}
