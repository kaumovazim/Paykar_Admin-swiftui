//
//  loadingView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 26.03.2025.
//

import SwiftUI
import Lottie

struct SetLottieView: View {
    @State var name: String
    var body: some View {
        VStack(spacing: 20) {
            LottieViewSize(name: name)
                .frame(width: 230, height: 200)
                .offset(x: -6)
            Text("Загрузка...")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .foregroundStyle(Color.gray)
                .offset(y: -75)
        }
        .padding()
        .padding(.bottom, 100)
    }
}
