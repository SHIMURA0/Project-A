//
//  VaccineInfoView.swift
//  Pet
//
//  Created by Shimura on 2024/10/19.
//


import SwiftUI

struct VaccineInfoView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    HeaderView()
                    IntroductionView(width: geometry.size.width - 32) // 32 是左右padding的总和
                    
                    ForEach(vaccineData) { vaccine in
                        VaccineCard(vaccine: vaccine, width: geometry.size.width - 32)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
//        .navigationBarTitle("疫苗科普", displayMode: .inline)
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Image(systemName: "syringe")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("宠物疫苗科普")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
    }
}

struct IntroductionView: View {
    let width: CGFloat
    
    var body: some View {
        Text("疫苗接种对于预防宠物疾病至关重要。了解以下常见的宠物疫苗信息，为您的宠物提供更好的保护。")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
            .frame(width: width)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

struct VaccineCard: View {
    let vaccine: VaccineInfo
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(vaccine.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(vaccine.color)
                    .cornerRadius(5)
                
                Spacer()
                
                Image(systemName: petTypeIcon(for: vaccine.petType))
                    .foregroundColor(vaccine.color)
                    .font(.system(size: 24))
            }
            
            Text(vaccine.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Spacer()
            
            HStack {
                Image(systemName: "clock")
                Text("接种时间: \(vaccine.timing)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: width, height: 180)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    func petTypeIcon(for type: PetType) -> String {
        switch type {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        case .both:
            return "pawprint.fill"
        }
    }
}

enum PetType {
    case dog
    case cat
    case both
}

struct VaccineInfo: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let timing: String
    let color: Color
    let petType: PetType
}

let vaccineData = [
    VaccineInfo(name: "犬瘟热疫苗", description: "预防犬瘟热，这是一种高度传染性的病毒性疾病。", timing: "8-10周龄开始", color: .blue, petType: .dog),
    VaccineInfo(name: "狂犬病疫苗", description: "预防狂犬病，这是一种致命的病毒性疾病，可传染给人类。", timing: "12-16周龄首次接种", color: .red, petType: .both),
    VaccineInfo(name: "猫三联疫苗", description: "预防猫瘟、猫鼻支和猫杯状病毒，这些都是常见的猫科疾病。", timing: "6-8周龄开始", color: .green, petType: .cat),
    VaccineInfo(name: "犬细小病毒疫苗", description: "预防犬细小病毒感染，这是一种严重的肠道疾病。", timing: "6-8周龄开始", color: .orange, petType: .dog)
]

struct VaccineInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VaccineInfoView()
        }
    }
}



