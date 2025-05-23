//
//  ProductionView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 28/10/24.
//

import SwiftUI

struct ProductionView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var folderId = 0
    @State var title = ""
    @State var showProductList = false
    @State var showDiscountList = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            VStack {
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 110)
                        .cornerRadius(15)
                        .ignoresSafeArea()
                        .overlay {
                            HStack(spacing: 10){
                                Image("icon_green_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text("Production")
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
                .padding(.bottom, 50)
                HStack {
                    VStack{
                        Button {
                            folderId = 801
                            title = "Кондитерские изделия"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Кондитерские \n изделия", icon: "confectioner")
                        }
                        Button {
                            folderId = 809
                            title = "Пекарня"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Пекарня", icon: "bakery")
                        }
                        Button {
                            folderId = 812
                            title = "Бистро"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Бистро", icon: "pizza")
                        }
                    }
                    VStack{
                        Button {
                            folderId = 804
                            title = "Национальная выпечка"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Национальная \n выпечка", icon: "roller")
                        }
                        Button {
                            folderId = 1329
                            title = "Салаты"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Салаты", icon: "salad")
                        }
                        Button {
                            folderId = 1485
                            title = "Готовые блюда"
                            showProductList = true
                        } label: {
                            ProductionItemView(text: "Готовые блюда", icon: "breakfast")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showProductList) {
                    ProductionListView(folderId: $folderId, title: $title)
                }
                Spacer()
            }
            HStack{
                Button {
                    showDiscountList = true
                } label: {
                    CustomButton(icon: "list.bullet")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                .fullScreenCover(isPresented: $showDiscountList) {
                    ProductDiscountListView()
                }
                Button {
                   dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProductionView()
}

struct ProductionItemView: View {
    var text: String
    var icon: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("CardColor"))
                .shadow(color: Color("Primary"), radius: 2)
                .frame(width: 150, height: 150)
            VStack(spacing: 15){
                Image(icon)
                    .resizable()
                    .frame(width: 50, height: 50)
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

