//
//  EditAdminView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import SwiftUI

struct EditAdminView: View {
    @State var admin: AdminModel? = nil
    @State var unitSheet: Bool = false
    @State var positionSheet: Bool = false
    @State var updatedSuccess: Bool = false
    @State var updatedSuccessMessage: String = ""
    @State var updatedError: Bool = false
    @State var alertConnection: Bool = false
    @State var logOut: Bool = false
    @State var logOutAlert: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phone: String = ""
    @State var position: String = ""
    @State var unit: String = ""
    @State var status: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    Text("Изменить данные профиля")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color("Accent"))
                        .multilineTextAlignment(.leading)
                        .alert("", isPresented: $alertConnection) {
                            Button("Попробовать еще", role: .cancel, action: { })
                        } message: {
                            Text("Проверьте подключение к Интернету и попробуйте снова")
                        }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 2){
                    TextFieldView(title: .constant("Имя"), text: $firstName)
                    TextFieldView(title: .constant("Фамилия"), text: $lastName)
                    
                    Text("Номера телефона")
                        .font(.title3)
                        .foregroundColor(Color("IconColor"))
                        .padding(.top)
                    
                    VStack {
                        HStack{
                            Text("+992 " + (admin?.phone ?? ""))
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(height: 55)
                                .padding(.trailing, 10)
                                .foregroundColor(Color("IconColor"))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        Divider()
                            .padding(.top, -10)
                    }
                    
                    Button {
                        positionSheet = true
                    } label: {
                        HStack {
                            Text(position)
                                .font(.system(size: 16))
                                .foregroundStyle(Color("Primary"))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                        }
                    }
                    .disabled(admin?.phone == "000000000" ? false : true)
                    .alert("", isPresented: $updatedSuccess) {
                        Button("Ок", role: .cancel, action: { if updatedSuccessMessage == "Пользователь удален успешно!" {
                            logOut = true
                        } else {
                            dismiss()
                        }})
                    } message: {
                        Text(updatedSuccessMessage)
                    }
                    .sheet(isPresented: $positionSheet){
                        CustomList(update: {},list: ["Управляющий", "Администратор", "Менеджер", "Формировщик", "Доставщик", "Оператор"], title: $position, close: $positionSheet)
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
                        .overlay {
                            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2).fill(Color("Primary"))
                        }
                    }
                    .alert("", isPresented: $updatedError) {
                        Button("Побробовать еще", role: .cancel, action: {})
                    } message: {
                        Text("Что то пошло не так!")
                    }
                    .sheet(isPresented: $unitSheet){
                        CustomList(update: {}, list: ["Пайкар 1", "Пайкар 2", "Пайкар 3", "Пайкар 4", "Пайкар 5", "Пайкар 6", "Пайкар 7", "Пайкар 8"], title: $unit, close: $unitSheet)
                    }
                }
                VStack(spacing: 10) {
                    Button(action: {
                        saveChanges()
                        updatedSuccessMessage = "Пользователь обновлен успешно!"
                    }) {
                        Text("Обновить данные")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Secondary"))
                            .foregroundColor(Color("Accent"))
                            .cornerRadius(15)
                    }
                    .fullScreenCover(isPresented: $logOut, content: {
                        ContentView()
                    })
                    if admin?.phone == "000000000" {
                        Button(action: {
                            logOutAlert = true
                        }) {
                            Text("Удалить аккаунт")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Secondary"))
                                .foregroundColor(.red)
                                .cornerRadius(15)
                        }
                        .alert(isPresented: $logOutAlert, content: {
                            Alert(title: Text("Вы уверены что хотите удалить ваш аккаунт?"), primaryButton: .destructive(Text("Отмена")), secondaryButton: .default(Text("Да"), action: {
                                deactivateUser()
                            }))
                        })
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .onAppear(perform: {
                getAdmin()
            })
        }.scrollIndicators(.hidden)
            .presentationDetents([.height(CGFloat(600))])
        
    }
    
    func getAdmin() {
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            admin = adminData
            firstName = adminData.firstname
            lastName = adminData.lastname
            phone = adminData.phone
            position = adminData.position
            unit = adminData.unit
            status = adminData.status
        }
    }
    
    func saveChanges() {
        if let admin = admin {
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
                                          status: status,
                                          confirmed: admin.confirmed) { response in
                    if (response.first?.status) != nil {
                        updatedSuccess = true
                        UserManager.shared.updateUserInStorage(updatedUser: AdminModel(id: admin.id, create_date: admin.create_date, firstname: firstName, lastname: lastName, phone: phone, position: position, unit: unit, level: admin.level, ftoken: admin.ftoken, imei: admin.imei, ip_address: admin.ip_address, last_visit: admin.last_visit, longitude: admin.longitude, latitude: admin.latitude, edit_date: admin.edit_date, status: admin.status, confirmed: admin.confirmed, projects: admin.projects))
                    } else {
                        updatedError = true
                    }
                }
            } else {
                alertConnection = true
            }
        }
    }
    func deactivateUser() {
        status = "deactivated"
        let confirmed = false
        if let admin = admin {
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
                                          status: status,
                                          confirmed: confirmed) { response in
                    if (response.first?.status) != nil {
                        updatedSuccess = true
                        updatedSuccessMessage = "Пользователь удален успешно!"
                        UserManager.shared.logOutUser()
                    } else {
                        updatedError = true
                    }
                }
            } else {
                alertConnection = true
            }
        }
    }
}

struct UserDataEditView_Previews: PreviewProvider {
    static var previews: some View {
        EditAdminView()
    }
}
