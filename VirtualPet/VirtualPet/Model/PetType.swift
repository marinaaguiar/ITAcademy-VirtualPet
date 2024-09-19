//
//  PetType.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation
import SwiftUI

enum PetType: String, CaseIterable, Identifiable, Codable {
    case orangeCat = "ORANGE_CAT"
    case blackCat = "BLACK_CAT"
    case lightGrayCat = "LIGHT_GRAY_CAT"
    case darkGrayCat = "DARK_GRAY_CAT"

    var id: String { self.rawValue }

    func getString() -> String {
        switch self {
        case .orangeCat: return "Orange Cat"
        case .blackCat: return "Black Cat"
        case .lightGrayCat: return "Light Gray Cat"
        case .darkGrayCat: return "DarkGray Cat"
        }
    }

    func getLottieFileName() -> String {
        switch self {
        case .orangeCat: return "Cat-Orange"
        case .blackCat: return "Cat-Black"
        case .lightGrayCat: return "Cat-LightGray"
        case .darkGrayCat: return "Cat-DarkGray"
        }
    }

    func getColor() -> Color {
        switch self {
        case .orangeCat: return .orange
        case .blackCat: return .black
        case .lightGrayCat: return .gray
        case .darkGrayCat: return .gray.opacity(0.7)
        }
    }
}

