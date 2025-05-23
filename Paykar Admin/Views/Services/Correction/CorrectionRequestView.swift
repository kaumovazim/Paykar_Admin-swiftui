//
//  ConfirmPointsView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct CorrectionRequestView: View {
    @StateObject var correctionManager = CorrectionManager()
    @ObservedObject var storageData: StorageData = StorageData()
    @Environment(\.dismiss) var dismiss
    @State var alertConnection = false
    @State var successAlert: Bool = false
    @State var errorAlert: Bool = false
    @State var isDeactived: Bool = false
    @State var successMessage: String = ""
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Заявки на коррекцию")
                        .font(.title)
                        .fontWeight(.semibold)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                if correctionManager.isLoading {
                    Spacer()
                    ProgressView("")
                    Spacer()
                } else if correctionManager.correctionRequests.isEmpty {
                    Spacer()
                    LottieView(name: "EmptyListAnim")
                        .scaleEffect(CGSize(width: 0.4, height: 0.4))
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    ScrollView{
                        VStack(spacing: 15){
                            ForEach(correctionManager.correctionRequests) { request in
                                CorrectionRequestItemView(successAlert: $successAlert, errorAlert: $errorAlert, isDeactived: $isDeactived, successMessage: $successMessage, errorMessage: $errorMessage, request: request)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.bottom, 80)
                    .alert(isPresented: $successAlert, content: {
                        Alert(title: Text("Заявка одобрена!"), message: Text(successMessage), dismissButton: .default(Text("Ок"), action: {
                            if MainManager().checkInternetConnection() {
                                correctionManager.getCorrectionRequestsList()
                            } else {
                                alertConnection = true
                            }
                        }))
                    })
                }
            }
            .alert(isPresented: $errorAlert, content: {
                Alert(title: Text("Что то пошло не так!"), message: Text(errorMessage), dismissButton: .default(Text("Побробовать еще"), action: {
                    if MainManager().checkInternetConnection() {
                        correctionManager.getCorrectionRequestsList()
                    } else {
                        alertConnection = true
                    }
                }))
            })
            HStack{
                Button {
                    if MainManager().checkInternetConnection() {
                        correctionManager.getCorrectionRequestsList()
                    } else {
                        alertConnection = true
                    }
                } label: {
                    CustomButton(icon: "arrow.triangle.2.circlepath")
                }
                .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .bottom)
                .padding(40)
                .alert(isPresented: $isDeactived, content: {
                    Alert(title: Text("Заявка отклонена!"), dismissButton: .default(Text("Ок"), action: {
                        if MainManager().checkInternetConnection() {
                            correctionManager.getCorrectionRequestsList()
                        } else {
                            alertConnection = true
                        }
                    }))
                })
            }
        }.ignoresSafeArea()
            .onAppear(perform: {
                if MainManager().checkInternetConnection() {
                    correctionManager.getCorrectionRequestsList()
                } else {
                    alertConnection = true
                }
            })
            .alert("Что то пошло не так!", isPresented: $alertConnection) {
                Button("Попробовать еще", role: .cancel, action: {
                    dismiss()
                })
            } message: {
                Text("Проверьте подключение к Интернету и повторите попытку.")
            }
    }
}
#Preview {
    CorrectionRequestView()
}

struct CorrectionRequestItemView: View {
    @StateObject var mainManager = MainManager()
    @StateObject var correctionManager = CorrectionManager()
    @State var alertConnection = false
    @State var progress = false
    @Binding var successAlert: Bool
    @Binding var errorAlert: Bool
    @Binding var isDeactived: Bool
    @Binding var successMessage: String
    @Binding var errorMessage: String
    @State var showAdmin: Bool = false

    var request: CorrectionListModel
    
