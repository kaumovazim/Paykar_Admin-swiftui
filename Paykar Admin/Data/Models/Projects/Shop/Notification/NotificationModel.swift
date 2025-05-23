//
//  NotificationModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 26/09/24.
//

import Foundation

struct NotificationModel: Identifiable, Codable {
    let id: Int
    let createDate: String
    let title: String
    let description: String
    let picture: String?
    let link: String?
}

struct NotificationCategoryModel: Identifiable, Codable {
    let categoryId: Int
    let categoryName: String
    let categoryPicture: String?
    let categoryItemList: [NotificationModel]
    
    var id: Int {
        return categoryId
    }
}
struct CreateNotificationResponse: Decodable {
    let status: String
    let message: String
}
