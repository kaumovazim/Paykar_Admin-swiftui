//
//  OpenCloseReportModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 10/11/24.
//

import Foundation
import UIKit

struct OpenCloseReportCreateParameters: Encodable {
    let firstName: String
    let lastName: String
    let userId: String
    let unit: String
    let type: String
    let qrLocation: String
    let qrCreateDate: String
    let image: String
}
struct OpenCloseReportResponse: Codable {
    let status: String
    let message: String?
}

struct QRDataModel: Codable {
    var location: String
    var createDate: String
    var project: String
}

struct OpenCloseUploadResponse: Codable {
    let status: String
    let message: String
    let image: String?
}

struct OpenCloseReportModel: Codable, Identifiable {
    let id: String
    var create_date: String
    var status: String
    var firstname: String
    var lastname: String
    var user_id: String
    var unit: String
    var type: String
    var qr_location: String
    var qr_create_date: String
    var image: String
    var confirm_date: String?
    var confirm_status: String?
    var confirm_full_name: String?
}
