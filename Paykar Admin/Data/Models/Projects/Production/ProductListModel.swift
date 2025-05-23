//
//  ProductListModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 29/10/24.
//

import Foundation

struct ProductDataModel: Decodable {
    let Data: [ProductModel]
    let Total: Int?
}

struct ProductModel: Codable {
    let ProductId: Int?
    let ProductCode: String?
    let ProductName: String?
    let Brand: String?
    let Barcode: String?
    let UnitType: String?
    let IsWeight: Bool?
    let Markup: Double?
    let Price: Double?
    let Quantity: Double?
}
