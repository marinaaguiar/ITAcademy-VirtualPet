//
//  AuthViewModel.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/3/24.
//
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToHome: Bool = false

    @Published var users: [User]

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

        let newUser = User(username: username, password: password)
        users.append(newUser)

        // Reset fields and navigate to home
        resetFields()
        navigateToHome = true
    }

    func loginUser() {
        guard let user = users.first(where: { $0.username == username && $0.password == password }) else {
            alertMessage = "Invalid username or password"
            showAlert = true
            return
        }

        // Successful login
        resetFields()
        navigateToHome = true
    }

    private func resetFields() {
        username = ""
        password = ""
        confirmPassword = ""
    }
}
