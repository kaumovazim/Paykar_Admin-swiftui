//
//  TextFieldView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/08/24.
//

import SwiftUI

struct TextFieldView: View {
    
    @Binding var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title3)
                .foregroundColor(Color("IconColor"))
                .padding(.top, 10)
                .padding(.bottom, 5)
            TextField("", text: $text)
                .font(.system(size: 20))
                .keyboardType(.default)
                .foregroundStyle(Color("Accent"))
            Divider()
        }
    }
}

