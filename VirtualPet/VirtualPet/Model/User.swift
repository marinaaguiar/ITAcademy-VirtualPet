//
//  User.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    var username: String
    var password: String
}
