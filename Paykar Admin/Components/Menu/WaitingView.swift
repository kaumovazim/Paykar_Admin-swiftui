//
//  WaitingView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 19/10/24.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack(spacing: 20) {
            SetLottieView(name: "AcceptAnim")
                .scaleEffect(CGSize(width: 0.4, height: 0.4))
                .frame(width: 200, height: 200)
            Text("Запрос принят!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
            Text("Обработка запроса займет 1-2 рабочих дней!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }.padding()
            .padding(.bottom, 100)
    }
}

#Preview {
    WaitingView()
}
