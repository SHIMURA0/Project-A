//
//  PetCardView.swift
//  Pet
//
//  Created by Shimura on 2024/10/9.
//


import SwiftUI

struct PetCardView: View {
    var pet: Pet

    var body: some View {
        VStack {
            Image(pet.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(10)
            Text(pet.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(pet.breed)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

