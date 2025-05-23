//
//  PositionListModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 03.04.2025.
//

import Foundation

struct PositionListModel: Codable, Identifiable, Hashable {
    let name: String
    
    var id: String { name }
    
    static func ==(lhs: PositionListModel, rhs: PositionListModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(name)
    }
}
