//
//  ListCheckList.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 28.03.2025.
//

import SwiftUI

struct ListCheckList: View {
    var admin: AdminModel?
    let adminData = UserManager.shared.retrieveUserFromStorage()
    @State var showCheckList = false
    @StateObject var check = CheckDate()
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if adminData?.position == "Охрана" || adminData?.position == "Кассир" || adminData?.position == "Супер Админ" {
                        Button {
                            check.fetchCheckStatus { success in
                                if let status = check.check?.status, status == true {
                                    showAlert = true
                                    alertTitle = "Опрос уже пройден"
                                    alertMessage = "\(check.check?.message ?? " "), повторите его завтра"
                                } else {
                                    showCheckList = true
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("CardColor"))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Text("Check list 1")
                                                .foregroundColor(Color("Accent"))
                                                .font(.headline)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        HStack {
                                            Text("Позиция: \(adminData?.position == "Супер Админ" ? "Охрана" : String(describing: adminData?.position ?? " "))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.gray)
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("Ок")))
                        }
                        .fullScreenCover(isPresented: $showCheckList, content: {
                            MainCheckList()
                        })

                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(Text("Опрос"))
        }

    }
}
