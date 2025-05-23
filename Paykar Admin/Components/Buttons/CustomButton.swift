//
//  CustomButton.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 28/09/24.
//

import SwiftUI

struct CustomButton: View {
    
    @State var icon: String
    
    var body: some View {
        Circle()
            .fill(Color("Accent"))
            .frame(width: 50, height: 50)
            .overlay {
                Image(systemName: icon)
                    .foregroundColor(Color("ButtonText"))
            }
            .shadow(color: Color("Accent"), radius: 2)
    }
}

struct RepeatButton: View {
    @Binding var isPressed: Bool
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.clockwise") // Иконка перезагрузки
                .font(.system(size: 16, weight: .medium))
            Text("Повторить")
                .font(.system(size: 16, weight: .semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(
            Capsule()
                .fill(Color.green)
                .shadow(radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0) // Эффект нажатия
    }
}

#Preview {
    CustomButton(icon: "plus")
}
