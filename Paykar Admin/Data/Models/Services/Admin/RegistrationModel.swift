//
//  RegistrationModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import Foundation

struct RegistrationParamsModel: Encodable {
    var firstName: String
    var lastName: String
    var phone: String
    var position: String
    var unit: String
    var deviceModel: String
    var typeOS: String
    var versionOS: String
    var ftoken: String
    var imei: String
    var shop: Bool
    var wallet: Bool
    var logistics: Bool
    var loyality: Bool
    var service: Bool
    var business: Bool
    var academy: Bool
    var parking: Bool
    var cashOperations: Bool
    var production: Bool
    var ipAddress: String
    var lastVisit: String
    var longitude: String
    var latitude: String
    var status: String
    var confirmed: Bool
}

struct RegistrationResponseModel: Codable {
    var status: String?
    var message: String?
    var user: AdminModel?
}
struct VerifyCodeResponse: Codable {
    var status: String?
    var message: String?
    var user: AdminModel?
}
struct VerifyCodeParameters: Encodable {
    var phone: String
    var code: Int
}
struct AdminRequestedListResponse: Codable {
    let status: String
    let userList: [AdminListModel]
}

struct AdminListModel: Identifiable, Codable {
    let id: Int
    let createDate: String?
    let firstname: String
    let lastname: String
    let phone: String
    let position: String
    let unit: String
    var level: String
    var deviceModel: String?
    var typeOS: String?
    var versionOS: String?
    var ftoken: String?
    var imei: String?
    var ipAddress: String?
    var lastVisit: String?
    var longitude: String?
    var latitude: String?
    var editDate: String?
    var status: String
    var confirmed: Bool
    var projects: AdminProjects
    
    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case firstname
        case lastname
        case phone
        case position
        case unit
        case level
        case deviceModel = "device_model"
        case typeOS = "type_os"
        case versionOS = "version_os"
        case ftoken
        case imei
        case ipAddress = "ip_address"
        case lastVisit = "last_visit"
        case longitude
        case latitude
        case editDate = "edit_date"
        case status
        case confirmed
        case projects
    }
}

struct AdminProjects: Codable {
    var shop: Bool
    var wallet: Bool
    var logistics: Bool
    var loyalty: Bool
    var service: Bool
    var business: Bool
    var academy: Bool
    var parking: Bool
    var cashOperations: Bool
    var production: Bool
}

struct FindAdminRequest: Encodable {
    let phone: String
}

struct AdminResponse: Codable {
    let status: String
    let message: String?
    let user: AdminListModel?
}
struct AdminListResponse: Codable {
    let status: String
    let userList: [AdminListModel]
}
struct UpdateAdminResponse: Codable {
    let status: String?
    let message: String?
}
