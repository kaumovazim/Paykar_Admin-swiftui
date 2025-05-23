//
//  FavoriteCardsListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 07/11/24.
//

import SwiftUI

struct FavoriteCardsListView: View {
    
    @StateObject var favoriteCardManager = FavoriteCardManager()
    @State var alertConnection = false
    @State var updateList = false
    @State var showInfo = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Text("Избранные карты")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                if favoriteCardManager.isLoading {
                    Spacer()
                    ProgressView("")
                        .padding(.bottom, 30)
                    Spacer()
                } else if favoriteCardManager.favoriteCards.isEmpty {
                    Spacer()
                    LottieView(name: "EmptyListAnim")
                        .scaleEffect(CGSize(width: 0.4, height: 0.4))
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 100)
                    Spacer()
                } else {
                    ScrollView{
                        VStack(spacing: 2){
                            ForEach(favoriteCardManager.favoriteCards) { card in
                                FavoriteCardsListItemView(updateList: $updateList, showInfo: $showInfo, card: card)
                                    .fullScreenCover(isPresented: $showInfo) {
                                        let points = Double(card.pointsQuantity)!
                                        CardInfoView(showCorrection: true, points: points, confirmation: true)
                                    }
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .onChange(of: updateList) {
                        if MainManager().checkInternetConnection() {
                            favoriteCardManager.favoriteCardsList()
                        } else {
                            alertConnection = true
                        }
                    }
                }
            }
            .onAppear(perform: {
                if MainManager().checkInternetConnection() {
                    favoriteCardManager.favoriteCardsList()
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
            Button {
                if MainManager().checkInternetConnection() {
                    favoriteCardManager.favoriteCardsList()
                } else {
                    alertConnection = true
                }
            } label: {
                CustomButton(icon: "arrow.triangle.2.circlepath")
            }
            .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .bottom)
            .padding(40)
        }.ignoresSafeArea()
    }
}

#Preview {
    FavoriteCardsListView()
}

struct FavoriteCardsListItemView: View {
    @ObservedObject var storageData: StorageData = StorageData()
    @StateObject var infomationManager = InfomationManager()
    @State var itemOffset: CGFloat = 0
    @State var isSwiping = false
    @State var progress = false
    @Binding var updateList: Bool
    @Binding var showInfo: Bool

    var card: FavoriteCardListModel

    var body: some View {
        ZStack {
            ZStack {
                if itemOffset != 0 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(.red)
                            .frame(height: 70)
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    deleteItem(card: card)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 50)
                            }
                        }
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color("Secondary"))
                        .frame(height: 70)
                    HStack{
                        VStack(alignment: .leading){
                            Text("\(card.firstname) \(card.lastname)")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("Accent"))
                            Text("Номер карты: \(card.shortCardCode)")
                                .foregroundColor(Color("Accent")).opacity(0.5)
                                .padding(.leading, 2)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .padding()
                }
                .contentShape(Rectangle())
                .offset(x: itemOffset)
                .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                .onTapGesture {
                    withAnimation {
                        performSearch()
                    }
                }
            }
            .padding(.horizontal)
            .opacity(progress ? 0 : 1)
            ProgressView("")
                .opacity(progress ? 1 : 0)
        }
    }
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiping {
                itemOffset = value.translation.width - 90
            } else {
                itemOffset = value.translation.width
            }
        }
    }
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    itemOffset = -1000
                    deleteItem(card: card)
                } else if -itemOffset > 50 {
                    isSwiping = true
                    itemOffset = -90
                } else {
                    isSwiping = false
                    itemOffset = 0
                }
            } else {
                isSwiping = false
                itemOffset = 0
            }
        }
    }
    func deleteItem(card: FavoriteCardListModel) {
        progress = true
        FavoriteCardManager().removeFromFavorite(phone: card.phone, status: "deactivated") { response in
            if response.status == "success" {
                progress = false
                updateList = true
            }
        }
    }
    func performSearch() {
        progress = true
        let cardCode = card.shortCardCode
        infomationManager.getCardInfomation(completion: { card in
            if (card[0].AcountId != 0){
                storageData.acountId = card[0].AcountId!
                storageData.cardCode = card[0].CardCode!
                storageData.phoneMobile = card[0].PhoneMobile ?? ""
                storageData.shortCardCode = cardCode
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
            }
        }, cardCode: cardCode)
    }
}
