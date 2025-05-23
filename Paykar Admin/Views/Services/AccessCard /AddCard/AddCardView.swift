//
//  AddCardView.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 18.03.2025.
//

import SwiftUI

struct AddCardView: View {
    @State var addCard = CreateCard()
    @Environment(\.dismiss) var dismiss
    private let overlayWidth: CGFloat = 300
    private let overlayHeight: CGFloat = 150
    @State private var isScanning = true
    @State var progress = false
    @State var showAddAlert = false
    @State var showCancelAlert = false
    @State var showExistsAlert = false
    @State var alertConnection = false
    @State var alertNoScanCode = false
    @State var alertNotFound = false
    @State var scannedCode: String?
    let adminData = UserManager.shared.retrieveUserFromStorage()
    @State var alertTittle: String = ""
    @State var alertMessage: String = ""
    
    
    var scanner: some View {
        ZStack {
            if isScanning {
                GeometryReader { geometry in
                    BarcodeCamera(
                        onCodeScanned: { code in
                            print(code)
                            self.scannedCode = code
                            self.isScanning = false
                        },
                        overlayFrame: CGRect(
                            x: (geometry.size.width - overlayWidth) / 2,
                            y: (geometry.size.height - overlayHeight) / 2,
                            width: overlayWidth,
                            height: overlayHeight
                        )
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            
            VStack {
                Spacer(minLength: 100)
                VStack {
                    Text("Добавить карту")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding()
                    BarcodeOverlayView()
                        .frame(width: overlayWidth, height: overlayHeight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                Spacer(minLength: 200)
            }
            VStack {
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(60)
        }
    }
    
    var result: some View {
            VStack {
                DetailAccessCardVIew(
                    name: "\(String(adminData?.firstname ?? "Неизвестно")) \(String(adminData?.lastname ?? "Неизвестно"))",
                    number: scannedCode ?? "Неизвестно",
                    unit: adminData?.unit ?? "Неизвестно",
                    position: adminData?.position ?? "Неизвестно",
                    status: "active"
                )
                HStack(spacing: 10) {
                    Button {
                        showCancelAlert = true
                        alertTittle = "Вы уверены?"
                        alertMessage = "Вы действительно хотите выйти?"
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("CardColor"))
                                .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
                                .frame(width: 150, height: 50)
                            Text("Отмена")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding(10)
                        }
                    }
                    .alert(alertTittle, isPresented: $showCancelAlert) {
                        Button("Да", role: .cancel ) { dismiss() }
                        Button("Отмена", role: .destructive ) { }
                    } message: {
                        Text(alertMessage)
                    }
                    
                    Button {
                        checkIfCardExists()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("CardColor"))
                                .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
                                .frame(width: 150, height: 50)
                            Text("Добавить")
                                .font(.headline)
                                .foregroundColor(.green)
                                .padding(10)
                        }
                    }
                    .alert(alertTittle, isPresented: $showAddAlert) {
                        Button("Да", role: .cancel ) {
                            addCard.createCard(numberCard: scannedCode ?? "1111111111111") { response in }
                            dismiss()
                        }
                        Button("Отмена", role: .destructive ) { }
                    } message: {
                        Text(alertMessage)
                    }
                    .alert("Ошибка", isPresented: $showExistsAlert) {
                        Button("OK", role: .cancel) { dismiss() }
                    } message: {
                        Text(alertMessage)
                    }
                }
                Spacer()
            }
        }
    
    var body: some View {
        ZStack {
                if isScanning {
                    scanner
                        .transition(.opacity)
                } else if !isScanning && scannedCode != "" {
                    result
                        .transition(.opacity)
                }
            }
        .animation(.snappy(duration: 0.5), value: isScanning)
    }
    private func checkIfCardExists() {
        let listAccessCard = ListAccessCard()
        listAccessCard.getCardList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if listAccessCard.cards.contains(where: { $0.number_card == scannedCode }) {
                alertMessage = "Карта с таким номером уже существует!"
                showExistsAlert = true
            } else {
                showAddAlert = true
                alertTittle = "Вы уверены"
                alertMessage = "что хотите добавить этот элемент?"
            }
        }
    }
}
