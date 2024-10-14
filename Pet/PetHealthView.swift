//
//  PetHealthView.swift
//  Pet
//
//  Created by Shimura on 2024/10/14.
//


import SwiftUI
import MapKit

struct PetHealthView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("宠物健康中心")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
            
            // Tab view
            Picker("", selection: $selectedTab) {
                Text("新手指南").tag(0)
                Text("常见问题").tag(1)
                Text("附近医院").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content
            TabView(selection: $selectedTab) {
                NewbieGuideView()
                    .tag(0)
                
                CommonIssuesView()
                    .tag(1)
                
                NearbyHospitalsView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct NewbieGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideItem(title: "疫苗接种", icon: "syringe", content: "定期接种疫苗对预防宠物疾病至关重要。请咨询兽医制定适合您宠物的疫苗计划。")
                
                GuideItem(title: "洗澡与清洁", icon: "shower", content: "定期洗澡可以保持宠物清洁，但不要过于频繁。一般每1-3个月洗一次，使用专门的宠物洗发水。")
                
                GuideItem(title: "营养与饮食", icon: "fork.knife", content: "选择适合年龄和品种的高质量宠物食品，控制食量，避免肥胖，并保证新鲜水源。")
                
                GuideItem(title: "定期体检", icon: "stethoscope", content: "每年至少进行一次全面体检，检查体重和身体状况，进行血液和粪便检查。")
            }
            .padding()
        }
    }
}

struct GuideItem: View {
    let title: String
    let icon: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct CommonIssuesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                IssueItem(title: "皮肤问题", symptoms: "瘙痒、脱毛、皮疹", advice: "可能是过敏或寄生虫导致，建议及时就医")
                IssueItem(title: "消化问题", symptoms: "呕吐、腹泻、食欲不振", advice: "注意饮食卫生，严重时需就医")
                IssueItem(title: "牙齿问题", symptoms: "口臭、牙结石、牙龈出血", advice: "定期刷牙，进行专业洁牙")
                // 添加更多常见问题...
            }
            .padding()
        }
    }
}

struct IssueItem: View {
    let title: String
    let symptoms: String
    let advice: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text("症状：\(symptoms)")
                .font(.subheadline)
            Text("建议：\(advice)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

struct Hospital: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double
    let rating: Double
    let features: [Feature]
    let comments: [Comment]
    let qas: [QA]
}

struct Feature: Identifiable {
    let id = UUID()
    let name: String
    let votes: Int
}

struct Comment: Identifiable {
    let id = UUID()
    let user: String
    let content: String
    let date: Date
}

struct QA: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let date: Date
}

struct HospitalCard: View {
    let hospital: Hospital
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(hospital.name)
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.triangle.turn.up.right.circle")
                    .foregroundColor(.blue)
            }
            
            HStack {
                ForEach(0..<Int(hospital.rating), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Text(String(format: "%.1f", hospital.rating))
                    .foregroundColor(.gray)
            }
            .font(.subheadline)
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.gray)
                Text(String(format: "%.1f km", hospital.distance))
                    .foregroundColor(.gray)
            }
            .font(.subheadline)
            
            if let firstFeature = hospital.features.first {
                HStack {
                    Text(firstFeature.name)
                    Text("(\(firstFeature.votes))")
                        .foregroundColor(.gray)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}


struct NearbyHospitalsView: View {
    @State private var hospitals: [Hospital] = []
    @State private var selectedHospital: Hospital?
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    
//    var body: some View {
//        VStack {
//            Map(position: $cameraPosition) {
//                ForEach(hospitals) { hospital in
//                    Marker(hospital.name, coordinate: hospital.coordinate)
//                        .tint(.red)
//                }
//            }
//            .frame(height: 300)
//            
//            List(hospitals) { hospital in
//                HospitalRow(hospital: hospital)
//                    .onTapGesture {
//                        selectedHospital = hospital
//                    }
//            }
//        }
//        .sheet(item: $selectedHospital) { hospital in
//            HospitalDetailView(hospital: hospital, isPresented: Binding(
//                get: { selectedHospital != nil },
//                set: { if !$0 { selectedHospital = nil } }
//            ))
//        }
//        .onAppear(perform: loadHospitals)
//    }
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(hospitals) { hospital in
                        HospitalCard(hospital: hospital)
                            .onTapGesture {
                                selectedHospital = hospital
                            }
                    }
                }
                .padding()
            }
            .onAppear(perform: loadHospitals)
            .sheet(item: $selectedHospital) { hospital in
                HospitalDetailView(hospital: hospital, isPresented: Binding(
                    get: { selectedHospital != nil },
                    set: { if !$0 { selectedHospital = nil } }
                ))
            }
        }
    
    private func loadHospitals() {
        // 模拟加载医院数据
        hospitals = [
            Hospital(
                name: "爱宠动物医院",
                coordinate: CLLocationCoordinate2D(latitude: 31.2354, longitude: 121.4775),
                distance: 0.5,
                rating: 4.5,
                features: [
                    Feature(name: "服务好", votes: 120),
                    Feature(name: "设备先进", votes: 85),
                    Feature(name: "价格合理", votes: 95)
                ],
                comments: [
                    Comment(user: "猫咪爱好者", content: "医生很专业，我家猫咪的皮肤病很快就好了", date: Date()),
                    Comment(user: "狗狗妈妈", content: "环境很干净，狗狗不会很紧张", date: Date().addingTimeInterval(-86400))
                ],
                qas: [
                    QA(question: "请问你们有24小时急诊吗？", answer: "是的，我们提供24小时急诊服务。", date: Date().addingTimeInterval(-172800)),
                    QA(question: "绝育手术大概需要多少费用？", answer: "绝育手术的费用因动物的体型和具体情况而异，一般在500-1500元之间。建议您带宠物来院做个评估。", date: Date().addingTimeInterval(-259200))
                ]
            ),
            // 添加更多医院...
        ]
        
        // 更新摄像机位置以显示所有医院
        if let firstHospital = hospitals.first {
            cameraPosition = .region(MKCoordinateRegion(
                center: firstHospital.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        }
    }
}


struct HospitalRow: View {
    let hospital: Hospital
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(hospital.name)
                .font(.headline)
            HStack {
                Image(systemName: "location")
                Text(String(format: "%.1f km", hospital.distance))
            }
            .foregroundColor(.secondary)
            HStack {
                ForEach(0..<Int(hospital.rating), id: \.self) { _ in
                    Image(systemName: "star.fill")
                }
                ForEach(0..<(5-Int(hospital.rating)), id: \.self) { _ in
                    Image(systemName: "star")
                }
                Text(String(format: "%.1f", hospital.rating))
            }
            .foregroundColor(.yellow)
        }
        .padding(.vertical, 8)
    }
}

