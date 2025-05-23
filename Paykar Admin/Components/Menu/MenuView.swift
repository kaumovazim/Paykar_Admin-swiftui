//
//  MenuView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 28/08/24.
//

import SwiftUI

struct MenuView: View {
    @State var admin: AdminModel? = nil
    @State var showShop = false
    @State var showWallet = false
    @State var showLogistics = false
    @State var showLoyalty = false
    @State var showProduction = false
    @State var showAcademy = false
    @State var showBusiness = false
    @State var showParking = false
    @State var showService = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    @State var alertConnection = false
    

    var body: some View {
        ZStack {
            VStack(spacing: 15){
                if admin?.projects.shop ?? true {
                    Button {
                        withAnimation {
                            showShop = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Shop", projectDescription: "Продукты и питание", projectImage: "cart")
                    }
                    .fullScreenCover(isPresented: $showShop, content: {
                        ShopView()
                    })
                }
                if admin?.projects.loyalty ?? true  {
                    Button {
                        withAnimation {
                            showLoyalty = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Loyalty", projectDescription: "Система лояльности", projectImage: "person.text.rectangle")
                    }
                    .fullScreenCover(isPresented: $showLoyalty, content: {
                        LoyalityView()
                    })
                }
                if admin?.projects.production ?? true  {
                    Button {
                        withAnimation {
                            showProduction = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Production", projectDescription: "Продвижение продуктов", projectImage: "birthday.cake")
                    }
                    .fullScreenCover(isPresented: $showProduction, content: {
                        ProductionView()
                        //                    MaintraceView(text: "Проект Пайкар Production \n находится на стадии разработки")
                    })
                }
                if admin?.projects.wallet ?? true  {
                    Button {
                        withAnimation {
                            showWallet = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Wallet", projectDescription: "Электронный кошелек", projectImage: "wallet.bifold")
                    }
                    .fullScreenCover(isPresented: $showWallet, content: {
                        MaintraceView(text: "Проект Пайкар Wallet \n находится на стадии разработки")
                    })
                }
                if admin?.projects.academy ?? true  {
                    Button {
                        withAnimation {
                            showAcademy = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Academy", projectDescription: "Обучение персонала", projectImage: "graduationcap")
                    }
                    .fullScreenCover(isPresented: $showAcademy, content: {
                        MaintraceView(text: "Проект Пайкар Academy \n находится на стадии разработки")
                    })
                }
                if admin?.projects.business ?? true {
                    Button {
                        withAnimation {
                            showBusiness = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Business", projectDescription: "Работа с поставщиками", projectImage: "briefcase")
                    }
                    .fullScreenCover(isPresented: $showBusiness, content: {
                        MaintraceView(text: "Проект Пайкар Business \n находится на стадии разработки")
                    })
                }
                if admin?.projects.logistics ?? true {
                    Button {
                        withAnimation {
                            showLogistics = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Logistics", projectDescription: "Управление рейсами", projectImage: "truck.box")
                    }
                    .fullScreenCover(isPresented: $showLogistics, content: {
                        MaintraceView(text: "Проект Пайкар Logistics \n находится на стадии разработки")
                    })
                }
                if admin?.projects.parking ?? true {
                    Button {
                        withAnimation {
                            showParking = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Parking", projectDescription: "Управление парковкой", projectImage: "car")
                    }
                    .fullScreenCover(isPresented: $showParking, content: {
                        MaintraceView(text: "Проект Пайкар Parking \n находится на стадии разработки")
                    })
                }
                if admin?.projects.service ?? true {
                    Button {
                        withAnimation {
                            showService = true
                        }
                    } label: {
                        ProjectButton(projectTitle: "Пайкар Service", projectDescription: "Сервисное обслуживание", projectImage: "wrench.and.screwdriver")
                    }
                    .fullScreenCover(isPresented: $showService, content: {
                        MaintraceView(text: "Проект Пайкар Service \n находится на стадии разработки")
                    })
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .alert("", isPresented: $alertConnection) {
            Button("Try Again", role: .cancel, action: {
                exit(0)
            })
        } message: {
            Text("Check your internet connection and try again.")
        }
        .onAppear() {
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
#Preview {
    HomeView()
}


