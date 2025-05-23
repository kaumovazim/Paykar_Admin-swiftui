//
//  SplashScreenView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        Image("splash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
            .padding(-30)
    }
}

#Preview {
    SplashScreenView()
}
