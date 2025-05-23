//
//  CardInfoView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import SwiftUI

struct CardInfoView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var storageData: StorageData = StorageData()
    @State var admin: AdminModel? = nil
    @State var isShowing = false
    @State var showCorrection = false
    @State var showHistory = false
    @State var cardCode: String = ""
    @State var shortCardCode: String = ""
    @State var balance: Double = 1000.00
    @State var points: Double = 0
    @State var confirmation: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var secondName: String = ""
    @State var email: String = ""
    @State var birthDate: String = ""
    @State var street: String = ""
    @State var city: String = ""
    @State var house: String = ""
    @State var phone: String = ""
    @State var pointsQuantity: String = ""
    @State var chip: [ChipModel] = []
    @State var vip: Bool = true
    @State var status: Bool = true
    @State var accumulation: Bool = true
    @State var isConfimPhone: Bool = false
    @State var edit: Bool = false
    @State var favorite: Bool = false
    @State var favoriteDisable: Bool = true
    @State var favoriteAction: Bool = false
    @State var messageSheet: Bool = false
    @State var favoriteRemove: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing) {
                VStack {
                    HStack {
                        Text("Данные карты")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        if admin?.position == "Супер Админ" {
                            HStack(spacing: 20){
                                Button {
                                    messageSheet = true
                                } label: {
                                    Image(systemName: "arrow.up.message")
                                        .font(.system(size: 22))
                                }
                                .sheet(isPresented: $messageSheet, content: {
                                    SendNewYearMessageView(firstname: firstName, lastname: lastName, phone: phone, cardCode: cardCode)
                                })
                                Button {
                                    if !favorite {
                                        favoriteAction.toggle()
                                    } else {
                                        favoriteRemove.toggle()
                                    }
                                } label: {
                                    Image(systemName: favorite ? "star.fill" : "star")
                                        .font(.system(size: 22))
                                }
                                .disabled(favoriteDisable)
                                .actionSheet(isPresented: $favoriteRemove, content: {
                                    ActionSheet(title: Text("Вы уверены что хотите убрать карту из избранных"), buttons: [
                                        .default(Text("Да"), action: {
                                            FavoriteCardManager().removeFromFavorite(phone: phone, status: "deactivated") { response in
                                                if response.status == "success" {
                                                    favorite = false
                                                }
                                            }
                                        }),
                                        .cancel(Text("Нет"))
                                    ])
                                })
                                .sheet(isPresented: $favoriteAction) {
                                    AddToFavoriteActionSheet(firstName: $firstName,
                                                             lastName: $lastName,
                                                             phone: $phone,
                                                             cardCode: $cardCode,
                                                             shortCardCode: $shortCardCode,
                                                             favorite: $favorite)
                                }
                            }
                        }
//                        Button {
//                            edit = true
//                        } label: {
//                            Image(systemName: "square.and.pencil")
//                                .font(.system(size: 20))
//                        }
//                        .sheet(isPresented: $edit, content: {
//                            CardEditView()
//                        })
                    }
                    .padding(.top, 40)
                    .padding(.bottom)
                    
                    ScrollView{
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Номер карты")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 5)
                                    
                                    Text(shortCardCode)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title2)
                                        .padding(.top, 1)
                                        .padding(.leading, 5)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Secondary"))
                                .cornerRadius(10)
                                
                                Spacer()
                                
                                VStack {
                                    Text("Баланс")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 5)
                                    Text("\(String(format: "%0.2f", balance))")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title2)
                                        .padding(.top, 1)
                                        .padding(.leading, 5)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Secondary"))
                                .cornerRadius(10)
                            }
                            if chip.first?.Balance == 0 {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Звёзды")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 5)
                                        .padding(.leading, 5)
                                    
                                    Text("\(chip.first?.Balance ?? 0)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title2)
                                        .padding(.top, 1)
                                        .padding(.leading, 5)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Secondary"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.bottom)
                        VStack {
                            if firstName != "" {
                                HStack {
                                    Text("Имя")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(firstName)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            if lastName != "" {
                                HStack {
                                    Text("Фамилия")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(lastName)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            if secondName != "" {
                                HStack {
                                    Text("Отчество")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(secondName)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            if birthDate == "" {
                                HStack {
                                    Text("Дата рождения")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(birthDate)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            
                            Button(action: {
                                isConfimPhone = true
                            }, label: {
                                HStack {
                                    Text("Мобильный")
                                        .foregroundColor(storageData.isPhoneConfirmed ? Color("Primary") : .red)
                                        .font(.title3)
                                    
                                    Spacer()
                                    Text(phone)
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(storageData.isPhoneConfirmed ? Color("Primary") : .red)
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                        .alert("Подтверждение номера", isPresented: $isConfimPhone) {
                                            Button("Отмена", role: .destructive, action: {})
                                            Button("Подтвердить", role: .cancel, action: {
                                                setProfileInfo(profileInfo: SetProfileInfoModel(ClientId: storageData.acountId, PhoneMobile: "\(storageData.phoneMobile)", PhoneConfirmed: true))
                                            })
                                        }
                                    
                                }.padding(10)
                            })
                            Divider()
                            if email != "" {
                                HStack {
                                    Text("Э. почта")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(email)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            if city != "" {
                                HStack {
                                    Text("Город")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text(city)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            if street != "" {
                                HStack {
                                    Text("Адрес")
                                        .foregroundColor(Color("Primary"))
                                        .font(.title3)
                                    Spacer()
                                    Text("\(street) \(house)")
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .frame(width: 190, height: 25, alignment: .leading)
                                }
                                .padding(10)
                                Divider()
                            }
                            HStack {
                                Text("Статус")
                                    .foregroundColor(Color("Primary"))
                                    .font(.title3)
                                Spacer()
                                Text(status ? "Не активен" : "Активен")
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(1)
                                    .frame(width: 190, height: 25, alignment: .leading)
                            }
                            .padding(10)
                            Divider()
                            HStack {
                                Text("Накопления")
                                    .foregroundColor(Color("Primary"))
                                    .font(.title3)
                                Spacer()
                                Text(accumulation ? "Да" : "Нет")
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(1)
                                    .frame(width: 190, height: 25, alignment: .leading)
                            }
                            .padding(10)
                        }
                        .padding(.bottom, 80)
                    }.scrollIndicators(.hidden)
                }
                .padding(20)
            }.ignoresSafeArea()
                .onAppear {
                    updateStorageData()
                    checkFavorite()
                    if let Admin = UserManager.shared.retrieveUserFromStorage() {
                        admin = Admin
                    }
                }
            HStack{
                Button {
                    showCorrection.toggle()
                } label: {
                    CustomButton(icon: "pencil")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .sheet(isPresented: $showCorrection, content: {
                    CardCorrectionView(progress: points, confirmAlert: confirmation)
                        .onDisappear {
                            updateStorageData()
                            checkFavorite()
                        }
                })
                Button {
                    dismiss()
                } label: {
                    CustomButton(icon: "multiply")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .sheet(isPresented: $showHistory, content: {
                    CardHistoryView()
                        .onDisappear {
                            updateStorageData()
                            checkFavorite()
                        }
                })
                Button {
                    showHistory.toggle()
                } label: {
                    CustomButton(icon: "list.bullet")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }.padding(30)
        }
        .ignoresSafeArea()
    }
    
    func setProfileInfo(profileInfo: SetProfileInfoModel) {
        InfomationManager().setProfileInfo(info: profileInfo) { result in
        }
    }
    
    func checkFavorite() {
        FavoriteCardManager().checkFavorite(phone: phone) { response in
            print(response)
            if response.status == "success" {
                favoriteDisable = false
                favorite = true
            } else {
                favorite = false
                favoriteDisable = false
            }
        }
    }
    
    func updateStorageData() {
        if storageData.acountId != 0 {
            shortCardCode = storageData.shortCardCode
            cardCode = storageData.cardCode
            balance = storageData.balance
            firstName = storageData.firstName
            lastName = storageData.lastName
            secondName = storageData.secondName
            birthDate = storageData.convertDateToString(date: storageData.birthday)
            email = storageData.email
            phone = storageData.phoneMobile
            street = storageData.street
            city = storageData.city
            house = storageData.house
            status = storageData.blocked
            accumulation = storageData.accumulateOnly
            chip = storageData.clientChipinfo
            HistoryManager().getHistory(cardCode: cardCode) { history in
                storageData.saveHistoryList(value: history)
            }
        }
    }
}

#Preview {
    CardInfoView()
}


