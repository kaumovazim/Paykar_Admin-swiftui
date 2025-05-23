//
//  Untitled.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation

struct UnitListModel: Codable, Identifiable, Hashable {
    let name: String
    
    var id: String { name }
    
    // Реализация Hashable
    static func ==(lhs: UnitListModel, rhs: UnitListModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Декодирование строки напрямую
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(name)
    }
}
