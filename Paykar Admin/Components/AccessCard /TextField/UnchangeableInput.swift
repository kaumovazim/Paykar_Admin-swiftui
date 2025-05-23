//
//  AccessCardTextField.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 19.03.2025.
//

import SwiftUI


struct UnchangeableInput: View {
    var tittle: String
    var hint: String
    var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(tittle)
                .font(.caption2)
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxWidth: .infinity, maxHeight: 50) // Занимает максимум доступного пространства
                    .foregroundColor(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(value.isEmpty ? .green : .gray.opacity(0.5), lineWidth: 1.5)
                    )
                
                Text(value) // Текст внутри RoundedRectangle
                    .frame(alignment: .leading)
                    .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)


        }
    }
}
