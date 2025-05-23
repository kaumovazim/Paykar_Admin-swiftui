//
//  ProfileItemView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/08/24.
//

import SwiftUI


struct ShopItemView: View {
    
    var icon: String
    var text: String
    @State var sheet = false

    var body: some View {
        Button {
            sheet.toggle()
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("Accent"))
                    .frame(maxWidth: 30, alignment: .center)
                
                Text(text)
                    .padding(.horizontal, 15)
                    .foregroundColor(Color("Accent"))
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("Accent"))
                    .font(.system(size: 20, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 35)
            .padding(10)
            .padding(.horizontal, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
            }
        }
        .fullScreenCover(isPresented: $sheet, content: {
            if text == "Клиенты"{
               ShopUserView()
            } else if text == "Заказы"{
                OrderView()
            } else if text == "Уведомления"{
                NotificationView()
            } else if text == "Истории"{
                StoriesView()
            }
        })

    }
}
