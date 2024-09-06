//
//  User.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var password: String
    var pets: [Pet]?
}
