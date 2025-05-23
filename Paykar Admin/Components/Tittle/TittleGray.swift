//
//  TittleGray.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 04.04.2025.
//

import SwiftUI

struct TittleGray: View {
    @State var tittle: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Secondary"))
                .cornerRadius(15)
                .frame(maxWidth: .infinity, maxHeight: 120, alignment: .bottom)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    ButtonCircleView(iconName: "chevron.left", background: "")
                        .padding(.leading)
                }
                Text(tittle)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
            .padding(.bottom)
        }
        .ignoresSafeArea()
    }
}
