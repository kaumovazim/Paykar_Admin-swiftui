//
//  DetailAccessCardVIew.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 19.03.2025.
//

import SwiftUI

struct DetailAccessCardVIew: View {
    @State var id: String?
    @State var name: String
    @State var number: String
    @State var unit: String
    @State var position: String
    @State var status: String
    var body: some View {
        VStack(spacing: 10) {
            
            // Card View
            ZStack {
                VStack {
                    // Ваш контент
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .background(
                    LinearGradient(
                        colors: [Color("LightPrimary"), Color("DarkPrimary")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(25)
                .overlay {
                    AccessCard_card_(cardNumber: number, name: name, unit: unit, codeNumber: maskedCardNumber(number))
                }
                .padding(.top, 20)
            }

            // Custom Input
            UnchangeableInput(tittle: "Номер Карты", hint: "", value: maskedCardNumber(number))
                .padding(.top, 15)
                .padding(.bottom, 10)

            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    HStack {
                        UnchangeableInput(tittle: "Добавил", hint: "", value: name)
                        UnchangeableInput(tittle: "Подразделение", hint: "", value: unit)
                    }
                    HStack {
                        UnchangeableInput(tittle: "Должность", hint: "", value: position)
                        UnchangeableInput(tittle: "Статус", hint: "", value: status == "active" ? "Активно" : "Деактивно")
                    }
                }
                
            }
            .keyboardType(.numberPad)
            
            Spacer(minLength: 0)
            
        }
        .padding()
    }
    func maskedCardNumber(_ number: String) -> String {
        guard number.count >= 6 else { return number } // Если номер слишком короткий, возвращаем как есть
        
        let start = number.prefix(3) // Первые 5 символов
        let end = number.suffix(3)   // Последние 3 символа
        let masked = String(repeating: "*", count: number.count - 8) // Маскированная середина
        
        return "\(start)\(masked)\(end)"
    }

}
