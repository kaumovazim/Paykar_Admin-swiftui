//
//  PromoManager.swift
//  Paykar Admin
//
//  Created by Firdavs Bokiev on 13/10/24.
//

import Foundation
import Alamofire

class PromoManager: ObservableObject {
    
    func sendPromoCode(phoneNumber: String, shortCardCode: String, fullName: String, quantityCode: Int, completion: @escaping (PromoCodeModel) -> ())  {
        AF.request("https://random.paykar.tj/", method: .get).responseDecodable(of: PromoCodeModel.self) { response in
            DispatchQueue.main.async {
                if(response.response?.statusCode == 200) {
                    completion(response.value!)
                } else {
                    completion(PromoCodeModel(response: ""))
                }
            }
        }
    }
}
