import SwiftUI

struct ServiceMenuView: View {
    
    @State var admin: AdminModel? = nil
    @State var showAccessCard = false
    @State var showDataAnalytics = false
    @State var showAdmins = false
    @State var showSms = false
    @State var showCorrection = false
    @State var showFavoriteCards = false
    @State var showReport = false
    @State var showReports = false
    @State var showCheckList = false
    var body: some View {
        ZStack{
            if admin?.position == "Управляющий" {
                VStack{
                    HStack(spacing: 15){
                        Button {
                            showReport = true
                        } label: {
                            ServiceMenuItemView(title: "Отчеты", icon: "list.clipboard")
                        }
                        .fullScreenCover(isPresented: $showReport, content: {
                            MakeReportView()
                        })
                        Button {
                            showAccessCard = true
                        } label: {
                            ServiceMenuItemView(title: "Карта доступа", icon: "lock.shield")
                        }
                        .fullScreenCover(isPresented: $showAccessCard, content: {
                            AccessCardView()
                        })
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
            if admin?.position == "Кассир" {
                VStack {
                    HStack(spacing: 15){
                        Button {
                            showAccessCard = true
                        } label: {
                            ServiceMenuItemView(title: "Карта доступа", icon: "lock.shield")
                        }
                        .fullScreenCover(isPresented: $showAccessCard, content: {
                            AccessCardView()
                        })
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
            if admin?.position == "Супер Админ" {
                VStack(spacing: 5){
                    HStack(spacing: 26){
                        Button {
                            showAccessCard = true
                        } label: {
                            ServiceMenuItemView(title: "Карта доступа", icon: "lock.shield")
                        }
                        .fullScreenCover(isPresented: $showAccessCard, content: {
                            AccessCardView()
                        })
                        Button {
                            showDataAnalytics = true
                        } label: {
                            ServiceMenuItemView(title: "Аналитика", icon: "chart.bar.xaxis")
                        }.fullScreenCover(isPresented: $showDataAnalytics, content: {
                            DataAnalyticsView()
                        })
                    }
                    HStack(spacing: 26){
                        Button {
                            showAdmins = true
                        } label: {
                            ServiceMenuItemView(title: "Пользователи", icon: "person.2")
                        }
                        .fullScreenCover(isPresented: $showAdmins, content: {
                            AdminListView()
                        })
                        Button {
                            showSms = true
                        } label: {
                            ServiceMenuItemView(title: "Центр СМС", icon: "message")
                        }.sheet(isPresented: $showSms, content: {
                            SendMessageView()
                        })
                    }
                    HStack(spacing: 26){
                        Button {
                            showCorrection = true
                        } label: {
                            ServiceMenuItemView(title: "Корректировка", icon: "checkmark.rectangle.stack")
                        }.sheet(isPresented: $showCorrection, content: {
                            CorrectionRequestView()
                        })
                        Button {
                            showFavoriteCards = true
                        } label: {
                            ServiceMenuItemView(title: "Избранные карты", icon: "star")
                        }.sheet(isPresented: $showFavoriteCards, content: {
                            FavoriteCardsListView()
                        })
                    }
                    HStack(spacing: 26){
                        Button {
                            showReports = true
                        } label: {
                            ServiceMenuItemView(title: "Отчеты", icon: "list.clipboard")
                        }
                        .sheet(isPresented: $showReports, content: {
                            ReportsListView()
                        })
                        Button {
                            showCheckList = true
                        } label: {
                            ServiceMenuItemView(title: "Опрос", icon: "checklist.checked")
                        }
                        .sheet(isPresented: $showCheckList) {
                            ListCheckList()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
            if admin?.position == "Охрана" {
                VStack{
                    HStack(spacing: 15){
                        Button {
                            showCheckList = true
                        } label: {
                            ServiceMenuItemView(title: "Опрос", icon: "checklist.checked")
                        }
                        .sheet(isPresented: $showCheckList) {
                            ListCheckList()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
        }.onAppear() {
            if let adminData = UserManager.shared.retrieveUserFromStorage() {
                admin = adminData
            }
        }
        
    }
}

import UIKit

struct ServiceMenuItemView: View {
    var title: String
    var icon: String
    
    // Вычисляем масштаб на основе ширины экрана
    private var scaleFactor: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        // Базовая ширина экрана (например, iPhone 14: 390 pt)
        let baseWidth: CGFloat = 390
        // Увеличиваем размеры на больших экранах (Pro Max ~ 430 pt)
        return min(screenWidth / baseWidth, 1.3) // Ограничиваем максимальный масштаб
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color("CardColor"))
                .shadow(color: Color("Primary"), radius: 2)
                .frame(width: 150 * scaleFactor, height: 120 * scaleFactor)
            VStack(spacing: 15 * scaleFactor) {
                Circle()
                    .fill(Color("Primary")).opacity(0.1)
                    .frame(width: 45 * scaleFactor, height: 45 * scaleFactor)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 24 * scaleFactor))
                            .foregroundColor(Color("Primary"))
                    }
                Text(title)
                    .font(.system(size: 14 * scaleFactor, weight: .medium))
                    .foregroundColor(Color("Accent"))
                    .multilineTextAlignment(.center)
            }
            .padding(10 * scaleFactor)
        }
        .padding(.vertical, 10 * scaleFactor)
    }
}

struct ServiceMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceMenuItemView(title: "Sample Title", icon: "star.fill")
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
