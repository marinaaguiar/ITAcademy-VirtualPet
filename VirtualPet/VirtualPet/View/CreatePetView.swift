//
//  CreatePetView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct CreatePetView: View {
    @ObservedObject var viewModel: CreatePetViewModel

    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.mint.opacity(0.3),
                        Color.white.opacity(0.5),
                        Color.pink.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .center
                )
                .ignoresSafeArea()
                
                VStack {
                    LottieView(filename: viewModel.selectedCreature.getLottieFileName())
                        .frame(height: 200)
                        .clipped()
                        .padding(.top, 20)
                    
                    Form {
                        Section(header: Text("Pet Details")) {
                            TextField("Pet Name", text: $viewModel.petName)
                            
                            TextField("Unique Characteristic", text: $viewModel.uniqueCharacteristic)
                        }
                        
                        Section(header: Text("Choose Your Cat")) {
                            Picker("Color", selection: $viewModel.selectedCreature) {
                                ForEach(PetType.allCases) { creature in
                                    Text(creature.rawValue).tag(creature)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Section {
                            Button(action: {
                                viewModel.createPet()
                                isPresented = false
                            }) {
                                Text("Create Pet")
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
                    .navigationTitle("Create a Pet")
                    .navigationBarItems(trailing: Button("Cancel") {
                        isPresented = false
                    })
                }
            }
        }
    }
}

struct CreatePetView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePetView(viewModel: CreatePetViewModel(pets: []), isPresented: .constant(true))
    }
}
