//
//  ButtonCircleView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct ButtonCircleView: View {
    
    @State var iconName: String
    @State var background: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        HStack{
            Image(systemName: iconName)
                .foregroundColor(Color("Accent"))
                .frame(width: 25, height: 25)
                .mask(Circle())
        }
        .frame(width: 45, height: 45)
        .background(Color(background).opacity(background == "IconColor" ? 0.3 : 0.7))
        .cornerRadius(30)
    }
}

struct ButtonCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCircleView(iconName: "chevron.left", background: "IconColor")
    }
}