struct HospitalDetailView: View {
    let hospital: Hospital
    @State private var selectedTab = 0
    @Binding var isPresented: Bool
    @State private var cameraPosition: MapCameraPosition
    
    init(hospital: Hospital, isPresented: Binding<Bool>) {
        self.hospital = hospital
        self._isPresented = isPresented
        self._cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: hospital.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Map(position: $cameraPosition) {
                        Marker(hospital.name, coordinate: hospital.coordinate)
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                    
                    HStack {
                        Text(hospital.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            Image(systemName: "location")
                            Text(String(format: "%.1f km", hospital.distance))
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        ForEach(0..<Int(hospital.rating), id: \.self) { _ in
                            Image(systemName: "star.fill")
                        }
                        ForEach(0..<(5-Int(hospital.rating)), id: \.self) { _ in
                            Image(systemName: "star")
                        }
                        Text(String(format: "%.1f", hospital.rating))
                    }
                    .foregroundColor(.yellow)
                    
                    Text("热门评价")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\"医生很专业，服务态度很好！\"")
                        Text("\"设备先进，环境干净\"")
                        Text("\"价格合理，值得推荐\"")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Picker("", selection: $selectedTab) {
                        Text("特点").tag(0)
                        Text("评论").tag(1)
                        Text("问答").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedTab == 0 {
                        FeaturesView(features: hospital.features)
                    } else if selectedTab == 1 {
                        CommentsView(comments: hospital.comments)
                    } else {
                        QAView(qas: hospital.qas)
                    }
                }
                .padding()
            }
            .navigationBarTitle("医院详情", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            })
        }
    }
}

struct FeaturesView: View {
    let features: [Feature]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(features) { feature in
                HStack {
                    Text(feature.name)
                    Spacer()
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(feature.votes)")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

struct CommentsView: View {
    let comments: [Comment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(comments) { comment in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(comment.user)
                            .font(.headline)
                        Spacer()
                        Text(comment.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(comment.content)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

struct QAView: View {
    let qas: [QA]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(qas) { qa in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q: \(qa.question)")
                        .font(.headline)
                    Text("A: \(qa.answer)")
                        .padding(.leading)
                    Text(qa.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}


//struct NearbyHospitalsView: View {
//    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    ))
//    
//    var body: some View {
//        VStack {
//            Map(position: $position) {
//                // 这里可以添加标记点等
//            }
//            .frame(height: 300)
//            
//            List {
//                HospitalItem(name: "爱宠动物医院", distance: "0.5 km", rating: 4.5)
//                HospitalItem(name: "康乐宠物诊所", distance: "1.2 km", rating: 4.2)
//                HospitalItem(name: "阳光宠物医院", distance: "2.0 km", rating: 4.8)
//                // 添加更多医院...
//            }
//        }
//    }
//}
//
//struct HospitalItem: View {
//    let name: String
//    let distance: String
//    let rating: Double
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(name)
//                    .font(.headline)
//                Text(distance)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//            HStack {
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//                Text(String(format: "%.1f", rating))
//            }
//        }
//    }
//}

struct PetHealthView_Previews: PreviewProvider {
    static var previews: some View {
        PetHealthView()
    }
}


