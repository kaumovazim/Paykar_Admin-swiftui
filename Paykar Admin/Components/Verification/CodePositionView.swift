//
//  CodePositionView.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//

import SwiftUI

struct CodePositionView: View{
    var text: String
    var body: some View{
        VStack(spacing: 8) {
            Text(text)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color("Accent"))
                .frame(height: 45)
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 4)
        }
        .frame(width: 50)
    }
}

class LimitVerificationCode: ObservableObject {
    var limit: Int = 5
    @Published var text: String = ""{
        didSet {
            if text.count > limit {
                text = String(text.prefix(limit))
            }
        }
    }
    var limitCode: Int = 4
    @Published var code: String = ""{
        didSet {
            if code.count > limitCode {
                code = String(code.prefix(limitCode))
            }
        }
    }
    
    var limitPhone: Int = 9
    @Published var textPhone: String = ""{
        didSet {
            if textPhone.count > limitPhone {
                textPhone = String(textPhone.prefix(limitPhone))
            }
        }
    }
    var limitCardNumber: Int = 6
    @Published var card: String = ""{
        didSet {
            if card.count > limitCardNumber {
                card = String(card.prefix(limitCardNumber))
            }
        }
    }
}
