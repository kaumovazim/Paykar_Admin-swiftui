//
//  MaintraceView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import SwiftUI

struct MaintraceView: View {
    @Environment(\.dismiss) var dismiss
    var text: String
    
    var body: some View {
        ZStack{
            VStack(spacing: 30) {
                Spacer()
                LottieView(name: "MaintraceAnim")
                    .scaleEffect(CGSize(width: 0.4, height: 0.4))
                    .frame(maxWidth: 350, maxHeight: 350)
                Text(text)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                Spacer()
            }
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    CustomButton(icon: "multiply")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(50)
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    MaintraceView(text: "")
}
