//
//  PetPlaceholderView.swift
//  VirtualPet
//
//  Created by Marina Aguiar on 9/23/24.
//
import SwiftUI

struct PetPlaceholderView: View {
    var body: some View {
        VStack {
            ForEach(0..<5, id: \.self) { _ in
                HStack {
                    // Placeholder for the pet image
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)

                    VStack(alignment: .leading, spacing: 5) {
                        // Placeholder for the pet's name (larger text)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 20)

                        // Placeholder for the pet's type (smaller text)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 15)
                    }

                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct PetPlaceholderView_Preview: PreviewProvider {
    static var previews: some View {
        PetPlaceholderView()
    }
}
