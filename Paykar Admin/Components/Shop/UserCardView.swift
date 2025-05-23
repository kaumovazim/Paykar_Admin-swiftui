//
//  UserCardView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/08/24.
//

import SwiftUI

struct UserCardView: View {
    
    @State var name: String
    @State var surname: String
    @State var phone: String
    @State var dateRegister: String
    
    var body: some View {
        VStack{
            HStack{
//                Circle()
//                    .fill(LinearGradient(gradient: Gradient(colors: [Color("LightPrimary"), Color("DarkPrimary")]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .frame(width: 50, height: 50)
//                    .overlay(
//                        Text("\(name.prefix(1))\(surname.prefix(1))")
//                            .font(.system(size: 20))
//                            .foregroundColor(.white)
//                    )
//                    .shadow(radius: 5)
                VStack(alignment: .leading) {
                    Text("\(name) \(surname)")
                        .font(.headline)
                    Text("\(phone)")
                        .font(.subheadline)
                    Text("\(dateRegister)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    //                        Text("Активный: \(user.active ?? "N/A")")
                    //                            .font(.caption)
                    //                            .foregroundColor(user.active == "Y" ? .green : .red)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(Color("Accent"))
            }
        }
    }
}
#Preview {
    UserCardView(name: "Azim", surname: "Каюмов", phone: "555557571", dateRegister: "31.01.2240")
}
