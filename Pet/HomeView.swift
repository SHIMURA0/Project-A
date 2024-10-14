//
//  HomeView.swift
//  Pet
//
//  Created by Shimura on 2024/10/10.
//

import SwiftUI

struct HomeView: View {
    @State private var isPressed = false
    @State private var isAuthenticated = false
    @State private var navigateToContentView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Pet Matcher")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    navigateToContentView = true
                }) {
                    Text("Start Matching")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isPressed ? 120 : 100, height: isPressed ? 120 : 100)
                    .foregroundColor(isPressed ? .blue : .gray)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onChanged { _ in
                                isPressed = true
                            }
                            .onEnded { _ in
                                isPressed = false
                                authenticate()
                            }
                    )
                    .padding(.bottom, 50)
            }
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView()
            }
        }
    }
    
    func authenticate() {
        // 这里可以添加实际的认证逻辑
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAuthenticated = true
            navigateToContentView = true // 触发导航到 ContentView
        }
    }
}

#Preview {
    HomeView()
}




