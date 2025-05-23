//
//  MessageManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 23/10/24.
//

import Foundation
import Alamofire

class MessageManager: ObservableObject {
    
    func sendSms(phone: String, sms: String, userId: Int, completion: @escaping (SmsResponse) -> ()) {
        
        let url = "https://admin.paykar.tj/api/admin/adminUser/messagelist/sendSms.php"
        
        let parameters = SmsParameter(phone: phone, sms: sms, userId: userId)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: SmsResponse.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let smsResponse):
                    completion(smsResponse)
                case .failure(let error):
                    let errorMessage = error.localizedDescription
                    completion(SmsResponse(status: "error", message: errorMessage))
                }
            }
        }
    }
    
    func sendNewYearSms(firstName: String, lastName: String, phone: String, cardCode: String, numberCheck: String, purchaseAmount: String, datePurchase: String, completion: @escaping (SmsResponse) -> ()) {
        
        let url = "https://admin.paykar.tj/api/loyalty/new_year_promotion/create.php"
        
        let parameters = NewYearPromotionMessageParameters(firstName: firstName, lastName: lastName, phone: phone, longCardCode: cardCode, numberCheck: numberCheck, purchaseAmount: purchaseAmount, datePurchase: datePurchase)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: SmsResponse.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let smsResponse):
                    completion(smsResponse)
                case .failure(let error):
                    let errorMessage = error.localizedDescription
                    completion(SmsResponse(status: "error", message: errorMessage))
                }
            }
        }
    }

}
