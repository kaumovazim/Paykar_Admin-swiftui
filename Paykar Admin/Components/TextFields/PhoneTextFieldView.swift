//
//  PhoneTextFieldView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct PhoneTextFieldView: View {
    
    var text: String
    var color: Color
    
    var body: some View {
        VStack {
            HStack(spacing: 2){
                Text("+992")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(height: 55)
                    .padding(.trailing, 10)
                    .foregroundColor(color.opacity(0.4))
                    
                Text(text)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(height: 55)
                    .foregroundColor(color)
                    .lineSpacing(14)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .padding(.top, -10)
        }
    
    }
}

struct PhoneTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneTextFieldView(text: "999999999", color: Color("Accent"))
    }
}

