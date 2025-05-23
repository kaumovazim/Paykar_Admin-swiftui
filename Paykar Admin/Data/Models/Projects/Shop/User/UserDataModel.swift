//
//  UserDataModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 05/09/24.
//

import Foundation

struct DeviceModel: Codable, Identifiable {
    let id: String
    let deviceModel: String
    let typeOS: String
    let versionOS: String
    let location: String?
    let versionApp: String
    let phone: String
    let createDate: String
    let updateDate: String
    let ftoken: String
    let macaddress: String?
    let newusersID: String

    enum CodingKeys: String, CodingKey {
        case id
        case deviceModel = "device_model"
        case typeOS = "type_os"
        case versionOS = "version_os"
        case location
        case versionApp = "version_app"
        case phone
        case createDate = "create_date"
        case updateDate = "update_date"
        case ftoken
        case macaddress
        case newusersID = "newusers_id"
    }
}

struct UserDataModel: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let phone: String
    let dateRegistered: String
    var status: String
    let lat: String
    let lon: String
    let devices: DeviceModel

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "firstName"
        case lastName = "lastName"
        case phone
        case dateRegistered = "date_registered"
        case status
        case lat
        case lon
        case devices
    }
}
struct UserDataResponse: Codable {
    let user: [UserDataModel]
    let devices: [DeviceModel]
}
