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

    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        completion: @escaping(Result<T, ErrorResponse>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

            if httpResponse.statusCode != 200 {
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            let errorResponse = ErrorResponse(message: "Unknown error occurred", statusCode: httpResponse.statusCode)
                            completion(.failure(errorResponse))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let errorResponse = ErrorResponse(message: "No error data received", statusCode: httpResponse.statusCode)
                        completion(.failure(errorResponse))
                    }
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    let errorResponse = ErrorResponse(message: "No data received", statusCode: 500)
                    completion(.failure(errorResponse))
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
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

    func postRequest<T: Decodable>(url: URL, body: Data, completion: @escaping(Result<T, ErrorResponse>) -> Void) {
        request(url: url, method: .post, body: body, completion: completion)
    }

    func putRequest<T: Decodable>(url: URL, body: Data, completion: @escaping(Result<T, ErrorResponse>) -> Void) {
        request(url: url, method: .put, body: body, completion: completion)
    }
}
