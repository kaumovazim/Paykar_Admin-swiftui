//
//  SensMessageView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 22/10/24.
//

import SwiftUI

struct SendMessageView: View {
    
    @State var phone = ""
    @State var sms = ""
    @State var phoneAlert = false
    @State var progress = false
    @State var alertConnection = false
    @State var alertSuccess = false
    @State var alertError = false
    @FocusState var focus
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Отправка СМС")
                .font(.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 30)
            VStack{
                VStack(spacing: 15){
                    VStack {
                        HStack(spacing: 2){
                            Text("+992")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(height: 55)
                                .padding(.trailing, 10)
                                .foregroundColor(Color("Accent").opacity(0.4))
                            
                            TextField("", text: $phone)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(height: 55)
                                .foregroundColor(Color("Accent"))
                                .lineSpacing(14)
                                .focused($focus)
                                .keyboardType(.phonePad)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .alert(isPresented: $alertError) {
                            Alert(title: Text("Что то пошло нет так!"),
                                  message: Text("Побробуйте снова через некоторое время"),
                                  dismissButton: .default(Text("Попробовать еще"))
                            )
                        }
                        
                        Divider()
                            .padding(.top, -10)
                    }
                    .padding(.horizontal)
                    Text("Текстовое сообщение")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    TextEditor(text: $sms)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .cornerRadius(15)
                        .padding(5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                        }
                        .padding(.horizontal)
                    ZStack{
                        Button {
                            if phone.count == 9 {
                                progress = true
                                let admin = UserManager.shared.retrieveUserFromStorage()
                                if MainManager().checkInternetConnection() {
                                    MessageManager().sendSms(phone: "992\(phone)", sms: sms, userId: admin!.id) { response in
                                        if (response.status == "success") {
                                            progress = false
                                            alertSuccess = true
                                        } else {
                                            progress = false
                                            alertError = true
                                        }
                                    }
                                } else {
                                    alertConnection = true
                                    progress = false
                                }
                            } else {
                                phoneAlert = true
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("Secondary"))
                                HStack{
                                    Text("Отправить")
                                        .font(.headline)
                                        .foregroundColor(Color("Accent"))
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.headline)
                                        .foregroundColor(Color("Accent"))
                                        .padding()
                                }.padding(.horizontal)
                            }.frame(height: 50)
                        }
                        .alert(isPresented: $phoneAlert) {
                            Alert(title: Text("Что то пошло нет так!"),
                                  message: Text("Вы ввели некоректный номер телефона"),
                                  dismissButton: .default(Text("Попробовать еще"))
                            )
                        }
                        .padding()
                        .opacity(progress ? 0 : 1)
                        ProgressView("")
                            .opacity(progress ? 1 : 0)
                    }
                }
            }
            .alert(isPresented: $alertSuccess) {
                Alert(title: Text("СМС отправлен!"),
                      message: Text("Текстовое сообщение успешно было отправлено."),
                      dismissButton: .default(Text("Ок"), action: {
                    dismiss()
                })
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .presentationDetents([.height(CGFloat(360))])
        .alert("Что то пошло не так!", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к Интернету и повторите попытку.")
        }
        .onAppear() {
            focus = true
        }
    }
    
}

#Preview {
    SendMessageView()
}
