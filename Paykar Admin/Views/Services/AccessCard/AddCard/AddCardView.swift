//
//  AddCardView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 18.03.2025.
//

import SwiftUI

struct AddCardView: View {
    @State var cardNumber: String = ""
    @State var addCard = CreateCard()
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ListAccessCard()
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Text("Добавать карту")
                        .font(.title)
                        .fontWeight(.semibold)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(30)
                Spacer()
            }.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Номер карты")
                    .font(.headline)
                TextField("Введите номер карты", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                Button {
                    addCard.createCard(numberCard: cardNumber) { response in
                        if response.status == "success" {
                            dismiss()
                            viewModel.getCardList()
                        }
                    }
                } label: {
                    Text("AddCard")
                }
            }
            
            
            
        }
    }
}
