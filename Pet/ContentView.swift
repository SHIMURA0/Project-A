//
//  ContentView.swift
//  Pet
//
//  Created by Shimura on 2024/10/9.
//

import SwiftUI

struct ContentView: View {
    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            ForEach(currentIndex..<pets.count, id: \.self) { index in
                PetCardView(pet: pets[index])
                    .scaleEffect(0.8) // 缩小卡片到 80%
                    .offset(x: CGFloat(index - currentIndex) * 10, y: 0)
                    .rotationEffect(.degrees(Double(index - currentIndex) * 3)) // 保持小角度
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // 处理滑动
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.translation.width > 100 {
                                        // 右滑，喜欢
                                        currentIndex += 1
                                    } else if value.translation.width < -100 {
                                        // 左滑，不喜欢
                                        currentIndex += 1
                                    }
                                }
                            }
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.9) // 限制卡片宽度
            }
        }
        .padding()
    }
}






#Preview {
    ContentView()
}
