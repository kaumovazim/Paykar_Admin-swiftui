//
//  NotificationView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 18/09/24.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var notificationManager = NotificationManager()
    @Environment(\.dismiss) var dismiss
    @State var editing = false
    @State var deleting = false
    @State var newNotf = false
    @State var alertConnection = false
    @State var title: String = ""
    @State var description: String = ""
    @State var link: String = ""
    @State var selectedImage: UIImage? = nil
    @FocusState var focus
    
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
                        Text("Уведомления")
                            .font(.system(size: 22, weight: .semibold))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.bottom)

                }
                .ignoresSafeArea()
                .onTapGesture {
                    focus = false
                }
                if notificationManager.isLoading {
                    Spacer()
                    ProgressView("Загрузка уведомлений...")
                        .padding(.bottom, 100)
                    Spacer()
                } else if notificationManager.errorMessage != nil {
                    Spacer()
                    Text(notificationManager.errorMessage ?? "")
                    Spacer()
                } else {
                    ScrollView{
                        VStack{
                            if editing {
                                CreateNotification(title: $title, description: $description, link: $link, selectedImage: $selectedImage, focus: _focus)
                            }
                            Text("Активные уведомления:")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("Accent"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                                .padding(.leading, 20)
                            ForEach(notificationManager.categories) { category in
                                ForEach(category.categoryItemList) { notification in
                                    NotificationItem(title: notification.title, description: notification.description, date: notification.createDate, link: notification.link ?? "", preview: notification.picture ?? "", editing: $editing, elementId: notification.id, alert: $deleting)
                                        .onChange(of: deleting) {
                                            notificationManager.fetchNotifications()
                                        }
                                        .padding(.horizontal, 10)
                                }.padding(5)
                                
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top)
                }
            }
            .onAppear {
                if MainManager().checkInternetConnection() {
                    notificationManager.fetchNotifications()
                } else {
                    alertConnection = true
                }
            }
            HStack {
                if editing {
                    Button {
                        withAnimation {
                            if notificationManager.errorMessage != nil {
                                alertConnection = true
                            } else {
                                if let selectedImage = selectedImage,
                                   let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                                    notificationManager.uploadNotificationImage(imageData: imageData, title: title, description: description, link: link.isEmpty ? nil : link)
                                }
                                editing = false
                                title = ""
                                description = ""
                                link = ""
                                selectedImage = nil
                            }
                        }
                    } label: {
                        CustomButton(icon: "checkmark")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .disabled(selectedImage == nil || title.isEmpty || description.isEmpty || notificationManager.isLoading)
                    .padding(30)
                } else {
                    Button {
                        if MainManager().checkInternetConnection() {
                            notificationManager.fetchNotifications()
                        } else {
                            alertConnection = true
                        }
                    } label: {
                        CustomButton(icon: "arrow.triangle.2.circlepath")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                }                
                if editing {
                    Button {
                        withAnimation {
                            editing = false
                        }
                        title = ""
                        description = ""
                        link = ""
                        selectedImage = nil
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

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
