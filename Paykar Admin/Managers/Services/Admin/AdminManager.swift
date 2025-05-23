//
//  AdminListManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 16/10/24.
//

import Foundation
import Alamofire

class AdminManager: ObservableObject {
    
    @Published var admins: [AdminListModel] = []
    @Published var requestedAdmins: [AdminListModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func getAdminList() {
        isLoading = true
        errorMessage = nil
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/user.php"
        
        AF.request(url).validate().responseDecodable(of: AdminListResponse.self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let adminListResponse):
                DispatchQueue.main.async {
                    self.admins = adminListResponse.userList
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load admins: \(error.localizedDescription)"
                    print(self.errorMessage ?? "")
                }
            }
        }
    }
    func getAdminRequestedList() {
        isLoading = true
        errorMessage = nil
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/userconfirmation.php"
        
        AF.request(url).validate().responseDecodable(of: AdminRequestedListResponse.self) { response in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch response.result {
            case .success(let adminListResponse):
                DispatchQueue.main.async {
                    self.requestedAdmins = adminListResponse.userList
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load admins: \(error.localizedDescription)"
                    print(self.errorMessage ?? "")
                }
            }
        }
    }
    func findAdminByPhone(phone: String, completion: @escaping (AdminResponse?) -> ()) {
        let url = "https://admin.paykar.tj/api/admin/adminUser/finduser.php"
        let parameters = FindAdminRequest(phone: phone)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: AdminResponse.self) { response in
            switch response.result {
            case .success(let adminResponse):
                completion(adminResponse)
            case .failure(let error):
                if let data = response.data {
                    debugPrint("Raw JSON response:", String(data: data, encoding: .utf8) ?? "Unable to decode data as UTF-8 string")
                }
                print("Error decoding response: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    func updateUser(firstName: String, lastName: String, phone: String, position: String, unit: String, shop: Bool, wallet: Bool, logistics: Bool, loyalty: Bool, service: Bool, academy: Bool, business: Bool, parking: Bool, cashOperations: Bool,  production: Bool, status: String, confirmed: Bool, completion: @escaping ([UpdateAdminResponse]) -> ()) {
        
        let deviceModel = AdminModel.getDeviceModel()
        let typeOS = AdminModel.getTypeOS()
        let versionOS = AdminModel.getOSVersion()
        let ftoken = AdminModel.getFtoken()
        let imei = AdminModel.getImei()
        let ipAddress = AdminModel.getIPAddress()
        

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
                                             shop: shop,
                                             wallet: wallet,
                                             logistics: logistics,
                                             loyality: loyalty,
                                             service: service,
                                             business: business,
                                             academy: academy,
                                             parking: parking,
                                             cashOperations: cashOperations,
                                             production: production,
                                             ipAddress: ipAddress,
                                             lastVisit: "",
                                             longitude: "",
                                             latitude: "",
                                             status: status,
                                             confirmed: confirmed)
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/update.php"

        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseDecodable(of: UpdateAdminResponse.self) { response in
            DispatchQueue.main.async {
                print(response)
                if let value = response.value {
                    completion([value])
                } else {
                    let errorMessage = response.error?.localizedDescription ?? "Unknown error occurred."
                    completion([UpdateAdminResponse(status: nil, message: errorMessage)])
                    print(errorMessage)
                }
            }
        }
    }
    
    func updateLastVVisit(compliton: @escaping (UpdateLastVisitModel) -> ()) {
        let url = "https://admin.paykar.tj/api/admin/adminUser/update/last_visit.php"
        guard let adminData = UserManager.shared.retrieveUserFromStorage() else {
            return
        }
        let phone = adminData.phone
        let params = ["phone": phone]
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseDecodable(of: UpdateLastVisitModel.self) { response in
            DispatchQueue.main.async {
                if let value = response.value {
                    compliton(value)
                } else {
                    compliton(UpdateLastVisitModel(status: "error"))
                }
            }
        }
        
    }

}
