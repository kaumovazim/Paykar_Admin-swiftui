//
//  VerificationManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation
import Alamofire

class VerificationManager {
    
    static let shared = VerificationManager()
    
    private init() {}
    
    func verifyCode(phone: String, code: String, completion: @escaping (String?, String?, AdminModel?) -> Void) {
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/confirmation.php"
        
        let parameters: [String: Any] = [
            "phone": phone,
            "code": code
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let status = json["status"] as? String {
                        if status == "success", let userData = json["user"] as? [String: Any] {
                            
                            let projectsData = userData["projects"] as? [String: Bool] ?? [:]
                            let projects = Projects(
                                shop: projectsData["shop"] ?? false,
                                wallet: projectsData["wallet"] ?? false,
                                logistics: projectsData["logistics"] ?? false,
                                loyalty: projectsData["loyalty"] ?? false,
                                service: projectsData["service"] ?? false,
                                business: projectsData["business"] ?? false,
                                academy: projectsData["academy"] ?? false,
                                parking: projectsData["parking"] ?? false,
                                cashOperations: projectsData["cashOperations"] ?? false,
                                production: projectsData["production"] ?? false
                            )
                            
                            let user = AdminModel(
                                id: userData["id"] as? Int ?? 0,
                                create_date: userData["create_date"] as? String ?? "",
                                firstname: userData["firstname"] as? String ?? "",
                                lastname: userData["lastname"] as? String ?? "",
                                phone: userData["phone"] as? String ?? "",
                                position: userData["position"] as? String ?? "",
                                unit: userData["unit"] as? String ?? "",
                                level: userData["level"] as? String ?? "0",
                                device_model: userData["device_model"] as? String ?? "",
                                type_os: userData["type_os"] as? String ?? "",
                                version_os: userData["version_os"] as? String ?? "",
                                ftoken: userData["ftoken"] as? String ?? "",
                                imei: userData["imei"] as? String ?? "",
                                ip_address: userData["ip_address"] as? String ?? "",
                                last_visit: userData["last_visit"] as? String ?? "",
                                longitude: userData["longitude"] as? String ?? "",
                                latitude: userData["latitude"] as? String ?? "",
                                edit_date: userData["edit_date"] as? String ?? "",
                                status: userData["status"] as? String ?? "active",
                                confirmed: userData["confirmed"] as? Bool ?? false,
                                projects: projects
                            )
                            
                            completion("success", nil, user)
                        } else {
                            let message = json["message"] as? String ?? "Unknown error occurred."
                            completion(nil, message, nil)
                            print(message)
                        }
                    } else {
                        completion(nil, "Invalid server response.", nil)
                        print("Invalid server response.")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription, nil)
                    print(error.localizedDescription)
                }
            }
    }

    func sendCode(phone: String, completion: @escaping (Bool, String?) -> Void) {
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/sendcode.php"
        
        let parameters: [String: Any] = [
            "phone": phone,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let status = json["status"] as? String {
                        if status == "success" {
                            completion(true, nil)
                        } else {
                            let message = json["message"] as? String ?? "Unknown error occurred."
                            completion(false, message)
                        }
                    } else {
                        completion(false, "Invalid server response.")
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
    }
}
