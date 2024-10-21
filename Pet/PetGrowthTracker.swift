//
//  PetGrowthTracker.swift
//  Pet
//
//  Created by Shimura on 2024/10/21.
//

import SwiftUI

// MARK: - Models

struct PetRecord: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: String
    var breed: String
    var birthDate: Date
    var avatar: Data?
    var milestones: [Milestone]
    var memories: [Memory] // 新添加的属性
}

struct Milestone: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var title: String
    var description: String
    var image: Data?
}

// MARK: - ViewModel

class PetViewModel: ObservableObject {
    @Published var pets: [PetRecord] = []
    
    init() {
        loadPets()
    }
    
    func addPet(_ pet: PetRecord) {
        pets.append(pet)
        savePets()
    }
    
    func updatePet(_ pet: PetRecord) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
            savePets()
        }
    }
    
    func deletePet(_ pet: PetRecord) {
        pets.removeAll { $0.id == pet.id }
        savePets()
    }
    
    func addMilestone(to pet: PetRecord, milestone: Milestone) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index].milestones.append(milestone)
            savePets()
        }
    }
    
    private func savePets() {
        if let encoded = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(encoded, forKey: "SavedPets")
        }
    }
    
    private func loadPets() {
        if let savedPets = UserDefaults.standard.data(forKey: "SavedPets") {
            if let decodedPets = try? JSONDecoder().decode([PetRecord].self, from: savedPets) {
                pets = decodedPets
            }
        }
    }
}

// MARK: - Views

struct Grow_ContentView: View {
    @StateObject private var viewModel = PetViewModel()
    @State private var showingAddPet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pets) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet, viewModel: viewModel)) {
                        PetRowView(pet: pet)
                    }
                }
                .onDelete(perform: deletePet)
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPet) {
            AddPetView(viewModel: viewModel)
        }
    }
    
    private func deletePet(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deletePet(viewModel.pets[index])
        }
    }
}

struct PetRowView: View {
    let pet: PetRecord
    
    var body: some View {
        HStack {
            if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "pawprint.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading) {
                Text(pet.name)
                    .font(.headline)
                Text(pet.breed)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AddPetView: View {
    @ObservedObject var viewModel: PetViewModel
    @State private var name = ""
    @State private var type = ""
    @State private var breed = ""
    @State private var birthDate = Date()
    @State private var avatarImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pet Information")) {
                    TextField("Name", text: $name)
                    TextField("Type", text: $type)
                    TextField("Breed", text: $breed)
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                }
                
                Section(header: Text("Pet Avatar")) {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Button("Select Avatar") {
                        showingImagePicker = true
                    }
                }
            }
            .navigationTitle("Add New Pet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newPet = PetRecord(
                            name: name,
                            type: type,
                            breed: breed,
                            birthDate: birthDate,
                            avatar: avatarImage?.pngData(),
                            milestones: [],
                            memories: []
                        )
                        viewModel.addPet(newPet)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $avatarImage)
        }
    }
}

struct TimelineView: View {
    let milestones: [Milestone]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(milestones.sorted { $0.date > $1.date }) { milestone in
                HStack(alignment: .top, spacing: 0) {
                    VStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 2)
                    }
                    .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(milestone.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(milestone.title)
                            .font(.headline)
                        
                        if let imageData = milestone.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                        }
                        
                        Text(milestone.description)
                            .font(.body)
                        
                        Divider()
                    }
                    .padding(.leading, 8)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

//struct PetDetailView: View {
//    @State var pet: PetRecord
//    @ObservedObject var viewModel: PetViewModel
//    @State private var showingAddMilestone = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 200)
//                        .clipped()
//                        .cornerRadius(8)
//                }
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(pet.name)
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    Text("\(pet.type) - \(pet.breed)")
//                        .font(.title3)
//                        .foregroundColor(.secondary)
//                    Text("Born: \(pet.birthDate, style: .date)")
//                        .font(.subheadline)
//                }
//                
//                Divider()
//                
//                Text("Milestones")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                
//                TimelineView(milestones: pet.milestones)
//            }
//            .padding()
//        }
//        .navigationTitle(pet.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: { showingAddMilestone = true }) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $showingAddMilestone) {
//            AddMilestoneView(pet: $pet, viewModel: viewModel)
//        }
//    }
//}

struct PetDetailView: View {
    @State var pet: PetRecord
    @ObservedObject var viewModel: PetViewModel
    @State private var showingAddMilestone = false
    @State private var showingAddMemory = false
    @State private var showCustomDynamicIsland = false
    
