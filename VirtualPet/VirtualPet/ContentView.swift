//
//  ContentView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 8/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Virtual Pet")
        }
    }
}


#Preview {
    ContentView()
}
