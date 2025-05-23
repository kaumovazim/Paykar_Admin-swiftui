//
//  UserDetailedView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 11/09/24.
//

import SwiftUI

struct ShopUserDetailView: View {
    
    @StateObject private var userManager = ShopUserManager.shared
    @State var user: UserDataModel
    @State private var isDeactivated = false
    @State private var showDeactivationMessage = false
    @State var alertConnection = false
    @State var showOrders = false
    @State var showLinkWeb = false
    @State var deactivationMessage = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text(user.phone)
                        .font(.headline)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text("Зарегистрирован: \(user.dateRegistered)")
                        .font(.headline)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(user.status == "Y" ? .green : .red)
                    Text(user.status == "Y" ? "Активен" : "Неактивен")
                        .font(.headline)
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Button {
                        showLinkWeb.toggle()
                    } label: {
                        Text("Показать на карте")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showLinkWeb) {
                        LinkWebView(url: "\(yandexMapsURL())")
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Информация об устройстве")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical, 10)
                    
                    HStack {
                        Image(systemName: "desktopcomputer")
                        Text("Модель: \(user.devices.deviceModel)")
                            .font(.headline)
                    }
                    HStack {
                        Image(systemName: "cpu")
                        Text("ОС: \(user.devices.typeOS) \(user.devices.versionOS)")
                            .font(.headline)
                    }
                    HStack {
                        Image(systemName: "app.fill")
                        Text("Версия приложения: \(user.devices.versionApp)")
                            .font(.headline)
                    }
                }
                
            }
            Spacer()
            VStack {
                Button(action: {
                    if MainManager().checkInternetConnection() {
                        showOrders = true
                    } else {
                        alertConnection = true
                    }
                }) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("Accent"))
                            .frame(maxWidth: 30, alignment: .center)
                        
                        Text("Последние заказы")
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
                .padding(.top, 20)
                .fullScreenCover(isPresented: $showOrders, content: {
                    OrderView(searchInput: "\(user.phone.dropFirst(3))", autoSearch: true, preselectedIndex: 1)
                })
                Button(action: {
                    if MainManager().checkInternetConnection() {
                        deactivateUser(userId: Int(user.id)!)
                    } else {
                        alertConnection = true
                    }
                }) {
                    HStack {
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("Accent"))
                            .frame(maxWidth: 30, alignment: .center)
                        
                        Text("Деактивировать")
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
                .alert(isPresented: $showDeactivationMessage) {
                    Alert(
                        title: Text("Результат"),
                        message: Text(userManager.statusMessage ?? "Неизвестный результат"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                
            }
        }
        .padding()
        .presentationDetents([.height(CGFloat(600))])
        .alert("", isPresented: $alertConnection) {
            Button("Попробовать снова", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к интернету и попробуйте снова.")
        }
    }
    
    private func yandexMapsURL() -> URL {
        let lat = user.lat
        let lon = user.lon
        let urlString = "https://yandex.com/maps/?pt=\(lon),\(lat)&z=15&l=map"
        return URL(string: urlString)!
    }
    private func deactivateUser(userId: Int) {
        userManager.deactivateUser(userId: userId) { result in
            switch result {
            case .success(let message):
                deactivationMessage  = message
            case .failure(let error):
                deactivationMessage  = "Не удалось деактивировать пользователя: \(error.localizedDescription)"
            }
        }
    }
}
