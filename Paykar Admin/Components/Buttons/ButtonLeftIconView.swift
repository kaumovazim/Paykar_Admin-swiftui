//
//  ButtonLeftIconView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct ButtonLeftIconView: View {
    
    var text: String
    var icon: String
    @State var background = Color("Accent")
    @State var textColor = Color("ButtonText")
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        HStack {
            Text(text)
                .padding(.horizontal, 30)
                .foregroundColor(textColor)
                .font(.headline)

            Spacer()
            Image(systemName: icon)
                .padding(.horizontal, 15)
                .foregroundColor(Color("ButtonText"))
                .padding(10)
                .background(Color("ButtonText").opacity(colorScheme == .dark ? 0.2 : 0.4))
                .mask(Circle())
        }
         .frame(maxWidth: .infinity)
         .frame(height: 60)
         .background(background)
         .cornerRadius(30)
         
    }
}

struct ButtonLeftIconView_Previews: PreviewProvider {
    static var previews: some View {
        
        ButtonLeftIconView(text: "ПРОДОЛЖИТЬ", icon: "chevron.right")
        
    }
}
