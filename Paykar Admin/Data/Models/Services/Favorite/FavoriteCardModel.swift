//
//  FavoriteCorrectionModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/11/24.
//

import Foundation

struct FavoriteCardCreateParameters: Encodable {
    var firstName: String
    var lastName: String
    var phone: String
    var status: String
    var cardCode: String
    var shortCardCode: String
    var pointsQuantity: Int
    var accrualPointsBy: String
}
struct FavoriteCardCheckParameters: Encodable {
    var phone: String
}
struct FavoriteCardRemoveParameters: Encodable {
    var phone: String
    var status: String
}
struct FavoriteCardResponse: Codable {
    var status: String
}

struct FavoriteCardListModel: Codable, Identifiable {
    let id: String
    let createDate: String
    let firstname: String
    let lastname: String
    let phone: String
    let status: String
    let cardCode: String
    let shortCardCode: String
    let pointsQuantity: String
    let accrualPointsBy: String
    let updateDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case firstname
        case lastname
        case phone
        case status
        case cardCode = "card_code"
        case shortCardCode = "short_card_code"
        case pointsQuantity = "points_quantity"
        case accrualPointsBy = "accrual_points_by"
        case updateDate = "update_date"
    }
}