    var sale: some View {
        VStack (spacing: 10){
            HStack {
                Text("Дата покупки:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(mainManager.formattedDateToString(request.datePurchase))
                    .font(.headline)
            }.padding(.horizontal, 10)
            HStack {
                Text("Номер чека:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(request.numberCheck)
                    .font(.headline)
            }.padding(.horizontal, 10)
            HStack {
                Text("Сумма покупки:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(request.sumPurchase)
                    .font(.headline)
            }.padding(.horizontal, 10)
            HStack {
                Text("Начисление баллов:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(request.accruedPoints)
                    .font(.headline)
                    .foregroundStyle(.green)
            }.padding(.horizontal, 10)
        }
    }
    var transfer: some View {
        VStack (spacing: 10){
            HStack {
                Text("Номер старой карты:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(request.lastCardCode)
                    .font(.headline)
            }.padding(.horizontal, 10)
            HStack {
                Text("Перевод баллов:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(request.accruedPoints)
                    .font(.headline)
                    .foregroundStyle(.green)
            }.padding(.horizontal, 10)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardColor"))
                .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
            
            VStack(alignment: .leading){
                HStack {
                    Text("Заявка №\(request.id)")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                    Spacer()
                    Text(mainManager.formattedDateToString(request.createDate))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(5)
                Divider()
                VStack (spacing: 10) {
                    HStack {
                        Text("Тип:")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(request.type)
                            .font(.headline)
                    }.padding(.horizontal, 10)
                    HStack {
                        Text("Номер карты:")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(request.cardCode)
                            .font(.headline)
                    }.padding(.horizontal, 10)
                    if request.type == "Продажа" {
                        sale
                    } else if request.type == "Перевод" {
                        transfer
                    } else {
                        HStack {
                            Text("Начисление баллов:")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(request.accruedPoints)
                                .font(.headline)
                                .foregroundStyle(.green)
                        }.padding(.horizontal, 10)
                    }
                    HStack {
                        Text("Заявку подал:")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(request.staffName)
                            .font(.headline)
                    }.padding(.horizontal, 10)
                    HStack{
                        Button {
                            progress = true
                            let admin = UserManager.shared.retrieveUserFromStorage()
                            CorrectionManager().updateCorrection(userId: request.id,
                                                                 status: request.status,
                                                                 statusConfirmed: "confirmed", confirmUserId: "\(admin!.id)") { response in
                                if (response.status == "success") {
                                    if MainManager().checkInternetConnection() {
                                        CorrectionManager().getCardInfomation(cardCode: request.cardCode, comment: "\(request.type)/n \(request.reason)", addBonus: Double(request.accruedPoints)!, removeBonus: 0) { card in
                                                successAlert = true
                                                progress = false
                                                successMessage = "Баллы были начислены успешно."
                                            let phone = request.phone
                                            MessageManager().sendSms(phone: "\(abs(Int(phone)!))", sms: "Вам были начислены \(request.accruedPoints) баллов", userId: admin!.id) { response in
                                                
                                            }
                                        }
                                    } else {
                                        alertConnection = true
                                        progress = false
                                    }
                                } else {
                                    progress = false
                                    errorAlert  = true
                                    errorMessage = "Побробуйте снова через некоторое время"
                                }
                            }
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("CardColor"))
                                    .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
                                Text("Одобрить")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                    .padding(10)
                            }
                        }
                        Button {
                            progress = true
                            if MainManager().checkInternetConnection() {
                                let admin = UserManager.shared.retrieveUserFromStorage()
                                CorrectionManager().updateCorrection(userId: request.id,
                                                                     status: "deactivated",
                                                                     statusConfirmed: "rejected", confirmUserId: "\(admin!.id)") { response in
                                    if (response.status == "success") {
                                        isDeactived = true
                                        progress = false
                                    } else {
                                        progress = false
                                        errorAlert  = true
                                        errorMessage = "Побробуйте снова через некоторое время"
                                    }
                                }
                            } else {
                                alertConnection = true
                            }
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("CardColor"))
                                    .shadow(color: Color("Accent").opacity(0.1), radius: 5, x: 0, y: 3)
                                Text("Отклонить")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding(10)
                            }
                        }
                    }.padding(.top)
                }
                .padding(.top, 5)
            }
            .padding()
            .opacity(progress ? 0 : 1)
            
            ProgressView("")
                .opacity(progress ? 1 : 0)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
