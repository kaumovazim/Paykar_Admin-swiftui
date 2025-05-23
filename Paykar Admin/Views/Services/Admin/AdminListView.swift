//
//  AdminListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 11/10/24.
//

import SwiftUI

struct AdminListView: View {
    @StateObject private var adminManager = AdminManager()
    @State private var selectedAdmin: AdminListModel?
    @State var showDetails = false
    @State var showRequested = false
    @Environment(\.dismiss) var dismiss
    @State var alertConnection = false
    @State var preselectedIndex: Int = 0
    @State var options: [String] = ["Активные", "Заблокированые"]
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Text("Пользователи")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        showRequested = true
                    } label: {
                        Image(systemName: "person.crop.rectangle.stack")
                            .foregroundStyle(adminManager.requestedAdmins.isEmpty ? Color("Accent").opacity(0.4) : Color("Primary"))
                            .font(.title2)
                    }
                    .sheet(isPresented: $showRequested, content: {
                        AdminRequestedView()
                    })
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.top, 50)
                HStack(spacing: 0){
                    ForEach(options.indices, id:\.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color("Secondary"))
                            
                            Rectangle()
                                .fill(Color("CardColor"))
                                .cornerRadius(15)
                                .padding(2)
                                .opacity(preselectedIndex == index ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        preselectedIndex = index
                                    }
                                }
                        }
                        .overlay(
                            Text(options[index])
                        )
                    }
                }
                .cornerRadius(15)
                .frame(height: 50)
                .padding()
                if adminManager.isLoading {
                    Spacer()
                    ProgressView("")
                        .padding(.bottom, 50)
                    Spacer()
                } else {
                    ScrollView {
                        VStack{
                            if preselectedIndex == 0 {
                                ForEach(adminManager.admins) { admin in
                                    if admin.position != "Супер Админ" && admin.status == "active" {
                                        Button {
                                            if MainManager().checkInternetConnection() {
                                                selectedAdmin = admin
                                            } else {
                                                alertConnection = true
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color("CardColor"))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                                HStack{
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        HStack {
                                                            Text(admin.firstname + " " + admin.lastname)
                                                                .foregroundColor(Color("Accent"))
                                                                .font(.headline)
                                                                .fontWeight(.bold)
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Image(systemName: "phone.fill")
                                                                .foregroundColor(.gray)
                                                            Text(admin.phone)
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }
                                                        
                                                        HStack {
                                                            Image(systemName: "briefcase.fill")
                                                                .foregroundColor(.gray)
                                                            Text(admin.position)
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }
                                                    }
                                                    Spacer()
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(Color.gray)
                                                }.padding()
                                            }
                                            .padding(.horizontal)
                                        }.sheet(item: $selectedAdmin, content: { admin in
                                            AdminDetailView(admin: admin)
                                                .onDisappear() {
                                                    if MainManager().checkInternetConnection() {
                                                        adminManager.getAdminList()
                                                    } else {
                                                        alertConnection = true
                                                    }
                                                }
                                        })
                                    }
                                }
                            } else if preselectedIndex == 1 {
                                ForEach(adminManager.admins) { admin in
                                    if admin.position != "Супер Админ" && admin.status == "blocked" {
                                        Button {
                                            if MainManager().checkInternetConnection() {
                                                selectedAdmin = admin
                                            } else {
                                                alertConnection = true
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color("CardColor"))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                                HStack{
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        HStack {
                                                            Text(admin.firstname + " " + admin.lastname)
                                                                .foregroundColor(Color("Accent"))
                                                                .font(.headline)
                                                                .fontWeight(.bold)
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Image(systemName: "phone.fill")
                                                                .foregroundColor(.gray)
                                                            Text(admin.phone)
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }
                                                        
                                                        HStack {
                                                            Image(systemName: "briefcase.fill")
                                                                .foregroundColor(.gray)
                                                            Text(admin.position)
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }
                                                    }
                                                    Spacer()
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(Color.gray)
                                                }.padding()
                                            }
                                            .padding(.horizontal)
                                        }.sheet(item: $selectedAdmin, content: { admin in
                                            AdminDetailView(admin: admin)
                                                .onDisappear() {
                                                    if MainManager().checkInternetConnection() {
                                                        adminManager.getAdminList()
                                                    } else {
                                                        alertConnection = true
                                                    }
                                                }
                                            
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .alert("Что то пошло не так!", isPresented: $alertConnection) {
                Button("Попробовать еще", role: .cancel, action: {
                    dismiss()
                })
            } message: {
                Text("Проверьте подключение к Интернету и повторите попытку.")
            }
            .onAppear() {
                if MainManager().checkInternetConnection() {
                    adminManager.getAdminList()
                    adminManager.getAdminRequestedList()
                } else {
                    alertConnection = true
                }
            }
            HStack {
                Button {
                    if MainManager().checkInternetConnection() {
                        adminManager.getAdminList()
                        adminManager.getAdminRequestedList()
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(40)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(40)
            }
            
        }.ignoresSafeArea()
    }
}

#Preview {
    AdminListView()
}
