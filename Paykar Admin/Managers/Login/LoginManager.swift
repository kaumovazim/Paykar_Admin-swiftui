//
//  AuthorizationManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 24/08/24.
//
import Alamofire
import SwiftUI
import Foundation

class LoginManager {
    
    static let shared = LoginManager()
    
    private init() {}
    
    func checkUserRegistration(phone: String, completion: @escaping (String?) -> Void) {
        let url = "https://admin.paykar.tj/api/admin/adminUser/login.php"
        
        let parameters: [String: Any] = [
            "phone": phone
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let status = json["status"] as? String {
                        if status == "success" {
                            completion(status)
                        } else if status == "error" {
                            completion(status)
                        }
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error.localizedDescription)
                }
            }
    }
}

