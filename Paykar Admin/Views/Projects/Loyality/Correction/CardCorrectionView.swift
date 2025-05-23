//
//  CardCorrectionView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct CardCorrectionView: View {
    
    @State var progress: Double = 0
    @State var comment: String = ""
    @State var message: String = ""
    @State var type: String = "Тип"
    @State var typeSheet: Bool = false
    @State var reason: String = ""
    @State var lastcard: String = ""
    @State var datePurchase = Date()
    @State var checkNumber: String = ""
    @State var sumPurchase: String = ""
    @FocusState var isFocused: Bool
    @FocusState var isFocusedBalance: Bool
    @ObservedObject var storageData: StorageData = StorageData()
    @Environment(\.dismiss) var dismiss
    @State var confirmAlert: Bool = false
    @State var successAlert: Bool = false
    @State var errorAlert: Bool = false
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var body: some View {
        if let admin = UserManager.shared.retrieveUserFromStorage() {
            if admin.position == "Супер Админ" {
                VIPcorrection
            } else {
                correctionRequest
            }
        }
    }
    
    var correctionRequest: some View {
        
        VStack {
            HStack{
                Text("Коррекция")
                    .font(.title)
                    .fontWeight(.semibold)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Укажите количество начисляемых или списаемых баллов")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 10)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    
                    TextField("Введите количество начисляемых баллов", value: $progress , formatter: NumberFormatter.decimal)
                        .padding()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .focused($isFocusedBalance)
                        .keyboardType(.numberPad)
                        .accentColor(Color.white)
                        .background(Color("Primary"))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    
                    
                    HStack {
                        Image(systemName: "minus")
                        Slider(value: $progress, in: -5000...5000, step: 10, onEditingChanged: { change in
                            isFocusedBalance = false
                        })
                        .accentColor(Color("Primary"))
                        .padding(20)
                        Image(systemName: "plus")
                    }
                    .padding(.horizontal, 30)
                    
                    VStack {
                        if type != "Тип" {
                            Text("Тип")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }
                        Button {
                            typeSheet = true
                        } label: {
                            HStack{
                                Text(type)
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 20)
                                
                                Spacer()
                                Image(systemName:  "chevron.down")
                                    .foregroundColor(.secondary)
                                    .frame(width: 15, height: 10)
                            }
                            .padding(15)
                            .padding(.horizontal, 5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                            }
                            
                        }
                        .sheet(isPresented: $typeSheet){
                            CustomList(update: {},list: ["Перевод", "Продажа", "Пополнение"], title: $type, close: $typeSheet)
                        }.padding(.horizontal)
                    }
                    if type == "Перевод" {
                        VStack(spacing: 15){
                            if !lastcard.isEmpty {
                                Text("Номер старой карты")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                            }
                            TextField("Номер старой карты", text: $lastcard)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .frame(height: 40)
                                .cornerRadius(15)
                                .padding(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                                }
                                .padding(.horizontal)
                                .focused($isFocused)
                        }
                    } else if type == "Продажа" {
                        VStack(spacing: 15) {
                            HStack {
                                Text("Дата покупки")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                Spacer()
                                DatePicker("",
                                           selection: $datePurchase,
                                           displayedComponents: [.date])
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                            }
                            if !checkNumber.isEmpty {
                                Text("Номер чека")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                            }
                            TextField("Номер чека", text: $checkNumber)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .frame(height: 40)
                                .cornerRadius(15)
                                .padding(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                                }
                                .padding(.horizontal)
                                .focused($isFocused)
                            if !sumPurchase.isEmpty {
                                Text("Сумма покупки")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                            }
                            TextField("Сумма покупки", text: $sumPurchase)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .frame(height: 40)
                                .cornerRadius(15)
                                .padding(5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                                }
                                .padding(.horizontal)
                                .focused($isFocused)
                        }
                    } else {
                        
                    }
                    VStack {
                        if reason != "Комментариии" {
                            Text("Комментариии")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }
                        TextEditor(text: $reason)
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .cornerRadius(15)
                            .padding(5)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                            }
                            .padding(.horizontal)
                            .focused($isFocused)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 160)
                    .alert(isPresented: $errorAlert) {
                        Alert(title: Text("Что то пошло не так!"),
                              message: Text("Побробуйте снова через некоторое время"),
                              dismissButton: .default(Text("Побробовать еще"))
                        )
                    }
                    
                    Button("Подать заявку") { confirmAlert.toggle() }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 20)
                        .padding(15)
                        .foregroundColor(.white)
                        .background(Color("Primary"))
                        .cornerRadius(25)
                        .padding()
                        .padding(.bottom, 40)
                        .actionSheet(isPresented: $confirmAlert) {
                            ActionSheet(title: Text("Подтверждения!"),
                                        message: Text("Вы подтверждаете заявку на корректировку баланса"),
                                        buttons: [
                                            .default(Text("Подтверждаю"), action: {
                                                
                                                let admin =  UserManager.shared.retrieveUserFromStorage()
                                                CorrectionManager().submitCorrection(firstName: storageData.firstName,
                                                                                     lastName: storageData.lastName,
                                                                                     phone: storageData.phoneMobile,
                                                                                     staffName: "\(admin!.firstname) \(admin!.lastname)",
                                                                                     numberCheck: "",
                                                                                     type: type,
                                                                                     datePurchase: "\(datePurchase)",
                                                                                     sumPurchase: Double(sumPurchase) ?? 0,
                                                                                     accruedPoints: Int(progress),
                                                                                     cardCode: storageData.cardCode, 
                                                                                     shortCardCode: storageData.shortCardCode,
                                                                                     lastCardCode: lastcard,
                                                                                     reason: reason,
                                                                                     userId: "\(admin!.id)") { response in
                                                    if response.status == "success" {
                                                        isFocused = false
                                                        successAlert.toggle()
                                                    } else {
                                                        errorAlert.toggle()
                                                    }
                                                }
                                            }),
                                            .cancel(Text("Отменить"))
                                        ]
                            )
                        }
                        .alert(isPresented: $successAlert) {
                            Alert(title: Text("Заяка подана!"),
                                  message: Text(""),
                                  dismissButton: .default(Text("Продолжить"), action: {
                                dismiss()
                            })
                            )
                        }
                        .disabled(progress == 0 && type == "Тип"  && reason.isEmpty && (type == "Перевод" ? lastcard.isEmpty : sumPurchase.isEmpty && checkNumber.isEmpty))
                }
            }
        }
        .onTapGesture {
            isFocused = false
            isFocusedBalance = false
        }
    }
    
    var VIPcorrection: some View {
        
        VStack {
            HStack{
                Text("Коррекция")
                    .font(.title)
                    .fontWeight(.semibold)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Укажите количество начисляемых или списаемых баллов")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 10)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    
                    TextField("Введите количество начисляемых баллов", value: $progress , formatter: NumberFormatter.decimal)
                        .padding()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .focused($isFocusedBalance)
                        .keyboardType(.numberPad)
                        .accentColor(Color.white)
                        .background(Color("Primary"))
                        .cornerRadius(15)
                        .padding()
                    
                    
                    HStack {
                        Image(systemName: "minus")
                        Slider(value: $progress, in: -5000...5000, step: 10, onEditingChanged: { change in
                            isFocusedBalance = false
                        })
                        .accentColor(Color("Primary"))
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        
                        Image(systemName: "plus")
                    }
                    .padding(.top)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .trailing) {
                        
                        Text("Комментарий")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.top, 20)
                        
                        TextEditor(text: $comment)
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .cornerRadius(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).fill(Color("IconColor"))
                            }
                            .padding(.horizontal)
                            .focused($isFocused)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 160)
                    
                    Spacer()
                    
                    Button("Корректировать") { confirmAlert.toggle() }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 20)
                        .padding(15)
                        .foregroundColor(.white)
                        .background(Color("Primary"))
                        .cornerRadius(25)
                        .padding()
                        .padding(.bottom, 40)
                        .actionSheet(isPresented: $confirmAlert) {
                            ActionSheet(title: Text("Подтверждения!"),
                                        message: Text("Вы подтверждаете корректировку баланса"),
                                        buttons: [
                                            .default(Text("Подтверждаю"), action: {
                                                let cardCode = storageData.cardCode
                                                let phone = storageData.phoneMobile
                                                let admin = UserManager.shared.retrieveUserFromStorage()
                                                var addBonus = 0.0
                                                var removeBonus = 0.0
                                                
                                                if(progress >= 0) {
                                                    addBonus = progress
                                                    message = "Вам были начислены \(addBonus) баллов"
                                                } else {
                                                    removeBonus = abs(progress)
                                                    message = "С вас было списано \(removeBonus) баллов"
                                                }
                                                
                                                CorrectionManager().getCardInfomation(cardCode: cardCode, comment: comment, addBonus: addBonus, removeBonus: removeBonus) { card in
                                                    storageData.balance = card[0].Balance!
                                                    progress = 0
                                                    comment = ""
                                                    isFocused = false
                                                    successAlert.toggle()
                                                    MessageManager().sendSms(phone: "\(abs(Int(phone)!))", sms: message, userId: admin!.id) { response in
                                                        
                                                    }

                                                }
                                            }),
                                            .cancel(Text("Отменить"))
                                        ]
                            )
                        }
                    
                        .alert(isPresented: $successAlert) {
                            Alert(title: Text("Баланс скорректирован"),
                                  message: Text(""),
                                  dismissButton: .default(Text("Продолжить"), action: {
                                dismiss()
                            })
                            )
                        }
                    
                }
                
            }
        }.onTapGesture {
            isFocused = false
            isFocusedBalance = false
        }

    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }
}


#Preview {
    CardCorrectionView()
}