    var timeWithPet: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: pet.birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        if years > 0 {
            return "\(years) year\(years > 1 ? "s" : "") \(months) month\(months > 1 ? "s" : "")"
        } else if months > 0 {
            return "\(months) month\(months > 1 ? "s" : "") \(days) day\(days > 1 ? "s" : "")"
        } else {
            return "\(days) day\(days > 1 ? "s" : "")"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(8)
                }
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(pet.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(pet.type) - \(pet.breed)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("Born: \(pet.birthDate, style: .date)")
                        .font(.subheadline)
//                    Text("Time with you: \(timeWithPet)")
//                        .font(.headline)
//                        .foregroundColor(.blue)
//                        .padding(.top, 4)
                    // Time with you 卡片
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 30))
                        
                        VStack(alignment: .leading) {
                            Text("Time with you")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(timeWithPet)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // 宠物头像
                    Button(action: {
                        withAnimation {
                            showCustomDynamicIsland.toggle()
                        }
                    }) {
                        if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Milestones")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: { showingAddMilestone = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                TimelineView(milestones: pet.milestones)
                
                Divider()
                
                HStack {
                    Text("Memories")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: { showingAddMemory = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                MemoriesView(memories: pet.memories)
            }
            .padding()
        }
        .overlay(
            CustomDynamicIsland(isVisible: $showCustomDynamicIsland, petName: pet.name, petImage: UIImage(data: pet.avatar ?? Data()) ?? UIImage(systemName: "person.crop.circle.fill")!)
                .animation(.spring(), value: showCustomDynamicIsland)
        )
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddMilestone) {
            AddMilestoneView(pet: $pet, viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddMemory) {
            AddMemoryView(pet: $pet, viewModel: viewModel)
        }
    }
}

struct CustomDynamicIsland: View {
    @Binding var isVisible: Bool
    let petName: String
    let petImage: UIImage
    
    @State private var isAnimating = false
    @State private var playSound = false
    
    var body: some View {
        VStack {
            if isVisible {
                HStack {
                    Image(uiImage: petImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(petName)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        playSound.toggle()
                        // 这里添加播放宠物声音的代码
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.blue)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(height: 60)
        .onAppear {
            isAnimating = true
        }
        .onChange(of: playSound) { oldValue, newValue in
            withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)) {
                isAnimating.toggle()
            }
        }

    }
}
                

struct MemoriesView: View {
    let memories: [Memory]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(memories) { memory in
                VStack(alignment: .leading, spacing: 8) {
                    Text(memory.title)
                        .font(.headline)
                    Text(memory.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let imageData = memory.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    }
                    Text(memory.description)
                        .font(.body)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

struct Memory: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var title: String
    var description: String
    var image: Data?
}

struct AddMemoryView: View {
    @Binding var pet: PetRecord
    @ObservedObject var viewModel: PetViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Memory Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Image")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Button("Select Image") {
                        showingImagePicker = true
                    }
                }
            }
            .navigationTitle("Add Memory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newMemory = Memory(date: date, title: title, description: description, image: image?.pngData())
                        pet.memories.append(newMemory)
                        viewModel.updatePet(pet)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
    }
}




//struct PetDetailView: View {
//    @State var pet: PetRecord
//    @ObservedObject var viewModel: PetViewModel
//    @State private var showingAddMilestone = false
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                if let avatarData = pet.avatar, let uiImage = UIImage(data: avatarData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 200)
//                        .clipped()
//                }
//                
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(pet.name)
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    Text("\(pet.type) - \(pet.breed)")
//                        .font(.title3)
//                        .foregroundColor(.secondary)
//                    Text("Born: \(pet.birthDate, style: .date)")
//                        .font(.subheadline)
//                    
//                    Divider()
//                    
//                    Text("Milestones")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                    
//                    ForEach(pet.milestones) { milestone in
//                        MilestoneRowView(milestone: milestone)
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationTitle(pet.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: { showingAddMilestone = true }) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $showingAddMilestone) {
//            AddMilestoneView(pet: $pet, viewModel: viewModel)
//        }
//    }
//}

struct MilestoneRowView: View {
    let milestone: Milestone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(milestone.title)
                .font(.headline)
            Text(milestone.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let imageData = milestone.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipped()
            }
            Text(milestone.description)
                .font(.body)
        }
        .padding(.vertical)
    }
}

struct AddMilestoneView: View {
    @Binding var pet: PetRecord
    @ObservedObject var viewModel: PetViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Milestone Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Image")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    Button("Select Image") {
                        showingImagePicker = true
                    }
                }
            }
            .navigationTitle("Add Milestone")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newMilestone = Milestone(date: date, title: title, description: description, image: image?.pngData())
                        pet.milestones.append(newMilestone)
                        viewModel.updatePet(pet)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Grow_ContentView()
    }
}
