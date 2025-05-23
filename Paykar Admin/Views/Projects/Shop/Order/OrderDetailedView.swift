//
//  OrderDetailedView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 03/09/24.
//

import SwiftUI

struct OrderDetailView: View {
    
    @State var cardInfo: [InfomationModel] = []
    @State var isPresented: Bool = false
    var order: OrderModel
    @StateObject var infomationManager = InfomationManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(order.userFirstName ?? "") \(order.userLastName ?? "")")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(order.userPhone ?? "N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    HStack {
                        if let card = cardInfo.first, card.AcountId != 0 {
                            Button(action: {
                                self.isPresented = true
                            }){
                                Image(systemName: "person.text.rectangle")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 30, height: 20)
                                    .padding(.horizontal)
                                    .background(Circle().fill(Color(.green).opacity(0.4)).frame(width: 85, height: 50))
                            }
                        }
                    }.onAppear {

                        infomationManager.getCardInfomationByPhone(completion: { card in
                            cardInfo = card
                           
                        }, phone: extractSubstring(from: order.userPhone ?? ""))
                    }
                }
                Divider()
                HStack {
                    Text("Номер заказа:")
                        .font(.headline)
                    Spacer()
                    Text("\(order.id)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Дата создания:")
                        .font(.headline)
                    Spacer()
                    Text(order.createDate)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Цена:")
                        .font(.headline)
                    Spacer()
                    Text("\(order.price) TJS")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                HStack {
                    Text("Статус:")
                        .font(.headline)
                    Spacer()
                    Text(orderStatusText(order.statusId))
                        .font(.headline)
                        .foregroundColor(order.statusId == "F" ? .blue : .orange)
                }
                Text("Адрес доставки:")
                    .font(.headline)
                Text(order.deliveryAddress ?? "Не указан адрес")
                    .font(.body)
                    .foregroundColor(.primary)
                if let comments = order.comments, !comments.isEmpty {
                    Text("Комментарии:")
                        .font(.headline)
                    Text(comments)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                Text("Товары в заказе:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                ForEach(order.productOrder) { product in
                    HStack {
                        if let url = URL(string: "https://paykar.shop" + product.productPicture) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 140, height: 140)
                            .cornerRadius(20)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text(product.productName)
                                .font(.system(size: 15))
                                .padding(.top, 10)
                                .frame(maxHeight: .infinity, alignment: .leading)
                                .foregroundColor(Color("Accent"))
                                .multilineTextAlignment(.leading)
                            HStack(alignment: .top){
                                Text("\(product.productQuantity) \(String(describing: product.productUnit)) ☓")
                                    .foregroundColor(Color("IconColor"))
                                    .font(.system(size: 15))
                                Text("\(roundToTwoDecimals(product.productPrice)) TJS")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color("Accent"))
                            }.frame(maxHeight: .infinity, alignment: .topLeading)
                            
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("CardColor"))
                    .cornerRadius(20)
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("IconColor").opacity(0.1), lineWidth: 1)
                    }
                }
                
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .overlay(
            CustomCardAlertView(isPresented: $isPresented, card: cardInfo.first)
        )
    }
    private func roundToTwoDecimals(_ priceString: String) -> String {
        if let price = Double(priceString) {
            return String(format: "%.2f", price)
        } else {
            return "0.00"
        }
    }
    
    private func orderStatusText(_ statusID: String) -> String {
        switch statusID {
        case "N":
            return "Новый"
        case "F":
            return "Завершен"
        default:
            return "Неизвестный"
        }
    }
    func extractSubstring(from text: String) -> String {
           let characters = Array(text)
           
           guard characters.count > 9 else { return "Недостаточно символов" }
           
           let subArray = characters[4...12]
           return String(subArray)
       }
}



