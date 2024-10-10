//
//  HomeView.swift
//  Pet
//
//  Created by Shimura on 2024/10/10.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Pet Matcher")
                    .font(.largeTitle)
                    .padding()
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                NavigationLink(destination: ContentView()) {
                    Text("Start Matching")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
