//
//  MessageModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 23/10/24.
//

import Foundation

struct SmsParameter: Encodable {
    var phone: String
    var sms: String
    var userId: Int
}

struct SmsResponse: Codable {
    var status: String
    var message: String?
}
struct NewYearPromotionMessageParameters: Encodable {
    var firstName: String
    var lastName: String
    var phone: String
    var longCardCode: String
    var numberCheck: String
    var purchaseAmount: String
    var datePurchase: String
}
