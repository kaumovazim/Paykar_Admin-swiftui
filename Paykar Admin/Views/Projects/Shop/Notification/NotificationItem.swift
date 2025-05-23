//
//  NotificationItemView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationItem: View {
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var mainManager = MainManager()
    @State var showLinkWeb = false
    @State var delete = false
    @State var title: String = ""
    @State var description: String = ""
    @State var date: String = ""
    @State var link: String = ""
    @State var preview: String = ""
    @Binding var editing: Bool
    @State var elementId: Int
    @Binding var alert: Bool

    var body: some View {
        VStack {
            if delete {
                VStack {
                    if notificationManager.isLoading {
                        ProgressView("")
                    } else if let errorMessage = notificationManager.errorMessage {
                        Text("Ошибка: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if notificationManager.isDeleted {
                        Text("")
                            .onAppear {
                                editing = false
                            }
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    AsyncImage(url: URL(string: "https://paykar.shop\(preview)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                    .frame(height: 200)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(20)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("Accent"))
                        .padding(.horizontal, 10)
                    
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(Color("Accent"))
                        .padding(.horizontal, 10)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(mainManager.formattedDateToString(date))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("Accent"))
                        
                        Spacer()
                        
                        Button {
                            showLinkWeb.toggle()
                        } label: {
                            Text("Подробнее")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color("Primary"))
                        }
                        .sheet(isPresented: $showLinkWeb) {
                            LinkWebView(url: link)
                        }
                        .padding(.trailing, 5)
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
                .background(Color("CardColor"))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("IconColor").opacity(0.1), lineWidth: 1)
                )
                .overlay{
                    if editing {
                        Button {
                            delete = true
                            notificationManager.deleteNotification(byElementId: elementId)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .background(Color("ItemColor"))
                                .cornerRadius(30)
                                .foregroundColor(.red)
                                .font(.system(size: 22))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.trailing, -10)
                        .padding(.top, -10)
                    }
                }
            }
        }
        
    }
}
