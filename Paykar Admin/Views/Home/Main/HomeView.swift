//
//  HomeView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var showSetting = false
    @State var admin: AdminModel? = nil
    @State var alertConnection = false
    @State var activateTab: AppTab = .news
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            if activateTab != .profile {
                Rectangle()
                    .fill(Color("IconColor").opacity(0.17))
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .cornerRadius(15)
                    .ignoresSafeArea()
                    .padding(.bottom, 0)
                    .overlay {
                        HStack {
                            Image(colorScheme == .dark ? "icon_green_white" : "icon_green")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 25)
                                .padding(.top, 33)
                            Text(convertTitle(title: activateTab))
                                .font(.system(size: 27, weight: .bold))
                                .kerning(0.5)
                                .foregroundColor(colorScheme == .dark ? .white : .accentColor)
                                .padding(.leading, 3)
                                .padding(.top, 35)
                            Spacer()
                        }
                    }
            }
            
            MainTapBar(activateTab: $activateTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .alert("Что то пошло не так!", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: {
                exit(0)
            })
        } message: {
            Text("Проверьте подключение к Интернету и повторите попытку.")
        }
        .onAppear() {
            if let Admin = UserManager.shared.retrieveUserFromStorage() {
                admin = Admin
            }
        }
    }
    private func convertTitle(title: AppTab) -> String {
        switch title {
        case .news:
            return "Лента"
        case .project:
            return "Проекты"
        case .services:
            return "Сервисы"
        case .profile:
            return "Профиль"
        }
    }
}
/*

 */
