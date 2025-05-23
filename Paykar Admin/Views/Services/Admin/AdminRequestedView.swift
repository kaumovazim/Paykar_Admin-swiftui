//
//  AdminRequestedView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 17/10/24.
//

import SwiftUI

struct AdminRequestedView: View {
    @StateObject var mainManager = MainManager()
    @StateObject private var adminManager = AdminManager()
    @State private var selectedAdmin: AdminListModel?
    @State var showDetails = false
    @Environment(\.dismiss) var dismiss
    @State var alertConnection = false
    @State var successAlert = false
    @State var successMessage = ""
    @State var errorAlert = false
    @State var createDate = ""
    var list: some View {
        ScrollView {
            VStack{
                ForEach(adminManager.requestedAdmins) { admin in
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("CardColor"))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Фио:")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(admin.firstname + " " + admin.lastname)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                HStack {
                                    Text("Номер телефона:")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(admin.phone)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Должность:")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(admin.position)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Подразделение:")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(admin.unit)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Text("Дата создания:")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(createDate)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                .onAppear(perform: {
                                    createDate = mainManager.formattedDateToString(admin.createDate ?? "")
                                })
                                HStack{
                                    Button {
                                        selectedAdmin = admin
                                        selectedAdmin?.confirmed = true
                                        successMessage = "Регистрация пользователя успешно одобрена!"
                                        saveProjectAccessChanges()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color("CardColor"))
                                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                            Text("Одобрить")
                                                .font(.headline)
                                                .foregroundColor(.green)
                                                .padding(10)
                                        }
                                    }
                                    .alert(isPresented: $successAlert, content: {
                                        Alert(title: Text(""), message: Text(successMessage), dismissButton: .default(Text("Ок"), action: {
                                            if MainManager().checkInternetConnection() {
                                                adminManager.getAdminRequestedList()
                                            } else {
                                                alertConnection = true
                                            }
                                        }))
                                    })
                                    Button {
                                        selectedAdmin = admin
                                        selectedAdmin?.confirmed = true
                                        selectedAdmin?.status = "blocked"
                                        successMessage = "Регистрация пользователя отклонена!"
                                        saveProjectAccessChanges()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color("CardColor"))
                                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                            
                                            Text("Отклонить")
                                                .font(.headline)
                                                .foregroundColor(.red)
                                                .padding(10)
                                        }
                                    }
                                    .alert(isPresented: $errorAlert, content: {
                                        Alert(title: Text("Что то пошло не так!"), message: Text(""), dismissButton: .default(Text("Побробовать еще"), action: {
                                            if MainManager().checkInternetConnection() {
                                                adminManager.getAdminRequestedList()
                                            } else {
                                                alertConnection = true
                                            }
                                        }))
                                    })
                                }.padding(.top)
                            }.padding()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .padding(.top, 20)
        }
    }
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Text("Пользователи \n на подтверждение")
                        .font(.title)
                        .fontWeight(.semibold)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(30)
                if adminManager.isLoading {
                    Spacer()
                    ProgressView("")
                        .padding(.bottom, 100)
                    Spacer()
                } else if adminManager.requestedAdmins.isEmpty || adminManager.errorMessage != nil {
                    Spacer()
                    LottieView(name: "EmptyListAnim")
                        .scaleEffect(CGSize(width: 0.4, height: 0.4))
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    list
                }
            }
            .ignoresSafeArea()
            .alert("Что то пошло не так!", isPresented: $alertConnection) {
                Button("Попробовать еще", role: .cancel, action: {
                    dismiss()
                })
            } message: {
                Text("Проверьте подключение к Интернету и повторите попытку.")
            }
            .ignoresSafeArea()
            .onAppear() {
                if MainManager().checkInternetConnection() {
                    adminManager.getAdminRequestedList()
                } else {
                    alertConnection = true
                }
            }
            HStack {
                Button {
                    if MainManager().checkInternetConnection() {
                        adminManager.getAdminRequestedList()
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                
                
                Button {
                    dismiss()                } label: {
                        CustomButton(icon: "multiply")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(40)
                
            }
            .ignoresSafeArea()
        }.ignoresSafeArea()
    }
    func saveProjectAccessChanges() {
        if MainManager().checkInternetConnection() {
            AdminManager().updateUser(firstName: selectedAdmin!.firstname,
                                      lastName: selectedAdmin!.lastname,
                                      phone: selectedAdmin!.phone,
                                      position: selectedAdmin!.position,
                                      unit: selectedAdmin!.unit,
                                      shop: selectedAdmin!.projects.shop,
                                      wallet: selectedAdmin!.projects.wallet,
                                      logistics: selectedAdmin!.projects.logistics,
                                      loyalty: selectedAdmin!.projects.loyalty,
                                      service: selectedAdmin!.projects.service,
                                      academy: selectedAdmin!.projects.academy,
                                      business: selectedAdmin!.projects.business,
                                      parking: selectedAdmin!.projects.parking,
                                      cashOperations: selectedAdmin!.projects.cashOperations,
                                      production: selectedAdmin!.projects.production,
                                      status: selectedAdmin!.status,
                                      confirmed: selectedAdmin!.confirmed) { response in
                if (response[0].status != nil) {
                    if MainManager().checkInternetConnection() {
                        successAlert = true
                    } else {
                        alertConnection = true
                    }
                } else {
                    errorAlert = true
                }
            }
        } else {
            alertConnection = true
        }
    }
    
}

#Preview {
    AdminRequestedView()
}
