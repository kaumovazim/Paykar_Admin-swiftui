//
//  LoyalityCardView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI
import Foundation

struct LoyalityView: View {
    @StateObject var infomationManager = InfomationManager()
    @StateObject var correctionManager = CorrectionManager()
    @FocusState private var isFocused: Bool
    @State var admin: AdminModel? = nil
    @State var searchInput: String = ""
    @State var scannedCode: String? = ""
    @State var progress: Bool = false
    @State var showRequests: Bool = false
    @State var showInfo: Bool = false
    @State var cardNotFound: Bool = false
    @State var startScan: Bool = false
    @State var confirmScan: Bool = false
    @State var scanCard: Bool = false
    @State var scanCertificate: Bool = false
    @ObservedObject var storageData: StorageData = StorageData()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    @State var preselectedIndex: Int = 0
    @State var options: [String] = ["Номер карты", "Номер телефона"]
    @State var alertConnection = false
    
    var body: some View {
        ZStack{
            VStack {
                ZStack{
                    Rectangle()
                        .fill(LinearGradient(colors: [Color("LightPrimary").opacity(colorScheme == .light ? 0.7 : 1), Color("DarkPrimary")], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 110)
                        .cornerRadius(15)
                        .ignoresSafeArea()
                        .overlay {
                            HStack(spacing: 10){
                                Image("icon_green_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text("Loyalty")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                Spacer()
                                Button {
                                    if MainManager().checkInternetConnection() {
                                        confirmScan = true
                                    } else {
                                        alertConnection.toggle()
                                    }
                                } label: {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                .fullScreenCover(isPresented: $startScan, content: {
                                    if scanCertificate {
                                        CertificateInfoView()
                                    } else {
                                        BarcodeScannerView(scannedCode: $scannedCode, title: "Поиск карты \n по штрих коду")
                                            .onDisappear(){
                                                if scannedCode != "" {
                                                    performSearch()
                                                }
                                            }
                                    }
                                })
                                .actionSheet(isPresented: $confirmScan) {
                                    ActionSheet(title: Text("Сканирование!"),
                                                buttons: [
                                                    .default(Text("Найти карту"), action: {
                                                        startScan = true
                                                        scanCard = true
                                                    }),
                                                    .default(Text("Проверить сертификат"), action: {
                                                        startScan = true
                                                        scanCertificate = true
                                                    }),
                                                    .cancel(Text("Отменить"))
                                                ]
                                    )
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 40)
                            .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                        }
                }
                .ignoresSafeArea()
                Spacer()
                VStack(spacing: 20){
                    Text("Найти карту")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Для поиска введите \n номер карты или номер телефона")
                        .foregroundStyle(Color("Accent")).opacity(0.6)
                        .multilineTextAlignment(.center)
                    ZStack{
                        VStack(spacing: 15) {
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
                                                    searchInput = ""
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
                            HStack {
                                Text(searchInput.isEmpty ? "" : searchInput)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color("Secondary"))
                                    .cornerRadius(15)
                                    .onChange(of: searchInput) { newValue in
                                        if preselectedIndex == 0 {
                                            if (newValue.count == 6) {
                                                if MainManager().checkInternetConnection() {
                                                    performSearch()
                                                } else {
                                                    alertConnection.toggle()
                                                }
                                            }
                                        } else if preselectedIndex == 1 {
                                            if (newValue.count == 9) {
                                                if MainManager().checkInternetConnection() {
                                                    performSearch()
                                                } else {
                                                    alertConnection.toggle()
                                                }
                                            }
                                        }
                                    }
                                    .alert(isPresented: $cardNotFound) {
                                        Alert(title: Text("Карта не найдена!"),
                                              message: Text("Наверное вы указали неверный номер карты или номер телефона"),
                                              dismissButton: .default(Text("Попробовать еще"))
                                        )
                                    }
                                    .fullScreenCover(isPresented: $showInfo, content: {
                                        CardInfoView()
                                            .onDisappear(perform: {
                                                searchInput = ""
                                                scannedCode = ""
                                            })
                                    })
                            }
                        }
                    }
                }
                .padding()
                KeyboardView(value: $searchInput, guest: true)
            }
            .ignoresSafeArea()
            .opacity(progress ? 0 : 1)
            VStack {
                Spacer()
                ProgressView("")
                    .opacity(progress ? 1 : 0)
                Spacer()
            }
            ZStack{
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .bottom)
                .padding(30)
            }
        }
        .alert("Что то пошло не так!", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к Интернету и повторите попытку.")
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            if let admindata = UserManager.shared.retrieveUserFromStorage(){
                admin = admindata
            }
            correctionManager.getCorrectionRequestsList()
        })
    }
    func performSearch() {
        withAnimation {
            progress = true
            if scannedCode != "" {
                infomationManager.getCardInfomationBarcode(completion: { card in
                    if (card[0].AcountId != 0){
                        let shortCardCode = extractFromCardCode(cardCode: scannedCode!)
                        storageData.acountId = card[0].AcountId!
                        storageData.cardCode = scannedCode!
                        storageData.phoneMobile = card[0].PhoneMobile ?? ""
                        storageData.shortCardCode = shortCardCode
                        storageData.email = card[0].Email ?? ""
                        storageData.lastName = card[0].LastName ?? ""
                        storageData.firstName = card[0].FirstName ?? ""
                        storageData.secondName = card[0].SurName ?? ""
                        storageData.birthday = card[0].Birthday ?? ""
                        storageData.street = card[0].Street ?? ""
                        storageData.balance = card[0].Balance ?? 0
                        storageData.accumulateOnly = card[0].AccumulateOnly ?? false
                        storageData.blocked = card[0].Blocked ?? false
                        storageData.isPhoneConfirmed = card[0].IsPhoneConfirmed ?? false
                        storageData.clientChipinfo = card[0].ClientChipInfo ?? []
                        progress = false
                        showInfo = true
                    } else {
                        cardNotFound = true
                        progress = false
                    }
                }, cardCode: scannedCode!)
            } else {
                if preselectedIndex == 0 {
                    infomationManager.getCardInfomation(completion: { card in
                        if (card[0].AcountId != 0){
                            storageData.acountId = card[0].AcountId!
                            storageData.cardCode = card[0].CardCode!
                            storageData.phoneMobile = card[0].PhoneMobile ?? ""
                            storageData.shortCardCode = searchInput
                            storageData.email = card[0].Email ?? ""
                            storageData.lastName = card[0].LastName ?? ""
                            storageData.firstName = card[0].FirstName ?? ""
                            storageData.secondName = card[0].SurName ?? ""
                            storageData.birthday = card[0].Birthday ?? ""
                            storageData.street = card[0].Street ?? ""
                            storageData.balance = card[0].Balance ?? 0
                            storageData.accumulateOnly = card[0].AccumulateOnly ?? false
                            storageData.blocked = card[0].Blocked ?? false
                            storageData.isPhoneConfirmed = card[0].IsPhoneConfirmed ?? false
                            storageData.clientChipinfo = card[0].ClientChipInfo ?? []
                            progress = false
                            showInfo = true
                        } else {
                            cardNotFound = true
                            progress = false
                        }
                    }, cardCode: searchInput)
                } else if preselectedIndex == 1 {
                    infomationManager.getCardInfomationByPhone(completion: { card in
                        if (card[0].AcountId != 0){
                            let shortCardCode = extractFromCardCode(cardCode: card[0].CardCode!)
                            storageData.acountId = card[0].AcountId!
                            storageData.cardCode = card[0].CardCode!
                            storageData.phoneMobile = "+992\(searchInput)"
                            storageData.shortCardCode = shortCardCode
                            storageData.email = card[0].Email ?? ""
                            storageData.lastName = card[0].LastName ?? ""
                            storageData.firstName = card[0].FirstName ?? ""
                            storageData.secondName = card[0].SurName ?? ""
                            storageData.birthday = card[0].Birthday ?? ""
                            storageData.street = card[0].Street ?? ""
                            storageData.balance = card[0].Balance ?? 0
                            storageData.accumulateOnly = card[0].AccumulateOnly ?? false
                            storageData.blocked = card[0].Blocked ?? false
                            storageData.isPhoneConfirmed = card[0].IsPhoneConfirmed ?? false
                            storageData.clientChipinfo = card[0].ClientChipInfo ?? []
                            progress = false
                            showInfo = true
                        } else {
                            cardNotFound = true
                            progress = false
                        }
                    }, phone: searchInput)
                }
            }
            
        }
    }
    private func roundToTwoDecimals(_ priceString: String) -> String {
        if let price = Double(priceString) {
            return String(format: "%.2f", price)
        } else {
            return "0.00"
        }
    }
    func extractFromCardCode(cardCode: String) -> String {
        let startIndex = cardCode.index(cardCode.startIndex, offsetBy: 6)
        let endIndex = cardCode.index(cardCode.startIndex, offsetBy: 11)
        let substring = cardCode[startIndex...endIndex]
        return String(substring)
    }
    
}

#Preview {
    LoyalityView()
}

enum ViewVisibility: CaseIterable {
    case visible,
         invisible,
         gone
}

extension View {
    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }
}
