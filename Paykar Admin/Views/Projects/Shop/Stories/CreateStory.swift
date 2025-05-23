//
//  PhotoPicker.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 07/09/24.
//

import SwiftUI
import PhotosUI

struct CreateStory: View {
    @StateObject  var storyManager = StoryManager()
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: UIImage?
    @State var selectedItem: PhotosPickerItem? = nil
    @Binding var title: String
    @State var message: String = ""
    @Binding var creating: Bool
    @State var created: Bool
    
    var body: some View {
        if creating && !(selectedImage == nil)  && !title.isEmpty {
            VStack{
                if storyManager.isLoading {
                    ProgressView("")
                        .padding()
                } else if let errorMessage = storyManager.errorMessage {
                    Text("Ошибка: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if storyManager.isSuccess {
                    Text("Успешно")
                        .onAppear(){
                            creating = false
                            created = true
                        }
                }
            }
            .background(Color("LightGray"))
            .cornerRadius(15)
        } else {
            VStack {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                            .frame(width: 110, height: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(2)
                            .background(Color("ButtonText"))
                            .padding(1.5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 3.5)
                                    .fill(Color("IconColor").opacity(0.3))
                            }
                            .padding(.horizontal, 1)
                            .padding(.vertical, 5)
                        
                    } else {
                        Image(systemName: "plus")
                            .foregroundColor(Color("IconColor"))
                            .transition(.fade(duration: 0.3))
                            .scaledToFill()
                            .frame(width: 110, height: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(2)
                            .background(Color("ButtonText"))
                            .padding(1.5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 3.5)
                                    .fill(Color("IconColor").opacity(0.3) )
                            }
                            .padding(.horizontal, 1)
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    if let newItem = newItem {
                        newItem.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data, let uiImage = UIImage(data: data) {
                                    self.selectedImage = uiImage
                                }
                            case .failure(let error):
                                self.selectedImage = nil
                            }
                        }
                    }
                }
                TextField("Заголовок", text: $title)
                    .font(.subheadline)
                    .foregroundColor(Color("Accent"))
                    .frame(width: 110, height: 40)
                    .lineLimit(2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 5)
        }
    }
}
