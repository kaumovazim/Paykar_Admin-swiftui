//
//  PromoCodeView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct PromoCodeView: View {
    @State private var quantity: String = ""
    @State private var isPresent: Bool = false
    @State private var showingAlert: Bool = false
    @ObservedObject var storageData: StorageData = StorageData()
    var body: some View {
        NavigationStack {
            VStack {
                    Spacer()
                    TextField("Количество ID кодов", text: $quantity)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .padding(10)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(15)
                        .padding(20)
                        .keyboardType(.numberPad)
                        .foregroundColor(.white)
                        .accentColor(Color.white)
                    
                    Button("Добавить") {
                        let phone = storageData.phoneMobile
                        let cardCode = storageData.shortCardCode
                        let fullName = storageData.firstName + " " + storageData.lastName + " " + storageData.secondName
                        let quntityInt = Int(quantity)
                        PromoManager().sendPromoCode(phoneNumber: phone, shortCardCode: cardCode, fullName: fullName, quantityCode: quntityInt ?? 1) { promoCode in
                            if (promoCode.response == "true") {
                                showingAlert.toggle()
                            }
                        }
                    }
                    .frame(height: 15, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .foregroundColor(.white)
                    .background(Color("cardBackground"))
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.top, 80)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Успешно добавлен!"),
                                message: Text("Участнику успешно отправлены ID коды"),
                            dismissButton: .default(Text("Спасибо!")))
                    }
                    Spacer()
                }
                .navigationTitle("Добавить участника")
        }
    }
}

#Preview {
    PromoCodeView()
}
