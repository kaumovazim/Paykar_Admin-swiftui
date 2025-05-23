//
//  VerificationView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct VerificationView: View {
    @State var progress = false
    @State var alertConnection = false
    @State var confirmCodeDisable = false
    @State private var enteredCode: String = ""
    @State private var errorMessage: String?
    @State var isPresent: Bool = false
    @State var isApple: Bool = false
    @State var isRequested: Bool = false
    @State var showingAlertMistake: Bool = false
    @State private var isVerified = false
    @State var serverCode: String = ""
    @StateObject var textFieldModel: LimitVerificationCode = .init()
    @Environment(\.dismiss) var dismiss
    
    let phone: String
    
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
                    VerificationManager.shared.sendCode(phone: phone) { status, error in }
                }, label: {
                    Text("Отправить код заново")
                        .font(.title3)
                        .foregroundColor(Color("IconColor"))
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(confirmCodeDisable)
                .padding(.top, 10)
                Button {
                    progress = true
                    if phone == "000000000" {
                        if enteredCode == "12345" {
                            VerificationManager.shared.verifyCode(phone: phone, code: enteredCode) { status, error, user in
                                if let user = user {
                                    isPresent = true
                                    isApple = true
                                    UserManager.shared.saveUserToStorage(user)
                                    progress = false
                                }
                            }
                        } else {
                            isRequested = true
                            showingAlertMistake = true
                            progress = false
                        }
                    } else {
                        VerificationManager.shared.verifyCode(phone: phone, code: enteredCode) { status, error, user in
                            if let user = user {
                                progress = false
                                isVerified = true
                                UserManager.shared.saveUserToStorage(user)
                                errorMessage = nil
                                isRequested = true
                            } else {
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
                      message: Text("Вы успешно авторизировались!"),
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
    
}
