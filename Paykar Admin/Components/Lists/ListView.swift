//
//  ListView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 27/08/24.
//

import SwiftUI

struct CustomList: View {
    var update: ()->Void
    @State var list: [String]
    @State var add = false
    @State var addAddress = false
    @State var deleteB = false
    @Binding var title: String
    @Binding var close: Bool
    var body: some View {
            VStack{
                ForEach(0..<list.count){ item in
                    Button {
                        close = false
                        title = list[item]
                    } label: {
                        HStack{
                            Text(list[item])
                                .font(.system(size: 16))
                                .foregroundStyle(Color("Accent"))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "checkmark")
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color("Accent"))
                                .opacity(title == list[item] ? 1 : 0)
                        }
                        .padding(15)
                        .background(Color("Secondary").opacity(0.8))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 10)
                }
                Button {
                    add.toggle()
                } label: {
                    ButtonLeftIconView(text: "Добавить адрес", icon: "chevron.right")
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .opacity(addAddress ? 1 : 0)
            }
            .padding(.bottom, addAddress ? 0 : -85)
            .presentationDetents([.height(addAddress ? CGFloat((75 * list.count) + 80) : CGFloat(75 * list.count))])
    }
}
