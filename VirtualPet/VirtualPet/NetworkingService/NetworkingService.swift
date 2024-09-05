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
        completion: @escaping(Result<T, Error>) -> Void
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
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.failedToGetData))
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
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    func getRequest<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>) -> Void) {
        request(url: url, method: .get, completion: completion)
    }

    func postRequest<T: Decodable>(url: URL, body: Data, completion: @escaping(Result<T, Error>) -> Void) {
        request(url: url, method: .post, body: body, completion: completion)
    }

    func putRequest<T: Decodable>(url: URL, body: Data, completion: @escaping(Result<T, Error>) -> Void) {
        request(url: url, method: .put, body: body, completion: completion)
    }
}
