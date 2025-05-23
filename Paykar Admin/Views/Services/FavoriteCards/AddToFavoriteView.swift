//
//  AddToFavoriteView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 14/11/24.
//

import SwiftUI

struct AddToFavoriteActionSheet: View {
    @State var pointsQuantity: String = "500"
    @Environment(\.dismiss) var dismiss
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phone: String
    @Binding var cardCode: String
    @Binding var shortCardCode: String
    @Binding var favorite: Bool
    @FocusState var focus
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Добавить в избранные")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Введите рекомендуемое \n количество баллов")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextField("", text: $pointsQuantity)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                .foregroundColor(.primary)
                .padding()
                .background(Color("Secondary"))
                .cornerRadius(15)
                .keyboardType(.numberPad)
                .focused($focus)
            HStack{
                Button {
                    withAnimation(.easeInOut){
                        let admin = UserManager.shared.retrieveUserFromStorage()
                        FavoriteCardManager().addToFavorite(firstName: firstName,
                                                            lastName: lastName,
                                                            phone: phone,
                                                            status: "active",
                                                            cardCode: cardCode,
                                                            shortCardCode: shortCardCode,
                                                            pointsQuantity: Int(pointsQuantity)!,
                                                            accrualPointsBy: "\(admin!.id)") { response in
                            if response.status == "success" {
                                favorite = true
                                dismiss()
                            } else {
                                print("failed to add to favorites")
                            }
                        }
                    }
                } label: {
                    Text("Добавить")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Secondary"))
                        .foregroundColor(Color("Accent"))
                        .cornerRadius(15)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Отмена")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Secondary"))
                        .foregroundColor(.red)
                        .cornerRadius(15)
                }
            }
        }
        .onTapGesture {
            focus = false
        }
        .padding(.horizontal)
        .presentationDetents([.height(CGFloat(300))])
    }
}
