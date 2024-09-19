//
//  AuthViewModel.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/3/24.
//
import SwiftUI
import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToHome: Bool = false
    @Published var users: [User] = []
    @Published var loggedInUser: User? = nil
    @Published var authToken: String? = nil

    private let authService = AuthService()

    init(users: [User]) {
        self.users = users
    }

    func registerUser(onSuccess: @escaping () -> Void) {
        guard !username.isEmpty, !password.isEmpty, password == confirmPassword else {
            alertMessage = "Invalid input or passwords do not match"
            showAlert = true
            return
        }

        authService.registerUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    onSuccess()
                case .failure(let errorResponse):
                    self.alertMessage = errorResponse.message
                    self.showAlert = true
                }
            }
        }
    }

    func loginUser(onSuccess: @escaping () -> Void) {
        guard !username.isEmpty && !password.isEmpty else {
            alertMessage = "Username or Password cannot be empty"
            showAlert = true
            return
        }

        authService.loginUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.loggedInUser = response.user
                    self.authToken = response.token
                    self.navigateToHome = true
                    onSuccess()
                case .failure(let errorResponse):
                    self.alertMessage = errorResponse.message
                    self.showAlert = true
                }
            }
        }
    }

    func logOutUser() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        resetFields()
        navigateToHome = false
    }

    private func resetFields() {
        username = ""
        password = ""
        confirmPassword = ""
        loggedInUser = nil
        authToken = nil
    }
}
