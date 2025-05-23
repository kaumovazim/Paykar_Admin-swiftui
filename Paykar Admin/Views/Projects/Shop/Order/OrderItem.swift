//
//  OrderRow.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 28/09/24.
//

import SwiftUI

struct OrderItem: View {
    
    let order: OrderModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack (spacing: 10){
                Text("Заказ №\(order.id)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                Text(orderStatusText(order.statusId))
                    .font(.system(size: 16))
                    .foregroundColor(order.statusId == "F" ? .green : .orange)
            }
            HStack {
                Text("Дата:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(order.createDate)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Цена:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(order.price) TJS")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            HStack {
                Text("Мобильный:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(order.userPhone ?? "N/A")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(15)
        .shadow(color: Color("Accent"), radius: 1)
        
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
}
