//
//  UserByUnitPositionModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation

struct UserByUnitPositionModel: Codable, Identifiable, Hashable {
    let firstName: String
    let lastName: String
    let secondName: String
    let tabelID: String
    let position: String
    let unit: String
    let status: String
    let depositsDate: String
    let dismissalsDate: String
    
    // Вычисляемое свойство id
    var id: String { tabelID }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case secondName
        case tabelID
        case position
        case unit
        case status
        case depositsDate
        case dismissalsDate
    }
    
    static func ==(lhs: UserByUnitPositionModel, rhs: UserByUnitPositionModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
