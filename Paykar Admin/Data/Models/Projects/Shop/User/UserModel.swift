//
//  UserModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 30/08/24.
//

import SwiftUI

struct UserModel: Codable, Identifiable {
    let id: String
    let login: String
    let name: String?
    let lastName: String?
    let dateRegister: String?
    let active: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case login = "LOGIN"
        case name = "NAME"
        case lastName = "LAST_NAME"
        case dateRegister = "DATE_REGISTER"
        case active = "ACTIVE"
    }
}

struct UserResponse: Codable {
    let status: String
    let users: [UserModel]
}

