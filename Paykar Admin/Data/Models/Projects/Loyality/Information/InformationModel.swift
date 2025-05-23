//
//  InformationModel.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation

struct InfomationModel: Codable {
    var AcountId: Int?
    var ClientId: Int?
    var LastName: String?
    var FirstName: String?
    var SurName: String?
    var Email: String?
    var City: String?
    var Street: String?
    var House: String?
    var Birthday: String?
    var Balance: Double?
    var AccumulateOnly: Bool?
    var Blocked: Bool?
    var IsPhoneConfirmed: Bool?
    var PhoneMobile: String?
    var CardCode: String?
    var ClientChipInfo: [ChipModel]?
}
struct CertificateInfomationModel: Codable {
    var Balance: Double
    var StartDate: String
    var FinishDate: String
    var CardStatus: String
    var CardCode: String
}

struct ChipModel: Codable {
    var MarketProgramId: Int?
    var MarketProgramName: String?
    var AddChip: Int?
    var Balance: Int?
}

struct infomationParametersModel: Encodable {
    var LicenseGuid: String
    var ShortCardCode: String
}
struct infomationBarcodeParametersModel: Encodable {
    var LicenseGuid: String
    var CardCode: String
}
struct infomationByPhoneParametersModel: Encodable {
    var LicenseGuid: String
    var MobilePhone: String
}


struct SetProfileInfoModel: Codable {
    var ClientId: Int
    var PhoneMobile: String
    var PhoneConfirmed: Bool
}

struct SetProfileInfoModelResponse: Codable{
    var code: Int?
    var Message: String?
    var Description: String?
}
struct PromoCodeModel: Codable {
    var response: String?
}
struct SmsModel: Codable, Hashable {
    var SendDate: String?
    var Title: String?
    var Message: String?
}

struct InfomationUpdateParameters: Codable {
    var clientId: String
    var phoneMobile: String
    var lastName: String?
    var firstName: String?
    var secondName: String?
    var birthdate: String?
    var email: String?
    var city: String?
    var street: String?
    var house: String?
    var acceptSms: Bool = true
    var accumulateOnly: Bool = false
    var editDate: String
    var editor: Editor
}
struct Editor: Codable {
    var accessUserId: Int
    var firstName: String
    var lastName: String
}
