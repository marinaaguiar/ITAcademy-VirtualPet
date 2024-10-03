//
//  ErrorResponse.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/6/24.
//

import Foundation

struct ErrorResponse: Error, Codable {
    let message: String
    var statusCode: Int?
}
