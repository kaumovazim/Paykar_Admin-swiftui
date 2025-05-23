//
//  QuestionListModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 27.03.2025.
//

import Foundation

struct QuestionListModel: Hashable, Codable {
    var status: String?
    var message: String?
    var checkListData: [CheckListDataModel]
    
}

struct CheckListDataModel: Hashable, Codable, Identifiable {
    var id: String
    var question: String?
    var position: String?
    
}
