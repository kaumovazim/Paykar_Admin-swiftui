//
//  Authorization.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct AuthorizationView: View {
    @State var alertConnection = false
    @State var progress = false
    @State var phone: String = ""
    @State var serverResponseCode: String = ""
    @State var needsVerification = false
    @State var needsRegistration = false
    @State var next = false
    @State var isVerified = false
    @State var errorMessage: String? = nil
    @State var showingAlertMistake: Bool = false
    @State var showingAlertEmpty: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment: .leading){
                Text("Авторизация")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Accent"))
                    .padding(.horizontal, 30)
                    .padding(.top, 100)
                Text("Укажите Ваш мобильный телефон")
                    .foregroundStyle(Color("Accent"))
                    .font(.system(size: 20))
                    .padding(.horizontal, 30)
                    .padding(.top, 1)
                
                PhoneTextFieldView(text: phone, color: Color("Accent"))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .onChange(of: phone) { newValue in
                        if (newValue.count == 9) {
                            isFocused = false
                        }
                    }

                Button(action: {
                    checkUser(phone: phone)
                }) {
                    ZStack{
                        ProgressView()
                            .opacity(progress ? 1 : 0)
                        ButtonLeftIconView(text: "ПРОДОЛЖИТЬ", icon: "chevron.right")
                            .padding(.horizontal, 30)
                            .opacity(progress ? 0 : 1)
                    }
                }
                .fullScreenCover(isPresented: $needsVerification, content: {
                    VerificationView(phone: phone)
                })
                .fullScreenCover(isPresented: $needsRegistration, content: {
                    RegistrationView(phone: phone)
                })
                .disabled(phone.isEmpty)
            }.ignoresSafeArea()
                .padding(.bottom)
                .alert(isPresented: $showingAlertMistake) {
                    Alert(title: Text(""),
                          message: Text("Вы ввели некоректный номер телефона"),
                          dismissButton: .default(Text("Попробовать еще"))
                    )
                }
            
            KeyboardView(value: $phone)
        }
        .ignoresSafeArea()
        .alert("", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: { })
        } message: {
            Text("Проверьте подключение к Интернету и попробуйте снова")
        }
    }
    private func checkUser(phone: String) {
        progress = true
        if MainManager().checkInternetConnection() {
            if phone != ""{
                if phone.count != 9{
                    showingAlertMistake.toggle()
                    progress = false
                } else {
                        LoginManager.shared.checkUserRegistration(phone: phone) { status in
                            if status == "success" {
                                self.errorMessage = nil
                                self.needsVerification = true
                                progress = false
                            } else if status == "error" {
                                self.errorMessage = "needsRegistration"
                                self.needsRegistration = true
                                progress = false
                            }
                        }
                }
            } else {
                showingAlertEmpty.toggle()
                progress = false
            }
        } else {
            alertConnection.toggle()
            progress = false
        }
    }
}

#Preview {
    AuthorizationView()
}
