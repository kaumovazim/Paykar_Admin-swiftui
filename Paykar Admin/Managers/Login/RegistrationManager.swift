//
//  RegistrationManager_new.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import Foundation
import Alamofire

class RegistrationManager: ObservableObject {
    func registerUser(firstName: String, lastName: String, phone: String, position: String, unit: String, completion: @escaping (RegistrationResponseModel) -> ()) {
        
        let deviceModel = AdminModel.getDeviceModel()
        let typeOS = AdminModel.getTypeOS()
        let versionOS = AdminModel.getOSVersion()
        let ftoken = AdminModel.getFtoken()
        let imei = AdminModel.getImei()
        let ipAddress = AdminModel.getIPAddress()
        
        let projects = Projects(
            shop: position == "Супер Админ" ? true : false,
            wallet: position == "Супер Админ" ? true : false,
            logistics: position == "Супер Админ" ? true : false,
            loyalty: position == "Супер Админ" ? true : false,
            service: position == "Супер Админ" ? true : false,
            business: position == "Супер Админ" ? true : false,
            academy: position == "Супер Админ" ? true : false,
            parking: position == "Супер Админ" ? true : false,
            cashOperations: position == "Супер Админ" ? true : false,
            production: position == "Супер Админ" ? true : false
        )

        let params = RegistrationParamsModel(firstName: firstName,
                                             lastName: lastName,
                                             phone: phone,
                                             position: position,
                                             unit: unit,
                                             deviceModel: deviceModel,
                                             typeOS: typeOS,
                                             versionOS: versionOS,
                                             ftoken: ftoken,
                                             imei: imei ?? "",
                                             shop: projects.shop,
                                             wallet: projects.wallet,
                                             logistics: projects.logistics,
                                             loyality: projects.loyalty,
                                             service: projects.service,
                                             business: projects.business,
                                             academy: projects.academy,
                                             parking: projects.parking,
                                             cashOperations: projects.cashOperations,
                                             production: projects.production,
                                             ipAddress: ipAddress,
                                             lastVisit: "",
                                             longitude: "",
                                             latitude: "",
                                             status: "active",
                                             confirmed: false)
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/create.php"

        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseDecodable(of: RegistrationResponseModel.self) { response in
            DispatchQueue.main.async {
                print(response)
                if response.response?.statusCode == 200 {
                    print(response.value ?? "no value")
                    completion(response.value!)
                } else {
                    let errorMessage = response.error?.localizedDescription ?? "Unknown error occurred."
                    completion(RegistrationResponseModel(status: "error", message: errorMessage, user: nil))
                    print(errorMessage)
                }
            }
        }
    }
}
