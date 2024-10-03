//
//  NetworkingService.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/4/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case failedToGetData
    case invalidResponse
    case invalidURL
}

class NetworkingService {

    private var sharedSession: URLSession { URLSession.shared }

    private var authToken: String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }

    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        addAuthToken: Bool = false,
        completion: @escaping(Result<T, ErrorResponse>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if addAuthToken, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Authorization Token: \(token)")
        }

        if let httpBody = request.httpBody {
            print("Request Body: \(String(data: httpBody, encoding: .utf8) ?? "")")
        }
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")

        let task = sharedSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: error.localizedDescription, statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "Invalid response from server", statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            print("Status code: \(httpResponse.statusCode)")

            guard let data = data else {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "No data received", statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            let rawResponse = String(data: data, encoding: .utf8)
            print("Raw response: \(rawResponse ?? "")")

            do {
                if (200...299).contains(httpResponse.statusCode) {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                } else {
                    let errorData = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.failure(errorData))
                    }
                }
            } catch {
                print("Decoding error: \(error)")
                print("Raw response: \(String(data: data, encoding: .utf8) ?? "")")
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "Failed to decode response", statusCode: 500)
                    completion(.failure(errorResponse))
                }
            }
        }
        task.resume()
    }

    func getRequest<T: Decodable>(url: URL, completion: @escaping(Result<T, ErrorResponse>) -> Void) {
        request(url: url, method: .get, completion: completion)
    }

    func postRequest<T: Decodable>(url: URL, body: Data, addAuthToken: Bool = true, completion: @escaping(Result<T, ErrorResponse>) -> Void) {
        request(url: url, method: .post, body: body, addAuthToken: addAuthToken, completion: completion)
    }

    func putRequest<T: Decodable>(url: URL, body: Data, addAuthToken: Bool = true, completion: @escaping(Result<T, ErrorResponse>) -> Void) {
        request(url: url, method: .put, body: body, addAuthToken: addAuthToken, completion: completion)
    }

    func deleteRequest(url: URL, addAuthToken: Bool = true, completion: @escaping(Result<Void, ErrorResponse>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue

        if addAuthToken, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Authorization Token: \(token)")
        }

        let task = sharedSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: error.localizedDescription, statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "Invalid response from server", statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            print("Status code: \(httpResponse.statusCode)")

            if (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "Error: \(httpResponse.statusCode)", statusCode: httpResponse.statusCode)
                    completion(.failure(errorResponse))
                }
            }
        }
        task.resume()
    }
}
