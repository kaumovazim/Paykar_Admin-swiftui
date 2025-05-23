//
//  CertificateInfoView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/10/24.
//

import SwiftUI

struct CertificateInfoView: View {
    
    @StateObject var certificateManager = InfomationManager()
    @State private var isScanning = true
    @State var progress = false
    @State var showAlert = false
    @State var alertConnection = false
    @State var alertNoScanCode = false
    @State var alertNotFound = false
    @State var scannedCode: String?
    @State var certificateModel: CertificateInfomationModel? = nil
    private let overlayWidth: CGFloat = 300
    private let overlayHeight: CGFloat = 150
    @Environment(\.dismiss) var dismiss

    var result: some View {
        ZStack {
            ZStack{
                Image("certificateBg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 70){
                    Spacer(minLength: 250)
                    HStack{
                        Text("Статус:")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                        Text("\(certificateModel?.CardStatus ?? "")")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                    HStack{
                        Text("Дата действия:")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                        Text("\(formatDate(from: certificateModel?.StartDate ?? ""))")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                    HStack{
                        Text("Действителен до:")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                        Text("\(formatDate(from: certificateModel?.FinishDate ?? ""))")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                    HStack{
                        Text("Баланс:")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                        Text("\(roundToTwoDecimals(String(certificateModel?.Balance ?? 0)))")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(40)
                .alert(isPresented: $showAlert, content: {
                    if alertConnection {
                        Alert(title: Text("Что то пошло не так!"),
                              message: Text("Проверьте подключение к Интернету и повторите попытку."),
                              dismissButton: .default(Text("Попробовать еще"),action: { dismiss() })
                        )
                    } else if alertNoScanCode {
                        Alert(title: Text("Что то пошло не так!"),
                              message: Text("Не удалось сканироват сертификат"),
                              dismissButton: .default(Text("Попробовать еще"),action: {
                            dismiss()
                        })
                        )

                    } else if alertNotFound {
                        Alert(title: Text("Сертификат не найден!"),
                              message: Text(""),
                              dismissButton: .default(Text("Назад"), action: { dismiss() })
                        )

                    } else {
                        Alert(title: Text("ЧТО ТО ПОШЛО НЕ ТАК!"),
                              message: Text(""),
                              dismissButton: .default(Text("Попробовать еще"),action: { dismiss() })
                        )

                    }
                })
            }
            .opacity(progress ? 0 : 1)
            
            ProgressView()
                .opacity(progress ? 1 : 0)
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
        .onAppear() {
            progress = true
            if scannedCode != "" {
                if MainManager().checkInternetConnection() {
                    certificateManager.getCertificateInfomation(completion: { response in
                        if response.CardCode != "" {
                            certificateModel  = response
                            progress = false
                        } else {
                            showAlert = true
                            alertNotFound = true
                            progress = false
                        }
                    }, certificateCode: scannedCode!)
                } else {
                    showAlert = true
                    alertConnection = true
                    progress = false
                }
            } else {
                showAlert = true
                alertNoScanCode = true
                progress = false
            }
        }
    }
    var scanner: some View {
        ZStack {
            if isScanning {
                GeometryReader { geometry in
                    BarcodeCamera(
                        onCodeScanned: { code in
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
                    Text("Проверка сертификата")
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
    var body: some View {
        if isScanning {
            scanner
        } else if !isScanning && scannedCode != "" {
            result
        }
    }
    private func roundToTwoDecimals(_ priceString: String) -> String {
        if let price = Double(priceString) {
            return String(format: "%.2f", price)
        } else {
            return "0.00"
        }
    }
    private func formatDate(from isoDateString: String) -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = isoFormatter.date(from: isoDateString) else {
            return "Invalid Date"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        return outputFormatter.string(from: date)
    }
}

#Preview {
    CertificateInfoView()
}
