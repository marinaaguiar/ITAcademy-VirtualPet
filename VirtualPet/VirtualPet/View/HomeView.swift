//
//  HomeView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isCreatingPet = false
    @State private var pets: [Pet] = []
    @Binding var users: [User]

    var body: some View {
        VStack(spacing: 35) {
            Image("VirtualPetIconPng")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            NavigationLink(destination: RegistrationView(users: $users)) {
                Text("Register New Account")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                isCreatingPet = true
            }) {
                Text("Create a New Pet")
                    .font(.headline)
                    .padding()
                    .background(Color.mint)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isCreatingPet) {
                CreatePetView(isPresented: $isCreatingPet, pets: $pets)
            }
        }
        .padding(.top, -50)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(users: .constant([User(username: "Marina", password: "***")]))
    }
}
