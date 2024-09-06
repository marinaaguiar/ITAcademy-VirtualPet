//
//  AuthService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/4/24.
//

import Foundation

class AuthService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://127.0.0.1:8080/api/auth"

    func registerUser(username: String, password: String, completion: @escaping (Result<User, ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            let errorResponse = ErrorResponse(message: "Invalid URL", statusCode: 400)
            completion(.failure(errorResponse))
            return
        }

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            networkingService.postRequest(url: url, body: jsonData, completion: completion)
        } catch {
            let errorResponse = ErrorResponse(message: "Request creation failed", statusCode: 400)
            completion(.failure(errorResponse))
        }
    }

    func loginUser(username: String, password: String, completion: @escaping (Result<User, ErrorResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            let errorResponse = ErrorResponse(message: "Invalid URL", statusCode: 400)
            completion(.failure(errorResponse))
            return
        }

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            networkingService.postRequest(url: url, body: jsonData, completion: completion)
        } catch {
            let errorResponse = ErrorResponse(message: "Request creation failed", statusCode: 400)
            completion(.failure(errorResponse))
        }
    }
}
