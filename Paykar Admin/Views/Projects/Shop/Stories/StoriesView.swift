//
//  StoriesView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 07/09/24.
//

import SwiftUI
import PhotosUI

struct StoriesView: View {
    @StateObject private var storyManager = StoryManager()
    @Environment(\.dismiss) var dismiss
    @State var seen = false
    @State var creating = false
    @State var editing = false
    @State var deleting = false
    @State var presented = false
    @State var selectedImage: UIImage? = nil
    @State var selectedItem: PhotosPickerItem? = nil
    @State var title: String = ""
    @State var alertConnection = false
    @State var created = false

    var body: some View {
        ZStack{
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("Secondary"))
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .bottom)
                        
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            ButtonCircleView(iconName: "chevron.left", background: "")
                                .padding(.leading)
                        }
                        Text("Истории")
                            .font(.system(size: 22, weight: .semibold))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.bottom)

                }
                .ignoresSafeArea()
                VStack {
                    if storyManager.isLoading {
                        Spacer()
                        ProgressView("Загрузка историй...")
                            .padding(.bottom, 100)
                        Spacer()
                    } else if storyManager.errorMessage != nil {
                        Spacer()
                        Text("")
                            .onAppear(perform: {
                                alertConnection = true
                            })
                        Spacer()
                    } else {
                        List(storyManager.storyList) { group in
                            ScrollView(.horizontal) {
                                VStack(alignment: .leading) {
                                    Text(group.groupName)
                                        .font(.headline)
                                        .foregroundColor(Color("Accent"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.top)
                                }
                                HStack {
                                    if editing {
                                        CreateStory(selectedImage: $selectedImage, title: $title, creating: $creating, created: created)
                                    }
                                    let sortedItems = group.groupItemList.sorted { $0.id > $1.id }
                                    
                                    ForEach(sortedItems) { item in
                                            StoryItem(preview: item.picture, seen: seen, editing: $editing, presented: presented, elementId: item.id, alert: $deleting, title: item.name)
                                            .padding(.horizontal, 5)
                                        .onChange(of: deleting) {
                                            storyManager.getStoryList()
                                        }
                                    }
                                }
                            }.scrollIndicators(.hidden)
                        }
                        .listStyle(.inset)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear() {
                if MainManager().checkInternetConnection() {
                    storyManager.getStoryList()
                } else {
                    alertConnection = true
                }
            }
            
            HStack {
                if editing {
                    Button {
                        withAnimation {
                            if MainManager().checkInternetConnection() {
                                if let selectedImage = selectedImage,
                                   let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                    storyManager.uploadStoryImage(imageData: imageData, title: title)
                                }
                                creating = true
                                editing = false
                                selectedImage = nil
                                title = ""
                            } else {
                                alertConnection = true
                                creating = false
                            }
                        }
                    } label: {
                        CustomButton(icon: "checkmark")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                    .disabled(title.isEmpty || selectedImage == nil)
                } else {
                    Button {
                        if MainManager().checkInternetConnection() {
                            storyManager.getStoryList()
                        } else {
                            alertConnection = true
                        }
                    } label: {
                        CustomButton(icon: "arrow.triangle.2.circlepath")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                }
                Spacer()
                if editing {
                    Button {
                        withAnimation {
                            editing = false
                        }
                        selectedImage = nil
                        title = ""
                    } label: {
                        CustomButton(icon: "multiply")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(30)
                } else {
                    Button {
                        withAnimation {
                            editing = true
                        }
                    } label: {
                        CustomButton(icon: "pencil")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(30)
                }
            }
        }
        .ignoresSafeArea()
        .alert("", isPresented: $alertConnection) {
            Button("Попробовать снова", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к интернету и попробуйте снова.")
        }
    }
}

#Preview {
    StoriesView()
}
