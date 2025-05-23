//
//  PublishedUserModel.swift
//  Paykar Admin
//
//  Created by Macbook Pro on 23.04.2025.
//

import Foundation

struct PublishedUserResponseModel: Codable {
    var fullName: String?
}

struct PublishedUserRequestBody: Codable {
    var userId: String
}

