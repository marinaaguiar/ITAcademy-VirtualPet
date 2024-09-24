//
//  AuthService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/4/24.
//

import Foundation

class AuthService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://10.0.0.135:8080/api/auth"

    func registerUser(username: String, password: String, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
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

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    let errorResponse = ErrorResponse(message: error.localizedDescription, statusCode: 500)
                    completion(.failure(errorResponse))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let errorResponse = ErrorResponse(message: "Invalid response from server", statusCode: 500)
                    completion(.failure(errorResponse))
                    return
                }

                if httpResponse.statusCode != 200 {
                    if let data = data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(errorResponse))
                        } catch {
                            let errorResponse = ErrorResponse(message: "Unknown error occurred", statusCode: httpResponse.statusCode)
                            completion(.failure(errorResponse))
                        }
                    } else {
                        let errorResponse = ErrorResponse(message: "No error data received", statusCode: httpResponse.statusCode)
                        completion(.failure(errorResponse))
                    }
                    return
                }

                guard let data = data else {
                    let errorResponse = ErrorResponse(message: "No data received", statusCode: 500)
                    completion(.failure(errorResponse))
                    return
                }

                do {
                    let userResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(userResponse))
                } catch {
                    let errorResponse = ErrorResponse(message: "Failed to decode user data", statusCode: 500)
                    completion(.failure(errorResponse))
                }
            }

            task.resume()
        } catch {
            let errorResponse = ErrorResponse(message: "Request creation failed", statusCode: 400)
            completion(.failure(errorResponse))
        }
    }

    func loginUser(username: String, password: String, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
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
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])

            networkingService.postRequest(url: url, body: bodyData, addAuthToken: false) { (result: Result<LoginResponse, ErrorResponse>) in
                switch result {
                case .success(let userResponse):
                    UserDefaults.standard.set(userResponse.token, forKey: "authToken")
                    completion(.success(userResponse))
                case .failure(let errorResponse):
                    print("Error: \(errorResponse)")
                    completion(.failure(errorResponse))
                }
            }
        } catch {
            let errorResponse = ErrorResponse(message: "Failed to create request body", statusCode: 400)
            print("Error: \(errorResponse)")
            completion(.failure(errorResponse))
        }
    }
}
