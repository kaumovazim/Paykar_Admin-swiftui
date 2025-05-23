//
//  RegistrationView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

enum ActiveAlert {
    case name, sname, phone, position, unit
}

struct RegistrationView: View {
    @State var phone: String
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var position: String = "Должность"
    @State private var unit: String = "Подразделение"
    @State private var errorMessage: String?
    @State private var receivedSmsCode: String? = nil
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var alertButtonText = ""
    @State private var isRegistered = false
    @State var showingAlertName: Bool = false
    @State var showingAlertSurname: Bool = false
    @State var showingAlertPosition: Bool = false
    @State var showingAlertUnit: Bool = false
    @State var showingAlertPhone: Bool = false
    @State var activeAlert: ActiveAlert = .name
    @State var showingAlert: Bool = false
    @State var progress = false
    @State var unitSheet = false
    @State var positionSheet = false
    @State var alertConnection = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack(alignment: .top){
                VStack(alignment: .leading, spacing: 10){
                    Button(action: {
                        dismiss()
                        switch activeAlert {
                        case .name:
                            alertTitle = "Предуприждение"
                            alertMessage = "Вы не указали Ваше имя"
                            alertButtonText = "Указать Имя"
                        case .sname:
                            alertTitle = "Предуприждение"
                            alertMessage = "Вы не указали Вашу фамилию"
                            alertButtonText = "Указать Фамилию"
                        case .phone:
                           alertTitle = "Предуприждение"
                            alertMessage = "Вы не указали Ваш номер телефона"
                            alertButtonText = "Указать Номер"
                        case .position:
                            alertTitle = "Предуприждение"
                            alertMessage = "Вы не выбрали Вашу должность"
                            alertButtonText = "Выбрать Должность"
                        case .unit:
                            alertTitle = "Предуприждение"
                            alertMessage = "Вы не выбрали Вашу подразделение"
                            alertButtonText = "Выбрать Подразделение"
                        }
                    }){
                        ButtonCircleView(iconName: "chevron.left", background: "IconColor")
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                    }
                    .alert(isPresented: $showingAlert, content: {
                        Alert(title: Text(alertTitle),
                              message: Text(alertMessage),
                              dismissButton: .cancel(Text(alertButtonText)))
                    })
                    
                    Text("Регистрация")
                        .font(.title)
                        .foregroundStyle(Color("Accent"))
                        .fontWeight(.semibold)
                        .padding(5)
                    Text("Укажите Ваши данные для создание аккаунта")
                        .font(.system(size: 20))
                        .foregroundStyle(Color("Accent"))
                        .frame(height: 60)
                        .alert("", isPresented: $alertConnection) {
                            Button("Попробовать еще", role: .cancel, action: { })
                        } message: {
                            Text("Проверьте подключение к Интернету и попробуйте снова")
                        }
                    VStack(alignment: .leading, spacing: 2){
                        
                        TextFieldView(title: .constant("Имя"), text: $firstName)
                        TextFieldView(title: .constant("Фамилия"), text: $lastName)
                        Text("Номера телефона")
                            .font(.title3)
                            .foregroundColor(Color("IconColor"))
                            .padding(.top)
                        VStack {
                            HStack(spacing: 2){
                                Text("+992")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(height: 55)
                                    .padding(.trailing, 10)
                                    .foregroundColor(Color("IconColor"))
                                
                                TextField("", text: $phone)
                                    .font(.system(size: 20))
                                    .keyboardType(.default)
                                    .foregroundStyle(Color("Accent"))
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .padding(.top, -10)
                        }
                        Button {
                            positionSheet = true
                        } label: {
                            HStack{
                                Text(position)
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("Primary"))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName:  "chevron.down")
                                    .resizable()
                                    .foregroundStyle(Color("Primary"))
                                    .frame(width: 15, height: 10)
                            }
                            .padding(15)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                            }
                            
                        }
                        .sheet(isPresented: $positionSheet){
                            CustomList(update: {},list: ["Супер Админ", "Управляющий", "Администратор", "Менеджер", "Формировщик", "Доставщик", "Оператор", "Охрана", "Продавец", "Кассир"], title: $position, close: $positionSheet)
                        }.padding(.vertical)
                        
                        Button {
                            unitSheet = true
                        } label: {
                            HStack{
                                Text(unit)
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color("Primary"))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName:  "chevron.down")
                                    .resizable()
                                    .foregroundStyle(Color("Primary"))
                                    .frame(width: 15, height: 10)
                            }
                            .padding(15)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                            }
                            
                        }
                        .sheet(isPresented: $unitSheet){
                            CustomList(update: {},list: ["Пайкар 1", "Пайкар 2", "Пайкар 3", "Пайкар 4", "Пайкар 5", "Пайкар 6", "Пайкар 7", "Пайкар 8"], title: $unit, close: $unitSheet)
                        }
                        
                    }
                    Spacer()
                    Button {
                        register(phone: phone)
                    } label: {
                        ZStack{
                            ProgressView()
                                .opacity(progress ? 1 : 0)
                            ButtonLeftIconView(text: "ДАЛЕЕ", icon: "chevron.right")
                                .padding(.vertical, 20)
                                .opacity(progress ? 0 : 1)
                        }
                    }
                    .fullScreenCover(isPresented: $isRegistered, content: {
                        RegistrationConfirmView(firstName: firstName, lastName: lastName, phone: phone, position: position, unit: unit)
                    })
                }
                .padding(.horizontal)
            }
        }
    }
    func register(phone: String) {
        if firstName.isEmpty{
            activeAlert =  .name
            showingAlert.toggle()
        } else if lastName.isEmpty {
            activeAlert =  .sname
            showingAlert.toggle()
        } else if position == "Должность" {
            activeAlert =  .position
            showingAlert.toggle()
        } else if unit == "Подразделение" {
            activeAlert =  .unit
            showingAlert.toggle()
        } else if phone.count == 9 {
            progress = true
            if MainManager().checkInternetConnection(){
                progress = false
                isRegistered = true
            } else {
                alertConnection.toggle()
                progress = false
            }
        } else{
            activeAlert = .phone
            showingAlert.toggle()
            progress = false
        }
    }
}

#Preview {
    RegistrationView(phone: "")
}
