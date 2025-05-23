//
//  DataAnalyticsView.swift
//  Paykar Admin
//
//  Created by Азим Каюмов on 2/14/25.
//

import SwiftUI
import WebKit

struct DataAnalyticsView: View {
    @Environment(\.dismiss) var dismiss
    @State var showId = false
    @State var showAcademy: Bool = false
    @State var showLogistic: Bool = false
    @State var showAdmin: Bool = false
    @State var show: Bool = false
    @State var showTopList = false
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(colors: [Color("LightPrimary"), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 110)
                        .cornerRadius(15)
                        .ignoresSafeArea()
                        .overlay {
                            HStack{
                                Image("icon_green_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text("Аналитика")
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
                VStack{
                    HStack{
                        Button {
                            showId = true
                        } label: {
                            ShopItemView(text: "Paykar", icon: "person.badge.key.fill")
                        }.fullScreenCover(isPresented: $showId, content: {
                            WebViewContainer(url: "https://datalens.yandex/ha9dm89qcham3")
                        })

                        Button {
                            showLogistic = true
                        } label: {
                            ShopItemView(text: "Logistic", icon: "truck.box.fill")
                        }.fullScreenCover(isPresented: $showLogistic, content: {
                            WebViewContainer(url: "https://datalens.yandex/wqn77bkfepisi")
                        })
                    }
                    HStack{
                        Button {
                            showAcademy = true
                        } label: {
                            ShopItemView(text: "Academy", icon: "checklist.checked")
                        }.fullScreenCover(isPresented: $showAcademy, content: {
                            WebViewContainer(url: "https://datalens.yandex/rjj8tbhzmjlmd")
                        })
                        
                        Button {
                            showAdmin = true
                        } label: {
                            ShopItemView(text: "Admin", icon: "list.bullet.rectangle.portrait.fill")
                        }.fullScreenCover(isPresented: $showAdmin, content: {
                            WebViewContainer(url: "https://datalens.yandex/ykftd99qicbil")
                        })
                    }
                    HStack {
                        Button {
                            show = true
                        } label: {
                            ShopItemView(text: "Посещения", icon: "list.bullet")
                        }.fullScreenCover(isPresented: $show, content: {
                            PeriodSelectionView()
                        })
                        Button {
                            showTopList = true
                        } label: {
                            ShopItemView(text: "Топ лист", icon: "trophy")
                        }
                        .fullScreenCover(isPresented: $showTopList) {
                            TopListPeriodView()
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity,  maxHeight: .infinity).offset(y: -50)
                Spacer()
            }
            Spacer()
            VStack{
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .padding(50)
            }.ignoresSafeArea()
                .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .bottom)
        }
    }
       
}
