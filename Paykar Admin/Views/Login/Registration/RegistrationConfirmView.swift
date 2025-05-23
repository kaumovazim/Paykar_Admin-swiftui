//
//  RegistrationConfirmView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import SwiftUI

struct RegistrationConfirmView: View {
    @State var progress = false
    @State var alertConnection = false
    @State var confirmCodeDisable = false
    @State private var enteredCode: String = ""
    @State private var errorMessage: String?
    @State var showingAlertError: Bool = false
    @State var isPresent: Bool = false
    @State var isRequested: Bool = false
    @State var showingAlertMistake: Bool = false
    @State private var isVerified = false
    @State var isApple: Bool = false
    @State var serverCode: String = ""
    @StateObject var textFieldModel: LimitVerificationCode = .init()
    @Environment(\.dismiss) var dismiss
    
    let firstName: String
    let lastName: String
    let phone: String
    let position: String
    let unit: String

    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 15){
                Button {
                    dismiss()
                } label: {
                    ButtonCircleView(iconName: "chevron.left", background: "IconColor")
                        .padding(.top, UIScreen.main.bounds.height > 700 ? 50 : 30)
                        .padding(.bottom, 10)
                }
                .alert("", isPresented: $alertConnection) {
                    Button("Попробовать еще", role: .cancel, action: { })
                } message: {
                    Text("Проверьте подключение к Интернету и попробуйте снова")
                }
                Text("Подтверждения")
                    .font(.title)
                    .foregroundStyle(Color("Accent"))
                    .fontWeight(.semibold)
                Text("Укажите код подтверждения, отправленный на +992\(phone)")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("Accent"))
                    .frame(height: 60)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 14){
                    ForEach(0..<5, id: \.self){ index in
                        let currentIndexText = getCurrentIndex(index: index)
                        CodePositionView(text: currentIndexText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, -10)
                .onChange(of: textFieldModel.text) { newValue in
                    enteredCode = newValue
                }

                Button(action: {
                    VerificationManager.shared.sendCode(phone: phone) { status, error in
                    }
                }, label: {
                    Text("Отправить код заново")
                        .font(.title3)
                        .foregroundColor(Color("IconColor"))
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(confirmCodeDisable)
                .padding(.top, 10)
                Button {
                    if phone == "000000000" {
                        if enteredCode == "12345" {
                            VerificationManager.shared.verifyCode(phone: phone, code: enteredCode) { status, error, user in
                                if let admin = user {
                                    if MainManager().checkInternetConnection() {
                                        AdminManager().updateUser(firstName: firstName,
                                                                  lastName: lastName,
                                                                  phone: phone,
                                                                  position: position,
                                                                  unit: unit,
                                                                  shop: admin.projects.shop,
                                                                  wallet: admin.projects.wallet,
                                                                  logistics: admin.projects.logistics,
                                                                  loyalty: admin.projects.loyalty,
                                                                  service: admin.projects.service,
                                                                  academy: admin.projects.academy,
                                                                  business: admin.projects.business,
                                                                  parking: admin.projects.parking,
                                                                  cashOperations: admin.projects.cashOperations,
                                                                  production: admin.projects.production,
                                                                  status: "active",
                                                                  confirmed: admin.confirmed) { response in
                                            if (response.first?.status) != nil {
                                                UserManager.shared.updateUserInStorage(updatedUser: AdminModel(id: admin.id, create_date: admin.create_date, firstname: firstName, lastname: lastName, phone: phone, position: position, unit: unit, level: admin.level, device_model: admin.device_model, type_os: admin.type_os, version_os: admin.version_os, ftoken: admin.ftoken, imei: admin.imei, ip_address: admin.ip_address, last_visit: admin.last_visit, longitude: admin.longitude, latitude: admin.latitude, edit_date: admin.edit_date, status: admin.status, confirmed: admin.confirmed, projects: admin.projects))
                                                UserManager.shared.saveUserToStorage(admin)
                                                isPresent = true
                                                isApple = true
                                                progress = false
                                            }
                                        }
                                    } else {
                                        alertConnection = true
                                    }
                                } else {
                                    isRequested = true
                                    showingAlertMistake = true
                                    progress = false
                                }
                                
                            }
                        }
                    } else {
                        progress = true
                        VerificationManager.shared.verifyCode(phone: phone, code: enteredCode) { status, error, user in
                            if status == "success" {
                                register(firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit)
                            } else {
                                isRequested = true
                                showingAlertMistake = true
                                progress = false
                            }
                        }
                    }
                } label: {
                    ZStack{
                        ProgressView()
                            .opacity(progress ? 1 : 0)
                        ButtonLeftIconView(text: "ПРОДОЛЖИТЬ", icon: "chevron.right")
                            .padding(.bottom, 20)
                            .opacity(progress ? 0 : 1)
                    }
                    
                }
            }
            .padding(.horizontal, 30)
            KeyboardView(value: $textFieldModel.text)
        }
        .alert(isPresented: $isRequested) {
            if showingAlertMistake {
                Alert(title: Text(""),
                      message: Text("Вы указали неверный код потверждения!"),
                      dismissButton: .default(Text("Попробовать еще"))
                )
            } else {
                Alert(title: Text("Запрос принят!"),
                      message: Text("Обработка запроса займет 1-2 рабочих дней!"),
                      dismissButton: .default(Text("Ok"), action: { isPresent = true })
                )
            }
        }
        .fullScreenCover(isPresented: $isPresent, content: {
            if isApple {
                HomeView()
            } else {
                ContentView()
            }
        })
        .onAppear() {
            VerificationManager.shared.sendCode(phone: phone) { status, error in
            }
        }
    }
    func getCurrentIndex(index: Int) -> String{
        if textFieldModel.text.count > index{
            let start = textFieldModel.text.startIndex
            let current = textFieldModel.text.index(start, offsetBy: index)
            return String(textFieldModel.text[current])
        }
        return ""
    }
    func register(firstName: String, lastName: String, phone: String, position: String, unit: String) {
        RegistrationManager().registerUser(firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit) { response in
            if response.user != nil {
                progress = false
                UserManager.shared.saveUserToStorage(response.user!)
                isRequested = true
            } else {
            }
        }
    }
}
