//
//  RegistrationView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject var router: Router

    var onSuccess: () -> Void

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Create Account")) {
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    SecureField("Password", text: $viewModel.password)

                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                }

                Section {
                    Button(action: {
                        viewModel.registerUser {
                            router.navigate(to: .home)
                        }
                    }) {
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
        }
        .navigationTitle("Register")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Registration Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(
            viewModel: AuthViewModel(users: [
                User(id: UUID().uuidString, username: "Marina", password: "***", petIds: [], admin: false)
            ]), onSuccess: {
                print("Registration successful!")
            }
        )
    }
}
