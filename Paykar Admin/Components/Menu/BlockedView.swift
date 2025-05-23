//
//  BlockedView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 19/10/24.
//

import SwiftUI

struct BlockedView: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                LottieViewSize(name: "BlockAnim")
                    .frame(width: 300, height: 230)
                Text("Вы заблокированы!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text("У вас нет доступа к использованию этого приложения!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }.padding()
                .padding(.bottom, 100)
        }
    }
}

struct NoConnectionView: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                LottieViewSize(name: "NoWiFi")
                    .frame(width: 150, height: 150)
                Text("Нет подключения!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text("Подключитесь к интернету и попробуйте снова")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }.padding()
                .padding(.bottom, 20)
        }
    }
}
struct WarningView: View {
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                LottieViewSize(name: "WarningAnim")
                    .frame(width: 150, height: 150)
                Text("Что-то пошло не так")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text("Произошла ошибка. Попробуйте снова через несколько минут")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }.padding()
                .padding(.bottom, 100)
        }
    }
}
