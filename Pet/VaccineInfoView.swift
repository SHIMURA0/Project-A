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
                
                HStack {
                    Image(systemName: "clock")
                    Text("接种时间: \(vaccine.timing)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: width)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    
//    func petTypeIcon(for type: PetType) -> String {
//        switch type {
//        case .dog:
//            return "dog"
//        case .cat:
//            return "cat"
//        case .both:
//            return "pawprint.fill"
//        }
//    }
    func petTypeIcon(for type: PetType) -> String {
        switch type {
        case .dog:
            return "dog"
        case .cat:
            return "cat"
        case .both:
            return "pawprint.fill"
        case .rabbit:
            return "hare"
        case .bird:
            return "bird"
        case .guineaPig:
            return "tortoise"  // 使用乌龟图标代替,因为没有豚鼠专用图标
        case .hamster:
            return "lizard"  // 使用蜥蜴图标代替,因为没有仓鼠专用图标
        case .pig:
            return "hare.fill"  // 使用兔子填充图标代替,因为没有猪专用图标
        case .other:
            return "questionmark.circle"
        }
    }
}

//enum PetType {
//    case dog
//    case cat
//    case both
//}

enum PetType {
    case dog
    case cat
    case both
    case rabbit
    case bird
    case guineaPig
    case hamster
    case pig
    case other
}

func petTypeIcon(for type: PetType) -> String {
    switch type {
    case .dog:
        return "dog"
    case .cat:
        return "cat"
    case .both:
        return "pawprint.fill"
    case .rabbit:
        return "hare"
    case .bird:
        return "bird"
    case .guineaPig:
        return "tortoise"  // 使用乌龟图标代替,因为没有豚鼠专用图标
    case .hamster:
        return "lizard"  // 使用蜥蜴图标代替,因为没有仓鼠专用图标
    case .pig:
        return "hare.fill"  // 使用兔子填充图标代替,因为没有猪专用图标
    case .other:
        return "questionmark.circle"
    }
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
    // 狗的核心疫苗
    VaccineInfo(
        name: "犬瘟热疫苗",
        description: "预防犬瘟热，这是一种高度传染性的病毒性疾病，影响呼吸系统、消化系统和神经系统。",
        timing: "6-8周龄开始，每2-4周接种一次，直到16周龄",
        color: .blue,
        petType: .dog
    ),
    VaccineInfo(
        name: "犬传染性肝炎疫苗",
        description: "预防由犬腺病毒引起的传染性肝炎，这种疾病会影响肝脏、肾脏、眼睛和肺。",
        timing: "6-8周龄开始，与犬瘟热疫苗同时接种",
        color: .green,
        petType: .dog
    ),
    VaccineInfo(
        name: "犬细小病毒疫苗",
        description: "预防犬细小病毒感染，这是一种严重的肠道疾病，特别是对幼犬致命。",
        timing: "6-8周龄开始，每2-4周接种一次，直到16周龄",
        color: .orange,
        petType: .dog
    ),
    
    // 猫的核心疫苗
    VaccineInfo(
        name: "猫瘟疫苗",
        description: "预防猫瘟（猫泛白细胞减少症），这是一种严重的病毒性疾病，影响免疫系统和肠道。",
        timing: "6-8周龄开始，每3-4周接种一次，直到16周龄",
        color: .purple,
        petType: .cat
    ),
    VaccineInfo(
        name: "猫病毒性鼻气管炎疫苗",
        description: "预防由猫疱疹病毒引起的上呼吸道感染，常见症状包括打喷嚏和流眼泪。",
        timing: "6-8周龄开始，每3-4周接种一次，直到16周龄",
        color: .teal,
        petType: .cat
    ),
    VaccineInfo(
        name: "猫杯状病毒疫苗",
        description: "预防由猫杯状病毒引起的上呼吸道感染，可能导致口腔溃疡和慢性牙龈炎。",
        timing: "6-8周龄开始，每3-4周接种一次，直到16周龄",
        color: .pink,
        petType: .cat
    ),
    
    // 狗和猫都需要的核心疫苗
    VaccineInfo(
        name: "狂犬病疫苗",
        description: "预防狂犬病，这是一种致命的病毒性疾病，可传染给人类。在许多地区是法律要求。",
        timing: "12-16周龄首次接种，一年后加强，之后根据当地法规定期接种",
        color: .red,
        petType: .both
    ),
    
    // 狗的非核心疫苗
    VaccineInfo(
        name: "犬舍咳疫苗",
        description: "预防犬传染性气管支气管炎，常见于犬舍、寄养设施等狗群聚集的地方。",
        timing: "6-8周龄开始，可能需要追加剂量",
        color: .yellow,
        petType: .dog
    ),
    VaccineInfo(
        name: "犬流感疫苗",
        description: "预防犬流感，这是一种高度传染性的呼吸道疾病。",
        timing: "6-8周龄可以开始，需要两剂初始疫苗",
        color: .mint,
        petType: .dog
    ),
    
    // 猫的非核心疫苗
    VaccineInfo(
        name: "猫白血病病毒疫苗",
        description: "预防猫白血病病毒感染，这种病毒会影响免疫系统，增加癌症风险。",
        timing: "8周龄开始，3-4周后需要第二剂",
        color: .indigo,
        petType: .cat
    ),
    VaccineInfo(
        name: "猫艾滋病毒疫苗",
        description: "预防猫艾滋病毒感染，这种病毒会损害猫的免疫系统。主要通过打斗传播。",
        timing: "8周龄开始，需要多次接种",
        color: .cyan,
        petType: .cat
    ),
    // 兔子
        VaccineInfo(
            name: "兔出血症疫苗",
            description: "预防兔出血症病毒(RHDV),这是一种高度传染性和致命的疾病,影响野兔和家兔。",
            timing: "10-12周龄首次接种,之后每年接种一次",
            color: .purple,
            petType: .rabbit
        ),
        VaccineInfo(
            name: "兔粘液瘤病毒疫苗",
            description: "预防由兔粘液瘤病毒引起的疾病,这种病毒会导致皮肤肿瘤和其他健康问题。",
            timing: "12周龄以上接种,之后每年接种一次",
            color: .orange,
            petType: .rabbit
        ),

        // 鸟类(以鹦鹉为例)
        VaccineInfo(
            name: "禽流感疫苗",
            description: "预防禽流感,这是一种可能影响多种鸟类的病毒性疾病。",
            timing: "根据兽医建议,通常在幼鸟期开始接种",
            color: .blue,
            petType: .bird
        ),
        VaccineInfo(
            name: "鹦鹉热疫苗",
            description: "预防由衣原体引起的鹦鹉热,这是一种可以传染给人类的疾病。",
            timing: "根据兽医建议,通常在幼鸟期开始接种",
            color: .green,
            petType: .bird
        ),

        // 豚鼠
        VaccineInfo(
            name: "链球菌肺炎疫苗",
            description: "预防由链球菌引起的肺炎,这是豚鼠常见的呼吸道疾病。",
            timing: "根据兽医建议,通常在2-3月龄开始接种",
            color: .pink,
            petType: .guineaPig
        ),

        // 仓鼠
        VaccineInfo(
            name: "目前无常规疫苗",
            description: "仓鼠通常不需要常规疫苗接种。保持良好的卫生和定期健康检查更为重要。",
            timing: "不适用",
            color: .gray,
            petType: .hamster
        ),

        // 猪(作为宠物)
        VaccineInfo(
            name: "猪瘟疫苗",
            description: "预防猪瘟,这是一种高度传染性的病毒性疾病,可能对猪致命。",
            timing: "通常在2-3月龄接种,之后每年接种一次",
            color: .red,
            petType: .pig
        ),
        VaccineInfo(
            name: "猪圆环病毒疫苗",
            description: "预防由猪圆环病毒引起的疾病,可能导致生长迟缓和其他健康问题。",
            timing: "通常在3-4周龄开始接种,可能需要追加剂量",
            color: .orange,
            petType: .pig
        )
]


struct VaccineInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VaccineInfoView()
        }
    }
}



