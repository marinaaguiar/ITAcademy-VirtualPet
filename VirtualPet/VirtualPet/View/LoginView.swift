//
//  LoginView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    var onSuccess: () -> Void // Pass this closure to handle navigation on success

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Login")) {
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Password", text: $viewModel.password)
                }

                Section {
                    Button(action: {
                        viewModel.loginUser()
                        if viewModel.navigateToHome {
                            onSuccess() // Call success closure to trigger navigation
                        }
                    }) {
                        Text("Login")
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
        }
        .navigationTitle("Sign in")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Login Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel(users: [
            User(
                id: UUID().uuidString,
                username: "SampleUser",
                password: "*****",
                pets: []
            )
        ]), onSuccess: {
            // Placeholder closure for the preview
            print("Login successful!")
        })
    }
}
