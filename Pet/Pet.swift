//
//  Pet.swift
//  Pet
//
//  Created by Shimura on 2024/10/9.
//

import Foundation

struct Pet: Identifiable {
    let id = UUID()
    let name: String
    let breed: String
    let image: String // 这里可以是图片的名称
}

