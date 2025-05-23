//
//  SendNewYearMessageView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 14/11/24.
//

import SwiftUI

struct SendNewYearMessageView: View {
    
    @StateObject var mainManager = MainManager()
    @State var alertConnection = false
    @State var datePurchase = Date()
    @State var checkNumber = ""
    @State var sumPurchase = ""
    @State var showAlert = false
    @State var progress = false
    @State var errorAlert = false
    @Environment(\.dismiss) var dismiss
    
    var firstname: String
    var lastname: String
    var phone: String
    var cardCode: String
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("Отправка новогоднего СМС")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }.padding()
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
            VStack{
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
            }
            VStack{
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
            }
            ZStack{
                Button {
                    progress = true
                    MessageManager().sendNewYearSms(firstName: firstname, lastName: lastname, phone: "\(abs(Int(phone)!))", cardCode: cardCode, numberCheck: checkNumber, purchaseAmount: sumPurchase, datePurchase: mainManager.convertDate(date: datePurchase)) { response in
                        progress = false
                        if response.status == "success" {
                            showAlert = true
                        } else {
                            errorAlert = true
                            showAlert = true
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("Secondary"))
                        HStack{
                            Text("Отправить")
                                .font(.headline)
                                .foregroundColor(Color("Accent"))
                                .padding()
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.headline)
                                .foregroundColor(Color("Accent"))
                                .padding()
                        }.padding(.horizontal)
                    }.frame(height: 50)
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert, content: {
                    if errorAlert {
                        Alert(title: Text("Что то пошло не так!"), message: Text("Не удалось отправить смс"), dismissButton: .default(Text("Ок")))
                    } else {
                        Alert(title: Text(""), message: Text("СМС отправлен успешно!"), dismissButton: .default(Text("Ок"), action: {
                            dismiss()
                        }))
                    }
                })
                .opacity(progress ? 0 : 1)
                ProgressView()
                    .opacity(progress ? 1 : 0)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .presentationDetents([.height(CGFloat(400))])
        .alert("Что то пошло не так!", isPresented: $alertConnection) {
            Button("Попробовать еще", role: .cancel, action: {
                dismiss()
            })
        } message: {
            Text("Проверьте подключение к Интернету и повторите попытку.")
        }
    }
}
