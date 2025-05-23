//
//  CorrectionModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 20/10/24.
//

import Foundation

struct PointCorrectionModel: Codable {
    var firstName: String
    var lastName: String
    var phone: String
    var staffName: String
    var numberCheck: String
    var type: String
    var datePurchase: String
    var sumPurchase: Double
    var accruedPoints: Int
    var cardCode: String
    var shortCardCode: String
    var lastCardCode: String
    var reason: String
    var userId: String
}
struct CorrectionListModel: Identifiable, Codable {
    var id: String
    var createDate: String
    var firstName: String
    var lastName: String
    var phone: String
    var staffName: String
    var status: String
    var numberCheck: String
    var type: String
    var datePurchase: String
    var sumPurchase: String
    var accruedPoints: String
    var cardCode: String
    var shortCardCode: String
    var lastCardCode: String
    var reason: String
    var dateApproval: String?
    var userId: String
    var statusConfirmed: String? 
    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case staffName = "staff_name"
        case status
        case numberCheck = "number_check"
        case type
        case datePurchase = "date_purchase"
        case sumPurchase = "sum_purchase"
        case accruedPoints = "accrued_points"
        case cardCode = "card_code"
        case shortCardCode = "short_card_code"
        case lastCardCode = "last_card_code"
        case reason
        case dateApproval = "date_approval"
        case userId = "user_id"
        case statusConfirmed = "status_confirmed"
    }
}

struct correctionParametersModel: Encodable {
    var licenseGuid: String
    var subjectCode: String
    var cardCode: String
    var addBonus: Double
    var removeBonus: Double
    var addTurnover: Double
    var removeTurnover: Double
    var comment: String
}

struct PointCorrectionParameters: Codable {
    var firstName: String
    var lastName: String
    var phone: String
    var staffName: String
    var numberCheck: String
    var type: String
    var datePurchase: String
    var sumPurchase: Double
    var accruedPoints: Int
    var cardCode: String
    var shortCardCode: String
    var lastCardCode: String
    var reason: String
    var userId: String
}

struct CorrectionUpdateParameters: Codable {
    var userId: String
    var status: String
    var statusConfirmed: String
    var confirmUserId: String
}

struct PointCorrectionResponse: Codable {
    var status: String
    var message: String?
}
