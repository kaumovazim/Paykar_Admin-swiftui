//
//  AnswerModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 27.03.2025.
//

import Foundation

struct AnswerBodyModel: Codable {
    var questionId: String
    var answer: Bool
    var comment: String
}

// Модель для всего запроса
struct AnswerModel: Codable {
    var userId: Int
    var answers: [AnswerBodyModel]
}

struct ResponseAnswerModel: Codable {
    var status: String
    var message: String
}
