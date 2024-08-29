//
//  LoginView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode

    @Binding var users: [User]

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Form {
                    Section(header: Text("Login")) {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $password)
                    }

                    Section {
                        Button(action: loginUser) {
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
        }
    }

    private func loginUser() {
        guard let user = users.first(where: { $0.username == username && $0.password == password }) else {
            // Handle login failure
            return
        }

        // Handle successful login
        presentationMode.wrappedValue.dismiss()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(users: .constant([User(username: "SampleUser", password: "*****")]))
    }
}
