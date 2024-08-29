//
//  RegistrationView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Binding var users: [User]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create Account")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Password", text: $password)

                    SecureField("Confirm Password", text: $confirmPassword)
                }

                Section {
                    Button(action: registerUser) {
                        Text("Register")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Register")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func registerUser() {
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

        // Additional logic to save user data can be added here

        // Clear the fields after successful registration
        username = ""
        password = ""
        confirmPassword = ""
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(users: .constant([User(username: "Marina", password: "***")]))
    }
}
