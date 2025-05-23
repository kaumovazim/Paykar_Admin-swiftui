//
//  OrderModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 02/09/24.
//

import Foundation

struct OrderModel: Codable, Identifiable {
    var id: Int
    var createDate: String
    var payed: String
    var deducted: String
    var statusId: String
    var statusDate: String?
    var deliveryTypeId: Int
    var deliveryPrice: String
    var desiredDateTime: String?
    var deliveryAddress: String?
    var price: String
    var discountValue: String
    var paid: String
    var comments: String?
    var canceled: String
    var canceledDate: String?
    var canceledReason: String?
    var userFirstName: String?
    var userLastName: String?
    var userPhone: String?
    var productOrderCount: Int
    var productOrder: [ProductOrder]
}
struct ProductOrder: Codable, Identifiable {
    var id: String { productId }
    var productId: String
    var productName: String
    var productPrice: String
    var productQuantity: String
    var productUnit: String
    var productPicture: String
}
