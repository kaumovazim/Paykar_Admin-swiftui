//
//  TopListModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 07.04.2025.
//

import Foundation

struct TopListParametersModel: Codable, Hashable {
    var startDate: String
    var endDate: String
    var startTime: String
    var endTime: String
    var holidays: Int
    var allowedUnits: [String]
    var type: String
}

struct TopListBodyModel: Identifiable, Codable {
    let tabelID: String
    let firstName: String
    let lastName: String
    let secondName: String
    let unit: String
    let position: String
    let workedDays: Int
    let overtimeHours: Double
    let underworkedHours: Double
    let lateDays: Int
    let lateHours: Double
    let missedDays: Int
    
    var id: String { tabelID }
}

struct TopResponseModel: Codable {
    let topMissed: [TopListBodyModel]?
    let topUnderworked: [TopListBodyModel]?
    let topOvertime: [TopListBodyModel]?
    let topLate: [TopListBodyModel]?
    
    // Кодирование/декодирование для динамических ключей
    enum CodingKeys: String, CodingKey {
        case topMissed
        case topUnderworked
        case topOvertime
        case topLate
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topMissed = try container.decodeIfPresent([TopListBodyModel].self, forKey: .topMissed)
        topUnderworked = try container.decodeIfPresent([TopListBodyModel].self, forKey: .topUnderworked)
        topOvertime = try container.decodeIfPresent([TopListBodyModel].self, forKey: .topOvertime)
        topLate = try container.decodeIfPresent([TopListBodyModel].self, forKey: .topLate)
    }
    enum TopType: String {
        case missed = "topMissed"
        case underworked = "topUnderworked"
        case overtime = "topOvertime"
        case late = "topLate"
    }
}

