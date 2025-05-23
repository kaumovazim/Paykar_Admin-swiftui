//
//  CreateNotificationView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/09/24.
//

import SwiftUI
import PhotosUI

struct CreateNotification: View {
    @StateObject private var notificationManager = NotificationManager()
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @Binding var description: String
    @Binding var link: String
    @Binding var selectedImage: UIImage?
    @State private var addLink = false
    @State private var linkAdded = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @FocusState var focus
    var body: some View {
        if notificationManager.isLoading {
            ProgressView("")
        } else if let errorMessage = notificationManager.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        } else if notificationManager.isSuccess {
            Text("")
                .onAppear(perform: {
                    title = ""
                    description = ""
                    link = ""
                    selectedImage = nil
                })
        } else {
            VStack(alignment: .leading, spacing: 10){
                Text("Создать уведомление:")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("Accent"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.leading)
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                            .cornerRadius(20)
                        
                    } else {
                        Image("notify")
                            .resizable()
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
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
                }
                TextField("Заголовок", text: $title)
                    .font(.system(size: 18,  weight: .semibold))
                    .foregroundColor(Color("Accent"))
                    .padding(.horizontal, 10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focus)
                TextField("Описание", text: $description)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("Accent"))
                    .padding(.horizontal, 10)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .focused($focus)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Ссылка", text: $link)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("Accent"))
                    .padding(.horizontal, 10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focus)
            }
            .padding(.bottom, 10)
            .background(Color("CardColor"))
            .cornerRadius(20)
            .overlay{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("IconColor").opacity(0.1), lineWidth: 1)
            }
            .padding(.horizontal, 15)
        }
    }
}
