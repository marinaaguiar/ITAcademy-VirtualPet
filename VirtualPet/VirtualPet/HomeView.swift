//
//  HomeView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isCreatingPet = false

    var body: some View {
        VStack(spacing: 35) {
            Image("VirtualPetIconPng")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

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
                CreatePetView()
            }
        }
        .padding(.top, -50)
    }
}

#Preview {
    HomeView()
}
