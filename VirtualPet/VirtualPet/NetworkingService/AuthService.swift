//
//  AuthService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/4/24.
//

import Foundation

struct UserResponse: Decodable {
    let token: String
}

class AuthService {
    private let networkingService = NetworkingService()
    private let baseURL = "http://localhost:8080/api/auth"

    func registerUser(username: String, password: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        print("URL: \(url)")

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)

            print("Request body: \(String(data: jsonData, encoding: .utf8)!)")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(NSError(domain: "Invalid response from server", code: 500, userInfo: nil)))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 500, userInfo: nil)))
                    return
                }

                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    completion(.success(userResponse))
                } catch {
                    completion(.failure(error))
                }
            }

            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    func loginUser(username: String, password: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            networkingService.postRequest(url: url, body: bodyData, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
