//
//  UserListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/08/24.
//

import SwiftUI

struct ShopUserView: View {
    
    @StateObject private var userManager = ShopUserManager.shared
    @State var sort = false
    @State var sortVisible = false
    @State var searching = false
    @State var showUserDetails = false
    @State var phoneAlert = false
    @State private var phoneNumber: String = ""
    @FocusState var focus
    @Environment(\.dismiss) var dismiss
    @State var alertConnection = false
    
    var body: some View {
        ZStack{
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color("Secondary"))
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .bottom)
                        
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            ButtonCircleView(iconName: "chevron.left", background: "")
                                .padding(.leading)
                        }
                        Text("Клиенты")
                            .font(.system(size: 22, weight: .semibold))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                    .padding(.bottom)

                }
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    HStack{
                        TextField("Поиск по телефону", text: $phoneNumber)
                            .padding()
                            .keyboardType(.phonePad)
                            .focused($focus)
                            .onChange(of: phoneNumber) { newValue in
                                if (newValue.count == 9) {
                                    focus = false
                                    performSearch()
                                }
                            }
                        
                        if focus {
                            Button {
                                withAnimation {
                                    phoneNumber = ""
                                    focus = false
                                    userManager.searchedUsers = []
                                    userManager.errorMessage = nil
                                    searching = false
                                }
                            } label: {
                                Image(systemName: "multiply")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("Accent"))
                                    .padding(5)
                                    .background(Color("ItemColor"))
                                    .cornerRadius(30)
                            }
                        }
                        Button(action: {
                            performSearch()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                                .font(.system(size: 18))
                                .foregroundColor(Color("Accent"))
                        }
                        .disabled(phoneNumber.isEmpty)
                        .alert(isPresented: $phoneAlert, content: {
                            Alert(title: Text("Внимание!"),
                                  message: Text("Вы ввели неверный номер телефона"),
                                  dismissButton: .cancel(Text("Попробовать снова"))
                            )
                        })
                    }
                    .background(Color("Secondary"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if userManager.isLoading && !searching {
                        Spacer()
                        ProgressView("Загрузка...")
                            .padding(.bottom, 100)
                        Spacer()
                    } else if phoneNumber.count == 9 && userManager.errorMessage != nil {
                        Spacer()
                        LottieView(name: "EmptyListAnim")
                            .scaleEffect(CGSize(width: 0.4, height: 0.4))
                            .frame(width: 200, height: 200)
                            .padding(.bottom, 100)
                        Spacer()
                    } else if searching && userManager.searchedUsers.isEmpty &&  phoneNumber.count == 9 {
                        Spacer()
                        ProgressView("Поиск...")
                            .padding(.bottom, 100)
                        Spacer()
                    } else if !phoneNumber.isEmpty && !userManager.searchedUsers.isEmpty {
                        VStack{
                            ForEach(userManager.searchedUsers) { user in
                                Button {
                                    showUserDetails.toggle()
                                } label: {
                                    MobileUserItem(user: user)
                                        .padding(.horizontal)
                                }.sheet(isPresented: $showUserDetails, content: {
                                    ShopUserDetailView(user: user)
                                })
                            }
                            .listStyle(PlainListStyle())
                            Rectangle()
                                .fill(Color("ButtonText"))
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        phoneNumber = ""
                                        focus = false
                                        userManager.searchedUsers = []
                                        userManager.errorMessage = nil
                                        searching = false
                                    }
                                }
                        }
                    } else if !focus && !userManager.newUsers.isEmpty {
                        VStack(){
                            HStack {
                                Text("Клиенты за последнюю неделю:")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color("Accent"))
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            ScrollView {
                                ForEach(userManager.newUsers) { user in
                                    SiteUserItem(user: user)
                                        .onAppear() {
                                            sortVisible = true
                                        }
                                }.padding()
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else if focus {
                        Rectangle()
                            .fill(Color("ButtonText"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    phoneNumber = ""
                                    focus = false
                                    userManager.searchedUsers = []
                                    userManager.errorMessage = nil
                                    searching = false
                                }
                            }
                    } else if userManager.errorMessage != nil {
                        Spacer()
                        Text("")
                            .onAppear(perform: {
                                alertConnection = true
                            })
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                if MainManager().checkInternetConnection() {
                    userManager.getNewUsers()
                } else {
                    alertConnection = true
                }
            }
            .alert("", isPresented: $alertConnection) {
                Button("Попробовать снова", role: .cancel, action: {
                    dismiss()
                })
            } message: {
                Text("Проверьте подключение к интернету и попробуйте снова.")
            }
            HStack{
                if !focus && !searching {
                    Button {
                        if MainManager().checkInternetConnection() {
                            userManager.getNewUsers()
                        } else {
                            alertConnection = true
                        }
                    } label: {
                        CustomButton(icon: "arrow.triangle.2.circlepath")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                    Button {
                        sort.toggle()
                    } label: {
                        CustomButton(icon: "arrow.up.and.down.text.horizontal")
                    }.sheet(isPresented: $sort, content: {
                        VStack(spacing: 15) {
                            Button(action: {
                                if MainManager().checkInternetConnection() {
                                    sort.toggle()
                                    userManager.resetToOriginalOrder()
                                } else {
                                    alertConnection = true
                                }
                            }) {
                                Text("По умолчанию")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Secondary"))
                                    .foregroundColor(Color("Accent"))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                            }
                            Button(action: {
                                if MainManager().checkInternetConnection() {
                                    sort.toggle()
                                    sortUsersByNameAscending()
                                } else {
                                    alertConnection = true
                                }
                            }) {
                                Text("Сортировать по имени А-Я")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Secondary"))
                                    .foregroundColor(Color("Accent"))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                            }
                            Button(action: {
                                if MainManager().checkInternetConnection() {
                                    sort.toggle()
                                    sortUsersByNameDescending()
                                } else {
                                    alertConnection = true
                                }
                            }) {
                                Text("Сортировать по имени Я-А")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Secondary"))
                                    .foregroundColor(Color("Accent"))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                            }
                        }
                        .presentationDetents([.height(CGFloat(225))])
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(30)
                }
            }
        }.ignoresSafeArea()
    }
    func performSearch() {
        if MainManager().checkInternetConnection() {
            if phoneNumber.count != 9 {
                phoneAlert.toggle()
            } else if !phoneNumber.isEmpty && !userManager.searchedUsers.isEmpty {
                userManager.searchedUsers = []
                userManager.findUserByPhone(byPhone: phoneNumber)
                searching = true
            } else {
                userManager.findUserByPhone(byPhone: phoneNumber)
                searching = true
            }
        } else {
            alertConnection = true
        }
    }
    func sortUsersByNameAscending() {
        userManager.newUsers.sort { (user1, user2) -> Bool in
            if let name1 = user1.name, let name2 = user2.name {
                let isName1Cyrillic = isCyrillic(name1)
                let isName2Cyrillic = isCyrillic(name2)
                
                if isName1Cyrillic && !isName2Cyrillic {
                    return true
                } else if !isName1Cyrillic && isName2Cyrillic {
                    return false
                } else {
                    return name1 < name2
                }
            } else if user1.name == nil || user1.name!.isEmpty {
                return false
            } else if user2.name == nil || user2.name!.isEmpty {
                return true
            }
            return false
        }
    }
    
    func sortUsersByNameDescending() {
        userManager.newUsers.sort { (user1, user2) -> Bool in
            if let name1 = user1.name, let name2 = user2.name {
                let isName1Cyrillic = isCyrillic(name1)
                let isName2Cyrillic = isCyrillic(name2)
                
                if isName1Cyrillic && !isName2Cyrillic {
                    return true
                } else if !isName1Cyrillic && isName2Cyrillic {
                    return false
                } else {
                    return name1 > name2
                }
            } else if user1.name == nil || user1.name!.isEmpty {
                return false
            } else if user2.name == nil || user2.name!.isEmpty {
                return true
            }
            return false
        }
    }
    
    func isCyrillic(_ string: String) -> Bool {
        guard let firstCharacter = string.first else { return false }
        return ("А"..."Я").contains(firstCharacter) || ("а"..."я").contains(firstCharacter)
    }
}


#Preview {
    ShopUserView()
}
