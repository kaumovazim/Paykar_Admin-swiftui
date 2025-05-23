//
//  ShopView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/08/24.
//

import SwiftUI

struct ShopView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var showClients: Bool = false
    @State var showOrders: Bool = false
    @State var showNotifications: Bool = false
    @State var showStories: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 110)
                        .cornerRadius(15)
                        .ignoresSafeArea()
                        .overlay {
                            HStack{
                                Image("icon_green_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text("Shop")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                        }
                }
                .ignoresSafeArea()
                Spacer()
                HStack{
                    VStack{
                        Button {
                            showClients = true
                        } label: {
                            ShopItemView(text: "Клиенты", icon: "person.2")
                        }
                        .fullScreenCover(isPresented: $showClients, content: {
                            ShopUserView()
                        })
                        Button {
                            showNotifications = true
                        } label: {
                            ShopItemView(text: "Уведомления", icon: "bell")
                        }
                        .fullScreenCover(isPresented: $showNotifications, content: {
                            NotificationView()
                        })
                    }
                    VStack{
                        Button {
                            showOrders = true
                        } label: {
                            ShopItemView(text: "Заказы", icon: "list.bullet.rectangle.portrait")
                        }
                        .fullScreenCover(isPresented: $showOrders, content: {
                            OrderView()
                        })
                        Button {
                            showStories = true
                        } label: {
                            ShopItemView(text: "Истории", icon: "clock.arrow.circlepath")
                        }
                        .fullScreenCover(isPresented: $showStories, content: {
                            StoriesView()
                        })
                    }
                }
                .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .center)
                Spacer(minLength: 100)
            }
            VStack{
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .padding(50)
            }.ignoresSafeArea()
                .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .bottom)
        }.ignoresSafeArea()
    }
}

#Preview {
    ShopView()
}
struct ShopItemView: View {
    
    var text: String
    var icon: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("CardColor"))
                .shadow(color: Color("Primary"), radius: 2)
                .frame(width: 150, height: 150)
            VStack(spacing: 15){
                Circle().fill(Color("Primary")).opacity(0.1)
                    .frame(width: 60, height: 60)
                    .overlay{
                        Image(systemName: icon)
                            .font(.system(size: 28))
                            .foregroundColor(Color("Primary"))
                    }
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(Color("Accent"))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .padding(10)
    }
}
