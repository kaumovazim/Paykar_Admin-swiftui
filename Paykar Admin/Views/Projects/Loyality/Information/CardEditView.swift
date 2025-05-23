//
//  CardProfileEditView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI
import Foundation

struct CardEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var storageData: StorageData = StorageData()
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var secondName: String = ""
    @State var birthDate: String = ""
    @State var date = Date()
    @State var phone: String = ""
    @State var confCode: String = ""
    @State var city: String = ""
    @State var street: String = ""
    @State var house: String = ""
    @State var confPhone: Bool =  false
    @State var confirmPhone: Bool = false
    @State var accumulation: Bool = false
    @State var update: Bool = true
    @State var editor: AdminModel? = nil
    @State var isAccumulation = false
    @State var isActive = false
    @State var isPhoneConf = false
    @State var updateError = false
    @State var alertConnection = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack{
                Text("Редактирование")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Имя")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                    
                    TextField("Введите имя", text: $firstName)
                        .padding(.leading, 5)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Divider()
                
                HStack {
                    Text("Фамилия")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                    
                    TextField("Введите фамилию", text: $lastName)
                        .padding(.leading, 5)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Divider()
                
                HStack {
                    Text("Отчество")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                    
                    TextField("Введите отчество", text: $secondName)
                        .padding(.leading, 5)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Divider()
                
                // Birth Date
                DatePicker("Дата рождения", selection: $date, displayedComponents: .date)
                    .font(.headline)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                Divider()
                
                HStack {
                    Text("Телефон")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .foregroundColor(isPhoneConf ? .green : .red)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                    
                    TextField("Укажите мобильный телефон", text: $phone)
                        .padding(.leading, 5)
                        .padding(.trailing, 20)
                        .foregroundColor(isPhoneConf ? .green : .red)
                        .background(Color.clear)
                        .keyboardType(.phonePad)
                        .onChange(of: phone) { newValue in
                            if !confPhone {
                                confPhone.toggle()
                            }
                        }
                    Spacer()
                    Image(systemName: "\(isPhoneConf ? "checkmark.circle" : "x.circle")")
                        .foregroundColor(isPhoneConf ? .green : .red)
                        .padding()
                }
                
                if !confPhone {
                    if confirmPhone {
                        Divider()
                        Text("Код подтверждения")
                            .font(.headline)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        
                        TextField("Укажите код подтверждения", text: $confCode)
                            .background(Color.clear)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .keyboardType(.numberPad)
                    }
                    
                    Button(!confirmPhone ? "Отправить код подтверждения" : "Подтвердить") {
                        if !confirmPhone {
                            confirmPhone.toggle()
                        } else {
                            confPhone.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 20)
                    .padding(15)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(25)
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .opacity(!update ? 1 : 0)
                }
                Divider()
                
                HStack {
                    Text("Город")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)

                    TextField("Укажите город", text: $city)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Улица")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)

                    TextField("Укажите улицу", text: $street)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Дом")
                        .frame(width: 80, height: 20, alignment: .leading)
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)

                    TextField("Укажите дом", text: $house)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Toggle(isOn: $isAccumulation) {
                    Text("Накопления")
                        .font(.headline)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 20)
                
                Toggle(isOn: $isActive) {
                    Text("Активность")
                        .font(.headline)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                
                
                Button("Обновить данные") {
                    if MainManager().checkInternetConnection() {
                        update.toggle()
                        let id = editor?.id ?? 0
                        InfomationManager().cardInformationUpdate(clientId: storageData.clientId,
                                                                  phoneMobile: phone,
                                                                  lastName: lastName,
                                                                  firstName: firstName,
                                                                  secondName: secondName,
                                                                  birthdate: formatDateToString(date: date),
                                                                  email: storageData.email,
                                                                  city: city,
                                                                  street: street,
                                                                  house: house,
                                                                  acceptSms: isPhoneConf,
                                                                  accumulateOnly: accumulation,
                                                                  editDate: AdminModel.getCurrentTime(), editor: Editor(accessUserId: id ?? 0, firstName: editor?.firstname ?? "", lastName: editor?.lastname ?? "")) { updatedClient in
                            if updatedClient.AcountId != 0 {
                                storageData.acountId = updatedClient.AcountId!
                                storageData.firstName = updatedClient.FirstName!
                                storageData.lastName = updatedClient.LastName!
                                storageData.phoneMobile = updatedClient.PhoneMobile!
                                storageData.secondName = updatedClient.SurName!
                                storageData.birthday = updatedClient.Birthday!
                                storageData.email = updatedClient.Email!
                                storageData.city = updatedClient.City!
                                storageData.street = updatedClient.Street!
                                storageData.house = updatedClient.House ?? ""
                                storageData.isPhoneConfirmed = updatedClient.IsPhoneConfirmed!
                                storageData.accumulateOnly = updatedClient.AccumulateOnly!
                                storageData.blocked = updatedClient.Blocked!
                                dismiss()
                            } else {
                                updateError = true
                            }
                        }
                        if confPhone {
                            confPhone.toggle()
                        }
                    } else {
                        alertConnection = true
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 20)
                .padding(15)
                .foregroundColor(Color("Accent"))
                .background(Color("Secondary"))
                .cornerRadius(15)
                .padding(.bottom, 10)
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            editor =  UserManager.shared.retrieveUserFromStorage()
            firstName = storageData.firstName
            lastName = storageData.lastName
            secondName = storageData.secondName
            birthDate = storageData.birthday
            phone = storageData.phoneMobile
            confPhone = storageData.isPhoneConfirmed
            isPhoneConf = storageData.isPhoneConfirmed
            street = storageData.street
            isActive = storageData.blocked
            isAccumulation = storageData.accumulateOnly
        }
    }

    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter.string(from: date)
    }
}

#Preview {
    CardEditView()
}
