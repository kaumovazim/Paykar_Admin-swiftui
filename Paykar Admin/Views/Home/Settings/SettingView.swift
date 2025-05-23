//
//  ControlPanelView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 10/10/24.
//

import SwiftUI
import LocalAuthentication

struct SettingView: View {
    @State var admin: AdminModel? = nil
    @Environment(\.dismiss) var dismiss
    @State var isAuthenticated = false
    @State var authErrorMessage: String?
    @State var authErrorAlert: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var logOut = false
    @State var logOutAlert = false
    @State var showAllAdmins = false
    @State var editData = false
    @State var sendSms = false
    @State var alertConnection = false
    
    var body: some View {
        VStack() {
            HStack{
                VStack{
                    Text("\(admin?.firstname ?? "") \(admin?.lastname ?? "")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Accent"))
                        .padding(.horizontal, 30)
                        .padding(.top, 33)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(admin?.position ?? "") • \(admin?.unit ?? "")")
                        .foregroundColor(Color("Accent"))
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                }
                Image("loyalty-icon")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(30)
                    .padding(.top, 33)
                    .frame(alignment: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: 120)
            .padding(.top, 20)
            .background(Color("CardColor"))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
            
            ScrollView {
                VStack(spacing: 20){
                    Button {
                        editData = true
                    } label: {
                        SettingsItemView(icon: "square.and.pencil", text: "Изменить данные", color: Color("Primary"))
                    }.sheet(isPresented: $editData, content: {
                        EditAdminView()
                            .onDisappear() {
                                if MainManager().checkInternetConnection() {
                                    getAdmin()
                                } else {
                                    alertConnection = true
                                }
                            }
                    })
                    Button {
                        if MainManager().checkInternetConnection() {
                            logOutAlert.toggle()
                        } else {
                            alertConnection = true
                        }
                    } label: {
                        SettingsItemView(icon: "rectangle.portrait.and.arrow.right", text: "Выйти", color: .red)
                    }
                    .alert(isPresented: $logOutAlert, content: {
                        Alert(title: Text("Вы уверены что хотите выйти из аккаунта?"), primaryButton: .destructive(Text("Отмена")), secondaryButton: .default(Text("Да"), action: {
                            UserManager.shared.logOutUser()
                            logOut = true
                        }))
                    })
                    .fullScreenCover(isPresented: $logOut, content: {
                        ContentView()
                    })
                    Spacer()
                }.padding()
                    .padding(.top)
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
        .onAppear {
            if MainManager().checkInternetConnection() {
                getAdmin()
            } else {
                alertConnection = true
            }
        }
    }
    
    func getAdmin() {
        if let adminData = UserManager.shared.retrieveUserFromStorage() {
            admin = adminData
        }
    }
    
}
struct SettingsItemView: View {
    var icon: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .padding(.horizontal, 5)
            Text(text)
                .padding(.horizontal, 15)
                .foregroundColor(Color("Accent"))
                .font(.system(size: 22))
                .font(.headline)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(color)
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
}
