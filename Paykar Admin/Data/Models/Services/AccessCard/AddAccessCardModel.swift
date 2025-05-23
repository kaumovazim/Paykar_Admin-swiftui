//
//  AddAccessCard.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 14.03.2025.
//

import Foundation

struct AddAccessCardModel: Codable, Hashable {
    var numberCard: String?
    var status: String?
    var unit: String?
    var addCard: String?
    var position: String?
}

struct ResponseAccessCardModel: Codable, Hashable {
    var status: String?
    
}

struct ListAccessCardModel: Codable, Hashable, Identifiable {
    var id: String?
    var create_date: String?
    var number_card: String?
    var status: String?
    var unit: String?
    var add_card: String?
    var position: String?
    var update_date: String?
}
