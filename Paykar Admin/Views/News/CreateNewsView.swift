//
//  CreateNewsView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 25.04.2025.
//
import SwiftUI
import PhotosUI

struct CreateNewsView: View {
    @StateObject private var newsCreator = CreateNews()
    @State private var title = ""
    @State private var description = ""
    @State private var link = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss

    private let animation = Animation.spring(response: 0.4, dampingFraction: 0.8)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title Input
                    InputSection(
                        placeholder: "Введите заголовок новости",
                        text: $title,
                        height: 56
                    )
                    .padding(.top, 16)

                    // Description Input
                    InputSection(
                        placeholder: "Введите подробное описание новости",
                        text: $description,
                        isTextEditor: true,
                        height: 200
                    )

                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        ImagePickerView(imageData: imageData)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Создать новость")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        submitNews()
                    } label: {
                        if newsCreator.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Создать")
                                .foregroundStyle(Color.green)
                        }
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
            .alert("Результат", isPresented: $showAlert) {
                Button("OK", role: .cancel) { dismiss() }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: selectedImage) { newItem in
                if let item = newItem {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            withAnimation(animation) {
                                imageData = data
                            }
                        }
                    }
                }
            }
        }
    }

    private func submitNews() {
        withAnimation(animation) {
            newsCreator.isLoading = true
        }

        newsCreator.create(titel: title, discription: description, imageData: imageData, link: link) { response in
            withAnimation(animation) {
                newsCreator.isLoading = false
                alertMessage = response.message ?? "Что-то пошло не так"
                showAlert = true
            }
        }
    }
}

// MARK: - Subviews
struct InputSection: View {
    var placeholder: String
    @Binding var text: String
    var isTextEditor: Bool = false
    var height: CGFloat
    
    var body: some View {
        // Основное поле ввода
        if isTextEditor {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(height: height)
                    .padding(4)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray5), lineWidth: 1.5)
                    )
                    .scrollContentBackground(.hidden)
                    .font(.body) // стандартный шрифт как у TextField
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(UIColor.placeholderText)) // системный цвет placeholder'а
                        .padding(.horizontal, isTextEditor ? 8 : 12)
                        .padding(.vertical, isTextEditor ? 12 : 0)
                        .font(.body) // как у TextField
                        .allowsHitTesting(false)
                }
            }
        } else {
            TextField(placeholder, text: $text)
                .frame(height: height)
                .padding(.horizontal, 8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1.5)
                )
        }
    }
}

struct ImagePickerView: View {
    let imageData: Data?

    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            let isVertical = uiImage.size.height > uiImage.size.width
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit() // Preserve aspect ratio, no cropping
                .frame(
                    maxWidth: isVertical ? 200  : 180,
                    maxHeight: isVertical ? 180 : 240 // Wider for vertical, taller for horizontal
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray5), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        } else {
            HStack(spacing: 8) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.green)
                Text("Добавить изображение")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color(.systemGray5), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
    }
}

#Preview {
    CreateNewsView()
}
