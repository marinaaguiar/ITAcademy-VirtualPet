//
//  PetType.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation

enum PetType: String, CaseIterable, Identifiable {
    case cat = "Cat"
    case dog = "Dog"
    case rabbit = "Rabbit"
    case bear = "Bear"

    var id: String { self.rawValue }
}

