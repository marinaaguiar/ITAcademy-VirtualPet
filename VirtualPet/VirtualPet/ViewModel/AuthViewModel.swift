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

    private let authService = AuthService()

    init(users: [User]) {
        self.users = users
    }

    func registerUser() {
        guard !username.isEmpty else {
            alertMessage = "Username cannot be empty"
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }

        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }

        authService.registerUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.resetFields()
                    self.navigateToHome = true
                case .failure(let error):
                    self.alertMessage = "Failed to register: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }

    func loginUser() {
        guard !username.isEmpty && !password.isEmpty else {
            alertMessage = "Username or Password cannot be empty"
            showAlert = true
            return
        }

        authService.loginUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.resetFields()
                    self.navigateToHome = true
                case .failure(let error):
                    self.alertMessage = "Failed to login: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }

    private func resetFields() {
        username = ""
        password = ""
        confirmPassword = ""
    }
}
