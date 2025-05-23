//
//  NewsModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 01.04.2025.
//

import Foundation

struct NewsCreateResponse: Codable {
    let status: String?
    let message: String?
}

struct UploadImageResponse: Codable {
    let status: String?
    let message: String?
    let imageName: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case imageName = "image" // <-- Название поля зависит от API
    }
}

// Define parameters for news creation
struct NewsModel: Codable {
    let title: String?
    let description: String?
    let image: String?
    let link: String?
    let publishedUserId: Int?
}
