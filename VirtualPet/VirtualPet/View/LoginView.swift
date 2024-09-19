//
//  LoginView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showHomeView = false
    @StateObject private var homeViewModel = HomeViewModel()

    var onSuccess: () -> Void

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
                        viewModel.loginUser {
                            showHomeView = true
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
        .background(
            NavigationLink(
                destination: HomeView(homeViewModel: homeViewModel, authViewModel: viewModel),
                isActive: $showHomeView
            ) {
                EmptyView()
            }
        )
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
            print("Login successful!")
        })
    }
}
